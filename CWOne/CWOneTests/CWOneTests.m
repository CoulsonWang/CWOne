//
//  CWOneTests.m
//  CWOneTests
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+CWTranslate.h"
#import <objc/message.h>

@interface CWOneTests : XCTestCase

@end

@implementation CWOneTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    
    unsigned int num;
    Ivar *ivars = class_copyIvarList([UIApplication class], &num);
    for (int i=0; i < num; i++) {
        Ivar var = ivars[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(var)];
        NSLog(@"%@",key);
    }
    
    XCTAssert(1,@"错误");
    
}



@end
