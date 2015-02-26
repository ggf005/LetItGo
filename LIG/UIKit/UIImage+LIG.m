//
//  UIImage+LIG.m
//  LIG
//
//  Created by gongguifei on 15/2/26.
//  Copyright (c) 2015年 Gong Guifei. All rights reserved.
//

#import "UIImage+LIG.h"

@implementation UIImage (LIG)

/*
 * @brief 缩放图片
 */
- (UIImage *)lig_scaleToSize:(CGSize)size
{
    UIImage *scaledImage;
    UIGraphicsBeginImageContext(size);
    
    
    [self drawInRect:CGRectMake(0.f, 0.f, size.width, size.height)];
    
    scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return scaledImage;
}

- (UIImage *)lig_scaleToRate:(CGFloat)rate; //原图为1.0
{
    CGSize size = CGSizeMake(self.size.width * rate, self.size.height * rate);
    
    return [self lig_scaleToSize:size];
}

/*
 * @brief 转换为NSData数据
 */
- (NSData *)lig_PNGRepresentationData
{
    return UIImagePNGRepresentation(self);
}
- (NSData *)lig_JPEGHRepresentationData
{
    return UIImageJPEGRepresentation(self, 1.0);
}

/*
 * @brief 创建一个UIImage对象，并用指定颜色填充
 */
+ (UIImage *)lig_imageWithColor:(UIColor *)color
{
    return [self lig_imageWithColor:color size:CGSizeMake(1.0, 1.0)];
}
+ (UIImage *)lig_imageWithColor:(UIColor *)color size:(CGSize)size
{

    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0.f, 0.f, size.width, size.height));
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return image;
}
@end
