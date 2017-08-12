//
//  ONELoginViewController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/12.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONELoginViewController.h"

@interface ONELoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lawInfoLabel;

@end

@implementation ONELoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *text = self.lawInfoLabel.text;
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:text attributes:attribtDic];
    self.lawInfoLabel.attributedText = attribtStr;
    
}
- (IBAction)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
