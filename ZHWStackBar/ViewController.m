//
//  ViewController.m
//  ZHWStackBar
//
//  Created by andson-zhw on 16/2/22.
//  Copyright © 2016年 andson. All rights reserved.
//

#import "ViewController.h"
#import "StackBarContentView.h"
#import "StackBarViewController.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //检查应用版本号，用于判断更新数据库
    [self checkAppVersion];
    
    
//    StackBarContentView *stackContentView = [[StackBarContentView alloc]initWithFrame:CGRectMake(10, 100, self.view.bounds.size.width - 20, 150)];
//    [self.view addSubview:stackContentView];
    
//    StackBarViewController *stackBarVC = [[StackBarViewController alloc]init];
//    stackBarVC.view.frame = CGRectMake(10, 100, self.view.bounds.size.width - 20, 150);
//    [self.view addSubview:stackBarVC.view];
//    [self addChildViewController:stackBarVC];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    
//    [UIView animateWithDuration:1.0 animations:^{
//        
//    }];
}
-(void)checkAppVersion{
    //项目工程信息
    
    //获取项目名称
    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
    //获取项目版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    CFShow((__bridge CFTypeRef)(infoDictionary));
    
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"===%@\n%@\n%@\n%@\n%@\n",executableFile,version,app_Name,app_Version,app_build);
    
    
    //沙盒文件目录
    //Home目录
    //    NSString *homeDirectory = NSHomeDirectory();
    
    //Document目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    //    //Cache目录
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //    NSString *path = [paths objectAtIndex:0];
    //
    //    //Libaray目录
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    //    NSString *path = [paths objectAtIndex:0];
    //
    //    //tmp目录
    //    NSString *tmpDir = NSTemporaryDirectory();
    
    NSString *filePath = [path stringByAppendingPathComponent:@"AppVersion.txt"];
    NSLog(@"-----%@",filePath);
    //判断目录下是否已经存在该文件
    BOOL isHaveFile = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!isHaveFile) {
        //如果不存在,讲版本号写入到文件中
        BOOL isSave = [app_Version writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        if (isSave) {
            NSLog(@"=====写入成功");
        }
    }else{
        //如果已经存在,获取本地沙河文件里保存的版本号
        NSString *localVersionStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        if ([localVersionStr isEqualToString:app_Version]) {
            //已经是最新版本
            NSLog(@"已经是最新版本,版本号:%@",app_Version);
        }else{
            //不是最新版本，将沙河文件里的版本号，更改为最新的版本号
            BOOL isSave = [app_Version writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            if (isSave) {
                NSLog(@"=====重新写入成功，当前保存版本号为:%@",app_Version);
            }
        }
    }
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }else{
        while ([cell.contentView.subviews lastObject] !=nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
//    if (indexPath.row == 2) {
////        StackBarViewController *stackBarVC = [[StackBarViewController alloc]init];
////        stackBarVC.view.frame = CGRectMake(10, 0, cell.contentView.bounds.size.width - 30, 150);
////        [cell.contentView addSubview:stackBarVC.view];
////        [self addChildViewController:stackBarVC];
////        [stackBarVC showStackBarView];
//        
////        StackBarContentView *stackContentView = [[StackBarContentView alloc]initWithFrame:CGRectMake(15, 0, self.view.bounds.size.width - 30 , 170)];
////        [cell.contentView addSubview:stackContentView];
//    }
    StackBarContentView *stackContentView = [[StackBarContentView alloc]initWithFrame:CGRectMake(15, 0, self.view.bounds.size.width - 30 , 170)];
    NSArray *yValuesArr =[NSArray arrayWithObjects:@[@"100"],@[],@[@"30",@"120"], @[],@[@"10",@"50",@"80"],@[],@[],nil];
    NSArray *colorArr = [NSArray arrayWithObjects:@[[UIColor redColor]],@[],@[[UIColor orangeColor],[UIColor greenColor]],@[],@[[UIColor purpleColor],[UIColor blackColor],[UIColor yellowColor]],@[],@[], nil];
    [stackContentView setYValuesArr:yValuesArr andColorArr:colorArr];
    [cell.contentView addSubview:stackContentView];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
