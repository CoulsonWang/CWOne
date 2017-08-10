//
//  ONEHomeDiaryViewController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/10.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeDiaryViewController.h"
#import "UIImage+Render.h"
#import "UIImage+CWColorAndStretch.h"
#import <Masonry.h>
#import "ONEMainTabBarController.h"
#import "ONEHomeWeatherItem.h"
#import "NSString+ONEComponents.h"
#import "UITextView+CWLineSpacing.h"

#define kRatioOfHorizontal 207/311.0
#define kRatioOfVertical 338/311.0
#define kBottomSpace 200
#define kLineSpacing 10.0
#define kMinTextViewBackgroundHeight 160.0

@interface ONEHomeDiaryViewController () <UITextViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UILabel *timeLabel;
@property (weak, nonatomic) UILabel *placeLabel;
@property (weak, nonatomic) UIImageView *coverImageView;
@property (weak, nonatomic) UIImageView *diaryTipImageView;
@property (weak, nonatomic) UILabel *coverInfoLabel;
@property (weak, nonatomic) UIView *textBackgroundView;
@property (weak, nonatomic) UITextView *textView;
@property (weak, nonatomic) UILabel *authorNameLabel;

@end

@implementation ONEHomeDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpSubViews];
    
    [self setUpNavigation];
    
    [self loadData];

    [self setUpNotification];

}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpSubViews {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.contentSize = CGSizeMake(0, CWScreenH);
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.scrollView = scrollView;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont fontWithName:ONEThemeFontName size:22];
    [scrollView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_top).offset(15);
        make.centerX.equalTo(scrollView);
    }];
    self.timeLabel = timeLabel;
    
    UILabel *placeLabel = [[UILabel alloc] init];
    placeLabel.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:placeLabel];
    [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(5);
        make.centerX.equalTo(scrollView);
    }];
    self.placeLabel = placeLabel;
    
    UIImageView *coverImageView = [[UIImageView alloc] init];
    coverImageView.userInteractionEnabled = YES;
    [coverImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhotoPicker)]];
    [scrollView addSubview:coverImageView];
    [coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(placeLabel.mas_bottom).offset(8);
        make.centerX.equalTo(scrollView);
        make.width.equalTo(@(CWScreenW));
    }];
    self.coverImageView = coverImageView;
    
    UIImageView *diaryTipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DiaryTipImage"]];
    [scrollView addSubview:diaryTipImageView];
    [diaryTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(coverImageView.mas_bottom).offset(-5);
        make.centerX.equalTo(scrollView);
    }];
    self.diaryTipImageView = diaryTipImageView;
    
    UILabel *coverInfoLabel = [[UILabel alloc] init];
    coverInfoLabel.textColor = [UIColor colorWithWhite:135/255.0 alpha:1.0];
    coverInfoLabel.font = [UIFont systemFontOfSize:12.5];
    [scrollView addSubview:coverInfoLabel];
    [coverInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coverImageView.mas_bottom).offset(5);
        make.centerX.equalTo(scrollView);
    }];
    self.coverInfoLabel = coverInfoLabel;
    
    UIView *textBackgroundView = [[UIView alloc] init];
    textBackgroundView.backgroundColor = [UIColor colorWithWhite:252/255.0 alpha:1.0];
    textBackgroundView.layer.borderColor = [UIColor colorWithWhite:244/255.0 alpha:1.0].CGColor;
    textBackgroundView.layer.borderWidth = 2;
    textBackgroundView.layer.cornerRadius = 10;
    [scrollView addSubview:textBackgroundView];
    [textBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(CWScreenW - 80));
        make.centerX.equalTo(scrollView);
        make.top.equalTo(coverInfoLabel.mas_bottom).offset(20);
        make.height.equalTo(@(kMinTextViewBackgroundHeight));
    }];
    self.textBackgroundView = textBackgroundView;
    
    UITextView *textView = [[UITextView alloc] init];
    textView.font = [UIFont systemFontOfSize:16];
    textView.backgroundColor = [UIColor clearColor];
    textView.returnKeyType = UIReturnKeyDone;
    textView.delegate = self;
    textView.scrollEnabled = NO;
    [scrollView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBackgroundView.mas_left).offset(5);
        make.right.equalTo(textBackgroundView.mas_right).offset(-5);
        make.top.equalTo(textBackgroundView).offset(10);
        make.bottom.equalTo(textBackgroundView.mas_bottom).offset(-10);
    }];
    self.textView = textView;
    
    UILabel *authorNameLabel = [[UILabel alloc] init];
    authorNameLabel.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:authorNameLabel];
    [authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textBackgroundView.mas_bottom).offset(10);
        make.centerX.equalTo(scrollView);
    }];
    self.authorNameLabel = authorNameLabel;
    
    
}

- (void)setUpNavigation {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalRenderMode:@"back_dark"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissTheDiaryController)];
    self.title = @"小记";
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalRenderMode:@"contentSave"] style:UIBarButtonItemStylePlain target:self action:@selector(saveContentButtonClick)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalRenderMode:@"share_dark"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonClick)];
    self.navigationItem.rightBarButtonItems = @[saveButton, shareButton];
}

- (void)setUpNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)loadData {
    ONEMainTabBarController *tabBarVC = (ONEMainTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    NSDateComponents *components = [tabBarVC.weatherItem.date getComponents];
    self.timeLabel.text = [NSString stringWithFormat:@"%ld / %02ld / %02ld",components.year,components.month,components.day];
    self.placeLabel.text = [NSString stringWithFormat:@"%@, %@",tabBarVC.weatherItem.climate,tabBarVC.weatherItem.city_name];
    
    CGFloat ratio = (self.orientation.integerValue == 0) ? kRatioOfHorizontal : kRatioOfVertical;
    CGFloat coverHeight = CWScreenW * ratio;
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(coverHeight));
    }];
    self.coverImageView.image = self.coverImage;
    
    self.coverInfoLabel.text = self.subTitleString;
    
    [self.textView setText:self.contentString lineSpacing:kLineSpacing];
    [self updateTextViewAndBackgroundFrame];
    
    
    self.authorNameLabel.text = self.authorInfoString;
    
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.authorNameLabel.frame) + kBottomSpace);
}
#pragma mark - 私有方法
- (void)updateTextViewAndBackgroundFrame {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:kLineSpacing];
    
    CGRect rect = [self.textView.text boundingRectWithSize:CGSizeMake(CWScreenW - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.textView.font, NSParagraphStyleAttributeName : paragraphStyle} context:nil];
    
    CGFloat newHeight = rect.size.height + 70;
    if (newHeight <= kMinTextViewBackgroundHeight) {
        newHeight = kMinTextViewBackgroundHeight;
    }
    [self.textBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(newHeight));
    }];
    [self.scrollView layoutIfNeeded];
}

#pragma mark - 事件响应
- (void)dismissTheDiaryController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveContentButtonClick {
    
}

- (void)shareButtonClick {
    
}

- (void)showPhotoPicker {
    // 显示拍照、相册选择界面
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect frame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, frame.size.height, 0);
    
    CGFloat offsetY = CGRectGetMinY(self.textBackgroundView.frame) - 150;
    [self.scrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UITextViewDelegate 
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        return NO;
    } else {
        return YES;
    }
}
- (void)textViewDidChange:(UITextView *)textView {
    self.authorNameLabel.hidden = ![textView.text isEqualToString:self.contentString];
    [self updateTextViewAndBackgroundFrame];
}

@end
