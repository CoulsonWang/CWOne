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
#import "ONENetworkTool.h"
#import "ONEHomeItem.h"
#import "ONEHomeWeatherItem.h"
#import "ONERadioTool.h"
#import "ONEHomeMenuItem.h"

@interface ONELaunchController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ONELaunchController

#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeLabel.text = [self getCurrentDateString];
    
    self.imageView.image = [self getWeekdayImage];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    // 加载电台数据，完毕后加载首页数据
    [[ONERadioTool sharedInstance] loadRadioDataCompletion:^{
        // 加载网络数据，加载完毕后切换控制器
        [self loadData];
    }];
    
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

- (UIImage *)getWeekdayImage {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE";
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    return [UIImage imageNamed:str];
}

- (void)loadData {
//    NSString *date = @"2017-08-02";
    [[ONENetworkTool sharedInstance] requestHomeDataWithDate:nil success:^(NSDictionary *dataDict) {
        
        NSDictionary *weatherDict = dataDict[@"weather"];
        ONEHomeWeatherItem *weatherItem = [ONEHomeWeatherItem weatherItemWithDict:weatherDict];
        
        NSDictionary *menuDict = dataDict[@"menu"];
        ONEHomeMenuItem *menuItem = [ONEHomeMenuItem menuItemWithDict:menuDict];
        
        NSArray<NSDictionary *> *contentList = dataDict[@"content_list"];
        NSMutableArray<ONEHomeItem *> *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in contentList) {
            ONEHomeItem *item = [ONEHomeItem homeItemWithDict:dict];
            [tempArray addObject:item];
        }
        
        [self changeRootContollerWith:tempArray weatherItem:weatherItem menuItem:menuItem];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)changeRootContollerWith:(NSArray *)homeItems weatherItem:(ONEHomeWeatherItem *)weatherItem menuItem:(ONEHomeMenuItem *)menuItem {
    ONEMainTabBarController *tabBarVC = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
    
    tabBarVC.homeItems = homeItems;
    tabBarVC.weatherItem = weatherItem;
    tabBarVC.menuItem = menuItem;
    
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
}

@end
