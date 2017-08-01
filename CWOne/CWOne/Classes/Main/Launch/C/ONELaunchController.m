//
//  ONELaunchController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONELaunchController.h"
#import "NSString+CWTranslate.h"
#import "ONEMainTabBarController.h"

@interface ONELaunchController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ONELaunchController

#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeLabel.text = [self getCurrentDateString];
    
}

- (void)viewDidAppear:(BOOL)animated {
    sleep(1.5);
    
    [self changeRootContoller];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - 私有方法
- (NSString *)getCurrentDateString {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    NSInteger year = components.year;
    NSMutableString *yearStr = [NSMutableString string];
    [yearStr appendString:[NSString chineseNumberWithNumber:year/1000]];
    [yearStr appendString:[NSString chineseNumberWithNumber:(year%1000)/100]];
    [yearStr appendString:[NSString chineseNumberWithNumber:(year%100)/10]];
    [yearStr appendString:[NSString chineseNumberWithNumber:year%10]];
    
    
    NSInteger month = components.month;
    NSMutableString *monStr = [NSMutableString string];
    if (month>=10) {
        [monStr appendString:[NSString chineseNumberWithNumber:month/10]];
    }
    [monStr appendString:[NSString chineseNumberWithNumber:month%10]];
    
    
    NSInteger day = components.day;
    NSMutableString *dayStr = [NSMutableString string];
    if (day>=10) {
        [dayStr appendString:[NSString chineseNumberWithNumber:day/10]];
    }
    [dayStr appendString:[NSString chineseNumberWithNumber:day%10]];
    
    NSString *str = [NSString stringWithFormat:@"地球历%@年%@月%@日",yearStr,monStr,dayStr];
    return str;
}

- (void)changeRootContoller {
    ONEMainTabBarController *tabBarVC = [[ONEMainTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
}

@end
