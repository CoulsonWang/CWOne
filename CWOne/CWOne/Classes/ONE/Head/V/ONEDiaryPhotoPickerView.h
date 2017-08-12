//
//  ONEDiaryPhotoPickerView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/12.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEDiaryPhotoPickerView;

@protocol ONEDiaryPhotoPickerViewDelegate <NSObject>

- (void)photoPickerView:(ONEDiaryPhotoPickerView *)photoPickerView didPickImage:(UIImage *)image;

@end

@interface ONEDiaryPhotoPickerView : UIView

@property (weak, nonatomic) id<ONEDiaryPhotoPickerViewDelegate> delegate;

- (void)showPhotoPickerView;

@end
