//
//  LIGLogTests.m
//  LIG
//
//  Created by gongguifei on 15/2/15.
//  Copyright (c) 2015年 Gong Guifei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <LIG/LIG.h>

@interface LIGLogTests : XCTestCase

@end

@implementation LIGLogTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}
//
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

- (void)testWriteLog
{
    for (int i = 0; i < 10; i++) {
        LIGLog(@"test write log %d", i);
    }

    LIGLog(@"%@", @{@"key":@"value"});
    
    
}
@end
