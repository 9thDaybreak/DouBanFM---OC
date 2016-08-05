//
//  GNImage.m
//  
//
//  Created by 肖杰华 on 16/7/29.
//
//

#import "GNImage.h"

@implementation GNImage


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //设置圆角
        self.clipsToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width / 2;
        
        //设置边框
        self.layer.borderWidth = 4;
        self.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7].CGColor;
    }
    return self;
}

- (void)onRotation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = 30;
    animation.fromValue = [NSNumber numberWithDouble:0.0];
    animation.toValue = [NSNumber numberWithDouble:M_PI * 2];
    animation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:animation forKey:nil];
}

@end
