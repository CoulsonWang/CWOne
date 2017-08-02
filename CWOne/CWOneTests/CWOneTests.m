//
//  CWOneTests.m
//  CWOneTests
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+CWTranslate.h"

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
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE";
    
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    NSLog(@"%@",str);
    
    XCTAssert([str isEqualToString:@"Wed"],@"错误");
    
}



@end
