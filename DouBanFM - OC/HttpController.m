//
//  HttpController.m
//  DouBanFM - OC
//
//  Created by 肖杰华 on 16/7/30.
//  Copyright © 2016年 ZhuSunGongZuoShi. All rights reserved.
//

#import "HttpController.h"

@implementation HttpController

- (void)onSearch:(NSString *)url {
    //先定义了一个manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //调用get方法，传入url来获取数据
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            [self.delegate didRecieveResults:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败的话执行
        NSLog(@"数据获取失败");
    }];
}


@end
