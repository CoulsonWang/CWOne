//
//  ONEHomeViewModel.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeViewModel.h"
#import "ONEHomeItem.h"
#import "ONEUserItem.h"

@implementation ONEHomeViewModel

+ (instancetype)viewModelWithItem:(ONEHomeItem *)homeItem {
    ONEHomeViewModel *viewModel = [[ONEHomeViewModel alloc] init];
    viewModel.homeItem = homeItem;
    
    return viewModel;
}

- (void)setHomeItem:(ONEHomeItem *)homeItem {
    _homeItem = homeItem;
    
    // 处理类型标题
    NSString *styleStr;
    if (homeItem.tag_title != nil) {
        styleStr = homeItem.tag_title;
    } else {
        styleStr = homeItem.typeName;
    }
    self.categoryTitle = [NSString stringWithFormat:@"- %@ -",styleStr];
    
    // 处理作者名
    NSString *authorStr;
    if (homeItem.type == ONEHomeItemTypeQuestion) {
        authorStr = homeItem.answererItem.user_name;
    } else {
        authorStr = [NSString stringWithFormat:@"文 / %@",homeItem.authorItem.user_name];
    }
    self.authorString = authorStr;
    
    // 处理时间标签
    self.timeStr = [self getDateStrWithDate:homeItem.post_date];
    
    // 处理小记下方的文本
    self.subTitle = [NSString stringWithFormat:@"%@ | %@",homeItem.title,homeItem.pic_info];
    
    self.moviewSubTitle = [NSString stringWithFormat:@"————《%@》 ",homeItem.subtitle];
    
    self.musicInfoStr = [NSString stringWithFormat:@"%@ · %@ | %@",homeItem.music_name,homeItem.audio_author,homeItem.audio_album];
    
    if (homeItem.audio_platform == 1) {
        self.musicPlatformImage = [UIImage imageNamed:@"ONEXiamiMusicCopyright"];
    } else if (homeItem.audio_platform == 2) {
        self.musicPlatformImage = [UIImage imageNamed:@"ONEMusicCopyright"];
    } else {
        self.musicPlatformImage = [UIImage imageNamed:@"ONEAndXiamiMusicCopyright"];
    }
    
    self.musicUrl = (homeItem.audio_platform == 2) ? homeItem.audio_url : @"xiami";
}


#pragma mark - 工具方法

// 通过一个字符串比较其时间与当前时间是否是同一天,计算出标签文本
- (NSString *)getDateStrWithDate:(NSString *)dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *resultDate = [formatter dateFromString:dateStr];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *resultComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:resultDate];
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    if (nowComponents.year == resultComponents.year && nowComponents.month == resultComponents.month && nowComponents.day == resultComponents.day) {
        return @"今天";
    } else if (nowComponents.year == resultComponents.year) {
        return [NSString stringWithFormat:@"%ld月%ld日",resultComponents.month,resultComponents.day];
    } else {
        return [NSString stringWithFormat:@"%ld年%ld月%ld日",resultComponents.year,resultComponents.month,resultComponents.day];
    }
}

@end
