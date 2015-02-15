//
//  LIGLog.h
//  LIG
//
//  Created by gongguifei on 15/2/15.
//  Copyright (c) 2015年 Gong Guifei. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LIGLogDebug(format,...) LIGWriteLog(LIGLogLevelDebug, __FILE__, __FUNCTION__, __LINE__, (format), __VA_ARGS__)
#define LIGLogInfo(format,...)  LIGWriteLog(LIGLogLevelInfo, __FILE__, __FUNCTION__, __LINE__, (format), __VA_ARGS__)
#define LIGLogWarn(format,...)  LIGWriteLog(LIGLogLevelWarning, __FILE__, __FUNCTION__, __LINE__, (format), __VA_ARGS__)
#define LIGLogError(format,...) LIGWriteLog(LIGLogLevelError, __FILE__, __FUNCTION__, __LINE__, (format), __VA_ARGS__)

#define LIGLog(format,...) LIGLogDebug(format, __VA_ARGS__)

//日志级别
typedef enum {
    LIGLogLevelDebug = 0,   //调试日志
    LIGLogLevelInfo,        //信息日志
    LIGLogLevelWarning,     //警告日志
    LIGLogLevelError,       //错误日志
}LIGLogLevel;

//设置日志开关，默认同时写入控制台及文件
void LIGOpenLog(BOOL console, BOOL file);

//写入日志
void LIGWriteLog(LIGLogLevel logLevel, const char *file, const char *func, int line, NSString *format, ...);

