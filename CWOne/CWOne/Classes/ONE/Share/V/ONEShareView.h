//
//  ONEShareView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/12.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEShareView;

@protocol ONEShareViewDelegate <NSObject>

- (void)didCopyShareLink:(ONEShareView *)shareView;

@end

@interface ONEShareView : UIView

@property (weak, nonatomic) id<ONEShareViewDelegate> delegate;

@property (strong, nonatomic) NSString *shareUrl;

- (void)showShareAnimaton;


@end
