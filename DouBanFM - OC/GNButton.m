//
//  GNButton.m
//  DouBanFM - OC
//
//  Created by 肖杰华 on 16/8/5.
//  Copyright © 2016年 ZhuSunGongZuoShi. All rights reserved.
//

#import "GNButton.h"

@implementation GNButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.isPlay = YES;
    if (self = [super initWithCoder:aDecoder]) {
        [self addTarget:self action:@selector(onClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return self;
}

- (void)onClick {
    self.isPlay = !self.isPlay;
    if (self.isPlay) {
        [self setImage:[UIImage imageNamed:@"pause"] forState:(UIControlStateNormal)];
    } else {
        [self setImage:[UIImage imageNamed:@"play"] forState:(UIControlStateNormal)];
    }
}

- (void)onPlay {
    self.isPlay = YES;
    [self setImage:[UIImage imageNamed:@"pause"] forState:(UIControlStateNormal)];
}
@end
