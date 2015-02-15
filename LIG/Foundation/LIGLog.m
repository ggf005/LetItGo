//
//  LIGLog.m
//  LIG
//
//  Created by gongguifei on 15/2/15.
//  Copyright (c) 2015年 Gong Guifei. All rights reserved.
//

#import "LIGLog.h"
#include <sys/stat.h>

static float kLIGLogMaxSize    = 20 *1024 * 1024; //单个日志文件最大容量
static NSString *const kLIGLogFolder = @"LIGLog"; //日志文件夹


extern NSString *describeWithLogLevel(LIGLogLevel logLevel);


@interface LIGLogManager : NSObject

@property (nonatomic, assign, getter=isWriteToConsole) BOOL writeToConsole;//是否输出到控制台，默认为YES
@property (nonatomic, assign, getter=isWriteToFile) BOOL writeToFile;//是否写入文件，默认为NO

+ (instancetype)sharedInstance;

- (void)appendLog:(NSString *)log;
@end


@interface LIGLogManager ()
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSMutableArray *logs;
@property (nonatomic, strong) NSCondition * lock;
@end

@implementation LIGLogManager

+ (instancetype)sharedInstance
{
    static LIGLogManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LIGLogManager alloc] init];

    });
    
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        self.date = [NSDate date];
        self.lock = [[NSCondition alloc] init];
        self.logs = [[NSMutableArray alloc] init];
        
        self.writeToConsole = YES;
        self.writeToFile = YES;
        
        [self createLogFolderIfNecessary];
        
        [self startLogThread];
    }
    return self;
}

- (void)startLogThread
{
    NSThread *thread =  [[NSThread alloc] initWithTarget:self selector:@selector(writeLog) object:nil];
    [thread start];
}

- (void)appendLog:(NSString *)log
{
    [self.lock lock];
    [self.logs addObject:log];
    [self.lock signal];
    [self.lock unlock];
    
    //控制台日志不在线程中处理，保证实时性
    if (self.writeToConsole) {
        [self writeConsoleWithLog:log];
    }
}

- (void)writeLog
{
    do {
        
        @autoreleasepool {
            [self.lock lock];
            
            if ([self.logs count] == 0) {
                [self.lock wait];
            }
            
            NSString *log = [self.logs firstObject];
            
            if (self.writeToFile) {
                [self writeFileWithLog:log];
            }
            
            [self.logs removeObject:log];
            
            [self.lock unlock];
        }
        
    } while (YES);
}

- (void)writeConsoleWithLog:(NSString *)log
{
    printf("%s\n", [log UTF8String]);
}

- (void)writeFileWithLog:(NSString *)log
{
    NSString *filePath = [self getCurrentLogFilePath];
    FILE *file = fopen([filePath UTF8String], "a+b");
    
    if (file != NULL) {
        fwrite([log UTF8String], [log length], 1, file);
        fclose(file);
    }
    
    //判断是否需要新建日志文件
    struct stat st;
    if (stat([filePath UTF8String], &st) == 0) {
        if (st.st_size >= kLIGLogMaxSize) {
            self.date = [NSDate date];
        }
    }
    
}
#pragma mark - 日志路径

//创建日志目录
- (void)createLogFolderIfNecessary
{
    NSString *folder = [self getLogFolder];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:folder]) {
        [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

//获取日志目录
- (NSString *)getLogFolder
{
    NSString *folder = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), kLIGLogFolder];
    return folder;
}
//获取当前日志路径
- (NSString *)getCurrentLogFilePath
{
    NSString *folder = [self getLogFolder];
    
    NSString *processName = [[NSProcessInfo processInfo] processName];
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.log", processName, [self.date description]];
    
    return [folder stringByAppendingPathComponent:fileName];
    
}
@end

//设置日志开关
void LIGOpenLog(BOOL console, BOOL file)
{
    LIGLogManager *logManager = [LIGLogManager sharedInstance];
    logManager.writeToConsole = console;
    logManager.writeToFile = file;
}

//写日志
void LIGWriteLog(LIGLogLevel logLevel, const char *file, const char *func, int line, NSString *format, ...)
{
    
    NSString *content = nil;
    
    va_list args;
    va_start(args, format);
    content = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    NSString *logDesc = describeWithLogLevel(logLevel);

    [[LIGLogManager sharedInstance] appendLog:[NSString stringWithFormat:@"[%@] %@:\n%s \n%s [line %d] : %@\n", [[NSDate date] descriptionWithLocale:[NSLocale currentLocale]], logDesc, file,func, line, content]];
    
}

//获取所选日志级别对应的显示内容
NSString *describeWithLogLevel(LIGLogLevel logLevel)
{
    NSString *describe = nil;
    switch (logLevel) {
        case LIGLogLevelDebug:
            describe = @"DEBUG";
            break;
        case LIGLogLevelInfo:
            describe = @"INFO";
            break;
        case LIGLogLevelWarning:
            describe = @"WARNING";
            break;
        case LIGLogLevelError:
            describe = @"ERROR";
            break;
        default:
            describe = [NSString stringWithFormat:@"LOG %d", logLevel];
            break;
    }
    return describe;
}
