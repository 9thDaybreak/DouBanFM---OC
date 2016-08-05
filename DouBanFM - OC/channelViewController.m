//
//  channelViewController.m
//  DouBanFM - OC
//
//  Created by 肖杰华 on 16/8/5.
//  Copyright © 2016年 ZhuSunGongZuoShi. All rights reserved.
//

#import "channelViewController.h"

@interface channelViewController ()

@end

@implementation channelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.alpha = 0.7;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.channelDataFirst.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Channel"];
    NSArray *rowData = self.channelDataFirst[indexPath.row];
    
    cell.textLabel.text = [rowData valueForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rowData = self.channelDataFirst[indexPath.row];
    NSString *channel_id = [rowData valueForKey:@"channel_id"];
    [self.delegate onChangeChannel_id:channel_id];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.layer.transform = CATransform3DMakeScale(0.75, 0.75, 1);
    [UIView animateWithDuration:0.25 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}
- (IBAction)clickCloseBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
