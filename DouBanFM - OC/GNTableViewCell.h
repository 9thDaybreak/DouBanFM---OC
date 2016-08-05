//
//  GNTableViewCell.h
//  DouBanFM - OC
//
//  Created by 肖杰华 on 16/7/29.
//  Copyright © 2016年 ZhuSunGongZuoShi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GNTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleText;

@property (weak, nonatomic) IBOutlet UILabel *subTitleText;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
