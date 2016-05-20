//
//  RequestHandle.h
//  ZHWStackBar
//
//  Created by andson-zhw on 16/3/7.
//  Copyright © 2016年 andson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestHandle : NSObject
-(void)testBlock:(void (^)(NSString *result))callback;
-(void)testnewBlock:(void *(^)(NSString *result)) myreslult;
@end
