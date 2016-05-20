//
//  StackBarContentView.m
//  ZHWStackBar
//
//  Created by andson-zhw on 16/2/22.
//  Copyright © 2016年 andson. All rights reserved.
//

#import "StackBarContentView.h"
#import "StackBarView.h"

@interface StackBarContentView ()
{
    UILabel *_desLabel;
    UIView *_colorDotView;
}
@end

@implementation StackBarContentView

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
        self.backgroundColor = [UIColor whiteColor];
        
//        [self setUI];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(BarSelectStateChangeHandle:) name:@"StackBarSelectChange" object:nil];
    }
    
    return self;
}

-(void)setYValuesArr:(NSArray *)yValuesArr andColorArr:(NSArray *)colorsArr{
    self.yValuesArr= yValuesArr;
    self.colorsArr = colorsArr;
    [self setUI];
    
}

-(void)setUI{
    _desLabel = [[UILabel alloc]init];
    _desLabel.frame = CGRectMake(0, 0, self.frame.size.width, 20);
    [_desLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_desLabel setTextColor:[UIColor blackColor]];
    [_desLabel setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:_desLabel];
    
    
    CGFloat stackBarView_X = self.bounds.size.width /7;//([UIScreen mainScreen].bounds.size.width - 20) / 7;//
    NSArray *xDateArr = [self getSenvenDateFromeNowDateArr];
    for (NSString *dateStr in xDateArr) {
        UILabel *xDataLabel = [[UILabel alloc]init];
        xDataLabel.text = dateStr;
        [xDataLabel setTextColor:[UIColor blackColor]];
        [xDataLabel setFont:[UIFont systemFontOfSize:12.0]];
        [xDataLabel setTextAlignment:NSTextAlignmentLeft];
        CGSize titleSize = CGSizeMake(stackBarView_X, 20);
        NSDictionary *titleDic = [NSDictionary dictionaryWithObjectsAndKeys:xDataLabel.font,NSFontAttributeName, nil];
        titleSize = [xDataLabel.text boundingRectWithSize:titleSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:titleDic context:nil].size;
        NSInteger xIndex = [xDateArr indexOfObject:dateStr];
        xDataLabel.frame =CGRectMake(stackBarView_X *xIndex + (stackBarView_X - titleSize.width)/2, self.bounds.size.height-40, titleSize.width, 20);
        [self addSubview:xDataLabel];
    }
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.frame = CGRectMake(0, self.bounds.size.height - 40,self.bounds.size.width, 1.0);//[UIScreen mainScreen].bounds.size.width - 20
    [self addSubview:lineView];
    
    
    NSArray *yValuesArr = [NSArray arrayWithObjects:@"120",@"80",@"40",@"100", nil];//
    NSArray *colorArr =[NSArray arrayWithObjects:[UIColor orangeColor],[UIColor greenColor],[UIColor blueColor],[UIColor purpleColor], nil];//
    
    
    for (NSInteger index = 0; index <7; index++) {
        StackBarView *stackBarView = [[StackBarView alloc]initWithFrame:CGRectMake(stackBarView_X*index + (stackBarView_X - 10)/2,20, 10, self.bounds.size.height-60)];
//        [stackBarView setDataSourcesWithYValuesArr:yValuesArr yColorsArr:colorArr xStackIndex:index];
        [stackBarView setDataSourcesWithYValuesArr:[self.yValuesArr objectAtIndex:index] yColorsArr:[self.colorsArr objectAtIndex:index] xStackIndex:index];
        [self addSubview:stackBarView];
        [stackBarView addTarget:self action:@selector(changeSelectState:)];
    }
    
    [self setDotColorViewColorArr:colorArr numberArr:yValuesArr];
}

-(void)setDotColorViewColorArr:(NSArray *)colorArr numberArr:(NSArray *)numberArr{
    _colorDotView = [[UIView alloc]init];
    _colorDotView.backgroundColor = [UIColor whiteColor];
    _colorDotView.frame = CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20);
    [self addSubview:_colorDotView];
    
    for (NSInteger index = 0; index<colorArr.count; index++) {
        UIView *colorView = [[UIView alloc]init];
        colorView.backgroundColor = [colorArr objectAtIndex:index];
        [_colorDotView addSubview:colorView];
        
        UILabel *numLabel = [[UILabel alloc]init];
        numLabel.text = [numberArr objectAtIndex:index];
        numLabel.textColor = [UIColor blackColor];
        numLabel.textAlignment = NSTextAlignmentLeft;
        [numLabel setFont:[UIFont systemFontOfSize:8.0]];
        [_colorDotView addSubview:numLabel];
        
        if (colorArr.count<=1) {
            colorView.frame = CGRectMake(0, 5, 10, 10);
            numLabel.frame = CGRectMake(colorView.frame.origin.x + colorView.frame.size.width, colorView.center.y - 5, 20, 10);
        }else{
            colorView.frame = CGRectMake((20 + 10) * index, 5, 10, 10);
            numLabel.frame = CGRectMake(colorView.frame.origin.x + colorView.frame.size.width, colorView.center.y - 5, 20, 10);
        }
    }
}

-(void)changeSelectState:(id)sender{
    StackBarView * stackBarView = (StackBarView *)sender;
    NSInteger selectXStackIndex = stackBarView.xStackIndex;
    NSInteger selectYStackIndex = stackBarView.yStackIndex;

    _desLabel.text = [NSString stringWithFormat:@"xStackIndex = %d,yStackIndex = %d",selectXStackIndex,selectYStackIndex];
    for (id stackBarView in self.subviews) {
        if ([[NSString stringWithUTF8String:object_getClassName(stackBarView)] isEqualToString:@"StackBarView"]) {
            StackBarView *subStackView = stackBarView;
            if (subStackView.xStackIndex != selectXStackIndex) {
                [subStackView changeAllButtonSelectState];
            }
            
        }
    }
}

-(void)BarSelectStateChangeHandle:(NSNotification *)notify{
    NSDictionary *useInfoDic = [notify userInfo];    
    NSInteger selectXStackIndex = [[useInfoDic objectForKey:@"xStackIndex"] integerValue];
    NSInteger selectYStackIndex = [[useInfoDic objectForKey:@"yStackIndex"]integerValue];
    _desLabel.text = [NSString stringWithFormat:@"xStackIndex = %d,yStackIndex = %d",selectXStackIndex,selectYStackIndex];
    for (id stackBarView in self.subviews) {
        if ([[NSString stringWithUTF8String:object_getClassName(stackBarView)] isEqualToString:@"StackBarView"]) {
            StackBarView *subStackView = stackBarView;
            if (subStackView.xStackIndex != selectXStackIndex) {
                [subStackView changeAllButtonSelectState];
            }
            
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //    [super touchesBegan:touches withEvent:event];
    _desLabel.text = @"";
    for (id stackBarView in self.subviews) {
        if ([[NSString stringWithUTF8String:object_getClassName(stackBarView)] isEqualToString:@"StackBarView"]) {
            StackBarView *subStackView = stackBarView;
            [subStackView changeAllButtonSelectState];
            
        }
    }
}

//获取x轴时间日期
-(NSArray *)getSenvenDateFromeNowDateArr{
    NSMutableArray *recentSenvenDateArr = [NSMutableArray array];
    NSInteger dateCount = 7;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"MM-dd"];
    
    NSDate *nowDate = [NSDate date];
    NSDate *theDate;
    for (NSInteger index = 0; index < dateCount; index++) {
        NSTimeInterval oneDayTiemValue = 24 * 60 * 60 * 1;
        theDate = [nowDate initWithTimeIntervalSinceNow:oneDayTiemValue * index];
        NSString *dateString = [formatter stringFromDate:theDate];
        [recentSenvenDateArr addObject:dateString];
    }
    
    return recentSenvenDateArr;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"StackBarSelectChange" object:nil];
}
@end
