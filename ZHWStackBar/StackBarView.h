//
//  StackBarView.h
//  ZHWStackBar
//
//  Created by andson-zhw on 16/2/22.
//  Copyright © 2016年 andson. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol StackBarViewDelegate <NSObject>

-(void)selectStackBarView:(id)selectStackBarView xStackIndex:(NSInteger)xStackIndex yStackIndex:(NSInteger)yStackIndex;
@end

@interface StackBarView : UIView
@property(nonatomic,assign)id<StackBarViewDelegate>delegate;
@property (nonatomic,assign)NSInteger xStackIndex;
-(instancetype)initWithFrame:(CGRect)frame;
-(void)setDataSourcesWithYValuesArr:(NSArray *)yValuesArr yColorsArr:(NSArray *)yColorsArr;
-(void)setDataSourcesWithYValuesArr:(NSArray *)yValuesArr yColorsArr:(NSArray *)yColorsArr xStackIndex:(NSInteger)xStackIndex;
-(void)changeAllButtonSelectState;
-(void)addTarget:(id)target action:(nonnull SEL)action;
@property(nonatomic,assign)NSInteger yStackIndex;
@end
