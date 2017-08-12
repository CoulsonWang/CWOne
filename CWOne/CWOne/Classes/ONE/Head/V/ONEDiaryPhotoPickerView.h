//
//  ONEDiaryPhotoPickerView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/12.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ONEDiaryPhotoPickerView : UIView

@property (weak, nonatomic) id<UIImagePickerControllerDelegate, UINavigationControllerDelegate> delegate;

- (void)showPhotoPickerView;

@end
