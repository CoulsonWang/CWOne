//
//  ONECategoryChooserView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/16.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONECategoryChooserView;

@protocol ONECategoryChooserViewDelegate <NSObject>

- (void)categoryChooserViewDidCancleChoose:(ONECategoryChooserView *)categoryChooserView;

- (void)categoryChooserView:(ONECategoryChooserView *)categoryChooserView didChooseAtIndex:(NSInteger)index;

@end

@interface ONECategoryChooserView : UIView

@property (weak, nonatomic) id<ONECategoryChooserViewDelegate> delegate;

- (void)showChooserView;

- (void)hideChooserView;

@end
