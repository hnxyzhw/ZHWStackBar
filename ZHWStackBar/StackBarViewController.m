//
//  StackBarViewController.m
//  ZHWStackBar
//
//  Created by andson-zhw on 16/2/22.
//  Copyright © 2016年 andson. All rights reserved.
//

#import "StackBarViewController.h"
#import "StackBarView.h"

@interface StackBarViewController ()<StackBarViewDelegate>
{
    UILabel *_desLabel;
}
@end

@implementation StackBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
}
-(void)showStackBarView{
    _desLabel = [[UILabel alloc]init];
    _desLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 20);
    [_desLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_desLabel setTextColor:[UIColor blackColor]];
    [_desLabel setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:_desLabel];
    
    CGFloat stackBarView_X = ([UIScreen mainScreen].bounds.size.width - 20) / 7;//self.view.bounds.size.width /7;
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
        xDataLabel.frame =CGRectMake(stackBarView_X *xIndex + (stackBarView_X - titleSize.width)/2, self.view.bounds.size.height-20, titleSize.width, 20);
        [self.view addSubview:xDataLabel];
    }
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.frame = CGRectMake(0, self.view.bounds.size.height - 20, [UIScreen mainScreen].bounds.size.width - 20, 1.0);
    [self.view addSubview:lineView];
    
    
    NSArray *yValuesArr = [NSArray arrayWithObjects:@"120",@"80",@"40", nil];//
    NSArray *colorArr =[NSArray arrayWithObjects:[UIColor orangeColor],[UIColor greenColor],[UIColor blueColor], nil];//
    
    
    for (NSInteger index = 0; index <7; index++) {
        StackBarView *stackBarView = [[StackBarView alloc]initWithFrame:CGRectMake(stackBarView_X*index + (stackBarView_X - 10)/2,self.view.bounds.size.height - 120, 10, 100)];
        [stackBarView setDataSourcesWithYValuesArr:yValuesArr yColorsArr:colorArr xStackIndex:index];
        stackBarView.delegate = self;
        [self.view addSubview:stackBarView];
    }
//    StackBarView *stackBarView = [[StackBarView alloc]initWithFrame:CGRectMake((stackBarView_X - 10)/2,self.view.bounds.size.height - 120, 10, 100)];
//    [stackBarView setDataSourcesWithYValuesArr:yValuesArr yColorsArr:colorArr xStackIndex:0];
//    stackBarView.delegate = self;
//    [self.view addSubview:stackBarView];
//    
//    StackBarView *stackBarView1 = [[StackBarView alloc]initWithFrame:CGRectMake(stackBarView_X + (stackBarView_X - 10)/2,self.view.bounds.size.height - 120, 10, 100)];
//    [stackBarView1 setDataSourcesWithYValuesArr:yValuesArr yColorsArr:colorArr xStackIndex:1];
//    stackBarView1.delegate = self;
//    [self.view addSubview:stackBarView1];
//    
//    StackBarView *stackBarView2 = [[StackBarView alloc]initWithFrame:CGRectMake(stackBarView_X*2 + (stackBarView_X - 10)/2,self.view.bounds.size.height - 120, 10, 100)];
//    [stackBarView2 setDataSourcesWithYValuesArr:nil yColorsArr:nil xStackIndex:2];
//    stackBarView2.delegate = self;
//    [self.view addSubview:stackBarView2];
//    
//    
//    StackBarView *stackBarView3 = [[StackBarView alloc]initWithFrame:CGRectMake(stackBarView_X*3 + (stackBarView_X - 10)/2,self.view.bounds.size.height - 120, 10, 100)];
//    [stackBarView3 setDataSourcesWithYValuesArr:yValuesArr yColorsArr:colorArr xStackIndex:3];
//    stackBarView3.delegate = self;
//    [self.view addSubview:stackBarView3];
}


-(void)selectStackBarView:(id)selectStackBarView xStackIndex:(NSInteger)xStackIndex yStackIndex:(NSInteger)yStackIndex{
    StackBarView *selctBarView = (StackBarView *)selectStackBarView;
    _desLabel.text = [NSString stringWithFormat:@"xStackIndex = %ld,yStackIndex = %ld",(long)selctBarView.xStackIndex,(long)yStackIndex];
    NSLog(@"-----%ld ----%ld",(long)selctBarView.xStackIndex,(long)yStackIndex);
    for (id stackBarView in self.view.subviews) {
        if ([[NSString stringWithUTF8String:object_getClassName(stackBarView)] isEqualToString:@"StackBarView"]) {
            StackBarView *subStackView = stackBarView;
            if (subStackView.xStackIndex != selctBarView.xStackIndex) {
                [subStackView changeAllButtonSelectState];
            }
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
    _desLabel.text = @"";
    for (id stackBarView in self.view.subviews) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
