//
//  WatermarkImage.h
//  WatermarkDemo
//
//  Created by CharlieLv on 2019/1/23.
//  Copyright © 2019 charlie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WatermarkImage : UIImageView

-(instancetype)initWithFrame:(CGRect)frame withText:(NSString *)text;

+(UIImage*)view:(UIImageView *)view WaterImageWithImage:(UIImage *)image text:(NSString *)text;


@end

NS_ASSUME_NONNULL_END
