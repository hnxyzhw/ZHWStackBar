//
//  StackBarContentView.h
//  ZHWStackBar
//
//  Created by andson-zhw on 16/2/22.
//  Copyright © 2016年 andson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StackBarContentView : UIView
@property(nonatomic,strong)NSArray *yValuesArr;
@property(nonatomic,strong)NSArray *colorsArr;
-(void)setYValuesArr:(NSArray *)yValuesArr andColorArr:(NSArray *)colorsArr;
@end
