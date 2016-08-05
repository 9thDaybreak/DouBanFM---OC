//
//  GNTableViewCell.m
//  DouBanFM - OC
//
//  Created by 肖杰华 on 16/7/29.
//  Copyright © 2016年 ZhuSunGongZuoShi. All rights reserved.
//

#import "GNTableViewCell.h"

@implementation GNTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *CellIdentifier = @"DouBanFM";
    GNTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil]firstObject];
        
    }
    return cell;
}


@end
