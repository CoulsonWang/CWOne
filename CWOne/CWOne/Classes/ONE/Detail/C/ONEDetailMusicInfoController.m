//
//  ONEDetailMusicInfoController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/9.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEDetailMusicInfoController.h"

@interface ONEDetailMusicInfoController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIScrollView *pageScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation ONEDetailMusicInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageScrollView.contentSize = CGSizeMake(CWScreenW * 2, 0);
    
    [self setUpContentScrollView];
}

- (void)setUpContentScrollView {
    
}

- (IBAction)segmentControlChangeValue:(UISegmentedControl *)sender {
}
- (IBAction)closeButtonClick:(UIButton *)sender {
}

@end
