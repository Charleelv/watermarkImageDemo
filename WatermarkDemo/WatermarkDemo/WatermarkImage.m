//
//  WatermarkImage.m
//  WatermarkDemo
//
//  Created by CharlieLv on 2019/1/23.
//  Copyright © 2019 charlie. All rights reserved.
//

#import "WatermarkImage.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

/* 这三个属性 主要是让水印文字和水印文字之间间隔的效果，以及水印的文字的倾斜角度 ，不设置默认为平行角度*/
#define HORIZONTAL_SPACEING 30//水平间距
#define VERTICAL_SPACEING 50//竖直间距
#define CG_TRANSFORM_ROTATING (-M_PI_2 / 3)//旋转角度(正旋45度 || 反旋45度)


@implementation WatermarkImage

-(instancetype)initWithFrame:(CGRect)frame withText:(NSString *)text
{
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0.4;  //设置水印透明
        //添加水印 ：  Watermark 类文件    WaterImageWithImage：水印图片 设置为 @""就是透明背景效果   text：传入自己想要的水印文字
        self.image = [WatermarkImage view:self WaterImageWithImage:[UIImage imageNamed:@""] text:text];
    }
    return self;
}


+(UIImage*)view:(UIImageView *)view WaterImageWithImage:(UIImage *)image text:(NSString *)text{
    
    //设置水印大小，可以根据图片大小或者view大小
    CGFloat  img_w = view.bounds.size.width;
    CGFloat  img_h = view.bounds.size.height;
    
    //1.开启上下文
    //    UIGraphicsBeginImageContext(CGSizeMake(img_w, img_h));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(WIDTH, HEIGHT), NO, 0.0);
    //2.绘制图片 水印图片
    [image drawInRect:CGRectMake(0, 0, img_w, img_h)];
    
    /* --添加水印文字样式--*/
    UIFont * font = [UIFont systemFontOfSize:23.0]; //水印文字大小
    NSDictionary * attr = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor orangeColor]};
    NSMutableAttributedString * attr_str =[[NSMutableAttributedString alloc]initWithString:text attributes:attr];
    
    //文字：字符串的宽、高
    CGFloat str_w = attr_str.size.width;
    CGFloat str_h = attr_str.size.height;
    
    //根据中心开启旋转上下文矩阵，绘制水印文字
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //将绘制原点（0，0）调整到源image的中心
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(img_w/2, img_h/2));
    //以绘制原点为中心旋转
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(CG_TRANSFORM_ROTATING));
    
    //将绘制原点恢复初始值，保证context中心点和image中心点处在一个点(当前context已经发生旋转，绘制出的任何layer都是倾斜的)
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-WIDTH/2, -HEIGHT/2));
    
    //sqrtLength：原始image对角线length。在水印旋转矩阵中只要矩阵的宽高是原始image的对角线长度，无论旋转多少度都不会有空白。
    CGFloat sqrtLength = sqrt(img_w*img_w + img_h*img_h);
    
    
    //计算需要绘制的列数和行数
    int count_Hor = sqrtLength / (str_w + HORIZONTAL_SPACEING) + 1;
    int count_Ver = sqrtLength / (str_h + VERTICAL_SPACEING) + 1;
    
    //此处计算出需要绘制水印文字的起始点，由于水印区域要大于图片区域所以起点在原有基础上移
    CGFloat orignX = -(sqrtLength-WIDTH)/2;
    CGFloat orignY = -(sqrtLength-HEIGHT)/2;
    
    //在每列绘制时X坐标叠加
    CGFloat overlayOrignX = orignX;
    //在每行绘制时Y坐标叠加
    CGFloat overlayOrignY = orignY;
    for (int i = 0; i < count_Hor * count_Ver; i++) {
        //绘制图片
        [text drawInRect:CGRectMake(overlayOrignX, overlayOrignY, str_w, str_h) withAttributes:attr];
        if (i % count_Hor == 0 && i != 0) {
            overlayOrignX = orignX;
            overlayOrignY += (str_h + VERTICAL_SPACEING);
        }else{
            overlayOrignX += (str_w + HORIZONTAL_SPACEING);
        }
    }
    
    //3.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    CGContextRestoreGState(context);
    
    
    return newImage;
}

@end
