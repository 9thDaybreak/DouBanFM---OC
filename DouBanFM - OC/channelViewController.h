//
//  channelViewController.h
//  DouBanFM - OC
//
//  Created by 肖杰华 on 16/8/5.
//  Copyright © 2016年 ZhuSunGongZuoShi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChamnelProtocol <NSObject>

- (void)onChangeChannel_id:(NSString *)Channel_id;

@end


@interface channelViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) id<ChamnelProtocol> delegate;
@property (nonatomic, weak) NSArray *channelDataFirst;

@end
