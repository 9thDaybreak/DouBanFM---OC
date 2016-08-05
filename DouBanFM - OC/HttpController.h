//
//  HttpController.h
//  DouBanFM - OC
//
//  Created by 肖杰华 on 16/7/30.
//  Copyright © 2016年 ZhuSunGongZuoShi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@protocol httpProtocol

- (void)didRecieveResults:(NSObject *)results;

@end



@interface HttpController : NSObject

@property (nonatomic,strong) id<httpProtocol> delegate;

- (void)onSearch:(NSString *)url;

@end
