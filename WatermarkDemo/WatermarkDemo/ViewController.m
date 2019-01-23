//
//  ViewController.m
//  WatermarkDemo
//
//  Created by CharlieLv on 2019/1/23.
//  Copyright © 2019 charlie. All rights reserved.
//

#import "ViewController.h"

#import "WatermarkImage.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    WatermarkImage * wkImgView =[[WatermarkImage alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) withText:@"Charlie_lv"];
    // 想要水印不被任何UI遮挡住，就在最后、最后、最后的时候添加
    [self.view addSubview:wkImgView];
}


@end
