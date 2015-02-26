//
//  UIImage+LIG.h
//  LIG
//
//  Created by gongguifei on 15/2/26.
//  Copyright (c) 2015年 Gong Guifei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LIG)

/*
 * @brief 缩放图片
 */
- (UIImage *)lig_scaleToSize:(CGSize)size;
- (UIImage *)lig_scaleToRate:(CGFloat)rate; //原图为1.0

/*
 * @brief 转换为NSData数据
 */
- (NSData *)lig_PNGRepresentationData;
- (NSData *)lig_JPEGHRepresentationData;

/*
 * @brief 创建一个UIImage对象，并用指定颜色填充
 */
+ (UIImage *)lig_imageWithColor:(UIColor *)color;
+ (UIImage *)lig_imageWithColor:(UIColor *)color size:(CGSize)size;
@end
