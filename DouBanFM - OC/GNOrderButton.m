//
//  GNOrderButton.m
//  DouBanFM - OC
//
//  Created by 肖杰华 on 16/8/4.
//  Copyright © 2016年 ZhuSunGongZuoShi. All rights reserved.
//

#import "GNOrderButton.h"

@implementation GNOrderButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.order = 1;
    if (self = [super initWithCoder:aDecoder]) {
        [self addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)onClick:(UIButton *)sender {
    self.order += 1;
    if (self.order == 1) {
        [self setImage:[UIImage imageNamed:@"order1"] forState:(UIControlStateNormal)];
    } else if (self.order == 2) {
        [self setImage:[UIImage imageNamed:@"order2"] forState:(UIControlStateNormal)];
    } else if (self.order == 3) {
        [self setImage:[UIImage imageNamed:@"order3"] forState:(UIControlStateNormal)];
    } else {
        self.order = 1;
        [self setImage:[UIImage imageNamed:@"order1"] forState:(UIControlStateNormal)];
    }
}

@end
