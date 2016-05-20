//
//  StackBarView.m
//  ZHWStackBar
//
//  Created by andson-zhw on 16/2/22.
//  Copyright © 2016年 andson. All rights reserved.
//

#import "StackBarView.h"
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface StackBarView ()
{
    NSArray *_yValuesArr; //y数值数组
    NSArray *_yColorsArr;  //y颜色数组
    
    CGFloat _totalYValue;   //y数值总和
    NSInteger _xStackIndex; //x轴方向的排序，由0~自增
    
    id _target;
    SEL _action;
}
@end

@implementation StackBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        //设置顶部圆角
        UIBezierPath *maskPath =[UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(self.bounds.size.width*0.5, self.bounds.size.width* 0.5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
    return self;
}


-(void)setDataSourcesWithYValuesArr:(NSArray *)yValuesArr yColorsArr:(NSArray *)yColorsArr{
    if (yValuesArr.count == 0) {
        return;
    }
    
    _yValuesArr = yValuesArr;
    _yColorsArr = yColorsArr;
    
    //计算y总和
    for (NSString *values in _yValuesArr) {
        _totalYValue = _totalYValue + [values floatValue];
    }
    
    [self setYValueButtonUI];
   
}

-(void)setDataSourcesWithYValuesArr:(NSArray *)yValuesArr yColorsArr:(NSArray *)yColorsArr xStackIndex:(NSInteger)xStackIndex{
    _yValuesArr = yValuesArr;
    _yColorsArr = yColorsArr;
    _xStackIndex = xStackIndex;
    
    //计算y总和
    for (NSString *values in _yValuesArr) {
        _totalYValue = _totalYValue + [values floatValue];
    }
    
    [self setYValueButtonUI];
}

//布局UI
-(void)setYValueButtonUI{
    
    for (NSInteger index = 0; index < _yValuesArr.count; index++) {
        UIButton *button = [[UIButton alloc]init];
        //        button.backgroundColor = (UIColor *)[_yColorsArr objectAtIndex:index];
        [button setBackgroundImage:[self imageWithColor:(UIColor *)[_yColorsArr objectAtIndex:index]] forState:UIControlStateNormal];
        [button setBackgroundImage:[self imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateSelected];
        button.tag = 100+index;
        [button addTarget:self action:@selector(changeSelectState:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        
        if (_yValuesArr.count <= 1) {
            //只有一个值
            button.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        }else{
            //有多个值
            CGFloat currentTotalYVaules = 0;
            for (NSInteger yValueIndex = 0; yValueIndex < index + 1; yValueIndex++) {
                currentTotalYVaules = currentTotalYVaules + [[_yValuesArr objectAtIndex:yValueIndex] floatValue];
            }
            CGFloat yPerecentValue = currentTotalYVaules/_totalYValue;
            CGFloat hPerecentValue = [[_yValuesArr objectAtIndex:index] floatValue]/_totalYValue;
            button.frame = CGRectMake(0, (1.0 - yPerecentValue)*self.bounds.size.height, self.bounds.size.width, hPerecentValue *self.bounds.size.height);
            //NSLog(@"====%@",NSStringFromCGRect(button.frame));
        }
    }
}


-(void)changeSelectState:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    for (id subView in self.subviews) {
        if ([NSStringFromClass([subView class]) isEqualToString:@"UIButton"]) {
            UIButton *subBtn = subView;
            if (subBtn.tag != button.tag) {
                subBtn.selected = NO;
            }
        }
    }
    
    if (button.selected) {
        button.selected = NO;
    }else{
        button.selected = YES;
    }
    
    //将横向的标识xStackIndex传给代理
    
    if ([_delegate respondsToSelector:@selector(selectStackBarView:xStackIndex:yStackIndex:)]) {
        [_delegate selectStackBarView:self xStackIndex:_xStackIndex yStackIndex:(button.tag - 100)];
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"StackBarSelectChange" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:_xStackIndex],@"xStackIndex",[NSNumber numberWithInteger:(button.tag-100)],@"yStackIndex", nil]];
    
    
    _yStackIndex = button.tag-100;
    if (_target) {
        if ([_target respondsToSelector:_action]) {
             SuppressPerformSelectorLeakWarning([_target performSelector:_action withObject:self]);
        }
    }
}

-(void)addTarget:(id)target action:(SEL)action{
   
    _target = target;
    _action = action;
}

-(void)changeAllButtonSelectState{
    for (id subView in self.subviews) {
        if ([NSStringFromClass([subView class]) isEqualToString:@"UIButton"]) {
            UIButton *subBtn = subView;
            subBtn.selected = NO;
        }
    }
}

//颜色转换成背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
