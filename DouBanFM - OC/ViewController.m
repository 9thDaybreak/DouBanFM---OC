//
//  ViewController.m
//  DouBanFM - OC
//
//  Created by 肖杰华 on 16/7/29.
//  Copyright © 2016年 ZhuSunGongZuoShi. All rights reserved.
//

#import "ViewController.h"
#import "GNImage.h"
#import "GNTableViewCell.h"
#import "GNOrderButton.h"
#import "GNButton.h"
#import <Toast/UIView+Toast.h>

@interface ViewController ()

//imageView
@property (weak, nonatomic) IBOutlet GNImage *CDImageView;
@property (weak, nonatomic) IBOutlet GNImage *CDCenterImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
//tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//定义数据存放的数组
@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) NSArray *channelData;

@property (strong, nonatomic) NSDictionary *imageCache;

//定义一个播放器
@property (strong, nonatomic) AVPlayer *audioPlayer;

//按钮
@property (weak, nonatomic) IBOutlet GNOrderButton *btnOrder;
@property (weak, nonatomic) IBOutlet UIButton *btnLast;
@property (weak, nonatomic) IBOutlet GNButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

//定时器
@property (weak, nonatomic) NSTimer *MainTimer;

@property (strong, nonatomic) HttpController *eHttp;

//进度条
@property (weak, nonatomic) IBOutlet UIImageView *musicProgress;
@property (weak, nonatomic) IBOutlet UILabel *musicTimer;

@end

@implementation ViewController

bool isAutoFinish = YES;
int currentIndex = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    //View转动
    [self.CDImageView onRotation];
    
    //添加背景毛玻璃效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    blurView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.bgImageView addSubview:blurView];
    
    self.eHttp = [[HttpController alloc] init];
    
    self.eHttp.delegate = self;
    
    //调用方法获取数据
    [self.eHttp onSearch:@"http://www.douban.com/j/app/radio/channels"];
    [self.eHttp onSearch:@"http://douban.fm/j/mine/playlist?type=n&channel=0&from=mainsite"];
    
    //删除UItableView的背景颜色
    self.tableView.backgroundColor = UIColor.clearColor;
    
    //添加按钮方法
    [self.btnPlay addTarget:self action:@selector(onPlay:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnLast addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnNext addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnOrder addTarget:self action:@selector(onOrder:) forControlEvents:(UIControlEventTouchUpInside)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:self.audioPlayer];
}

#pragma mark - 实现代理方法

- (void)didRecieveResults:(NSDictionary *)results {
//    NSLog(@"%@", [results valueForKey:@"song"]);
    if ([results valueForKey:@"channels"]) {
        self.channelData = [results valueForKey:@"channels"];
    } else if ([results valueForKey:@"song"]){
        isAutoFinish = NO;
        self.tableData = [results valueForKey:@"song"];
        [self.tableView reloadData];
        [self onSelectRow:0];
    }
}

- (void)onChangeChannel_id:(NSString *)Channel_id {
    NSString *url = [NSString stringWithFormat:@"http://douban.fm/j/mine/playlist?type=n&channel=%@&from=mainsite",Channel_id];
    self.eHttp.delegate = self;
    [self.eHttp onSearch:url];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    channelViewController *channelC = [segue destinationViewController];
    channelC.delegate = self;
    channelC.channelDataFirst = self.channelData;
}

#pragma mark - 配置TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //初始化Cell
    GNTableViewCell *cell = [GNTableViewCell cellWithTableView:tableView];
    
    NSArray *rowData = self.tableData[indexPath.row];
    cell.titleText.text = [rowData valueForKey:@"title"];
    cell.subTitleText.text = [rowData valueForKey:@"artist"];
    cell.cellImageView.image = [UIImage imageNamed:@"thumb"];
    cell.backgroundColor = [UIColor clearColor];
    NSString *url = [rowData valueForKey:@"picture"];
    //调用onGetCacheImage方法来设置歌曲图片
    [self onGetCacheImage:url imageView:cell.cellImageView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:0.25 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    isAutoFinish = NO;
    [self onSelectRow:(int)indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61;
}

#pragma mark - 按钮方法

- (void)onPlay:(GNButton *)btn {
    if (btn.isPlay) {
        [self.audioPlayer play];
        [self.CDImageView onRotation];
    } else {
        [self.audioPlayer pause];
        [self.CDImageView stopRotation];
    }
}

- (void)onClick:(UIButton *)btn {
    isAutoFinish = NO;
    if (btn == self.btnNext) {
        currentIndex += 1;
        if (currentIndex > self.tableData.count - 1) {
            currentIndex = 0;
            
        }
    } else {
        currentIndex -= 1;
        if (currentIndex < 0) {
            currentIndex = (int)self.tableData.count -1;
        }
    }
    [self onSelectRow:currentIndex];
}

- (void)onOrder:(GNOrderButton *)btn {
    NSString *message = @"";
    switch (btn.order) {
        case 1:
            message = @"顺序播放";
            break;
        case 2:
            message = @"随机播放";
            break;
        default:
            message = @"单曲循环";
            break;
    }
    
    CGPoint tempPoint = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    NSValue *temp = [NSValue valueWithCGPoint:tempPoint];
    [self.view makeToast:message duration:1 position:temp];
}
#pragma mark - 补充方法

- (void)onSelectRow:(int)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];

    NSArray *rowData = self.tableData[index];
    NSString *imageURL = [rowData valueForKey:@"picture"];
    [self onSetImage:imageURL];
    
    NSString *tempURL = [rowData valueForKey:@"url"];
    NSURL *url = [NSURL URLWithString:tempURL];
    [self onSetAudio:url];
    
    }

- (void)onSetAudio:(NSURL *)URL {
    
    self.audioPlayer = [[AVPlayer alloc] initWithURL:URL];
    [self.audioPlayer pause];
    [self.audioPlayer play];
    
    [self.btnPlay onPlay];
    [self.MainTimer invalidate];
    self.musicTimer.text = @"00:00";
    
    self.MainTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(onUpdate) userInfo:nil repeats:YES];
    isAutoFinish = YES;
}

- (void)onUpdate {
    //获取当前播放时间
    int64_t totalTimeObj = self.audioPlayer.currentItem.asset.duration.value;
    int64_t totalTimeObj1 = self.audioPlayer.currentItem.asset.duration.timescale;
    CGFloat totalTime = totalTimeObj / totalTimeObj1;
    
    int64_t nowTimeObj = self.audioPlayer.currentTime.value;
    int64_t nowTimeObj1 = self.audioPlayer.currentTime.timescale;
    CGFloat nowTime = nowTimeObj / nowTimeObj1;
    
    //歌曲播放进度的百分比
    CGFloat percent = nowTime / totalTime;
    
    CGRect temp = self.musicProgress.frame;
    temp.size.width = self.view.frame.size.width *percent;
    self.musicProgress.frame = temp;
    
    //配置时间Label
    if (nowTime > 0) {
        int all = nowTime;
        int minute = all / 60;
        int second = all % 60;
        
        NSString *time = @"";
        NSString *zero = @"0";
        NSString *zero1 = @"0";
        NSString *minuteStr = [NSString stringWithFormat:@"%d",minute];
        NSString *secondStr = [NSString stringWithFormat:@"%d",second];
        
        if (minute < 10) {
            zero = [zero stringByAppendingString:minuteStr];
        } else {
            zero = minuteStr;
        }
        
        if (second < 10) {
            zero1 = [zero1 stringByAppendingString:secondStr];
        } else {
            zero1 = secondStr;
        }
        
        time = [time stringByAppendingFormat:@"%@:%@",zero,zero1];
        self.musicTimer.text = time;
    }
}

- (void)onSetImage:(NSString *)URL {
    NSURL *TempURL = [NSURL URLWithString:URL];
    NSData *data = [NSData dataWithContentsOfURL:TempURL];
    UIImage *img = [UIImage imageWithData:data];
    
    self.bgImageView.image = img;
    self.CDImageView.image = img;
    
    [self onGetCacheImage:URL imageView:self.bgImageView];
    [self onGetCacheImage:URL imageView:self.CDImageView];
}

- (void)onGetCacheImage:(NSString *)URL imageView:(UIImageView *)imageView {
    
    UIImage *img = [self.imageCache valueForKey:URL];
    
    if (img == nil) {
        NSURL *TempURL = [NSURL URLWithString:URL];
        NSData *data = [NSData dataWithContentsOfURL:TempURL];
        UIImage *image = [UIImage imageWithData:data];
        imageView.image = image;
    } else {
        imageView.image = img;
    }
}

- (void)playFinish {
    if (isAutoFinish) {
        switch (self.btnOrder.order) {
            case 1:
                currentIndex += 1;
                if (currentIndex > self.tableData.count - 1) {
                    currentIndex = 0;
                }
                [self onSelectRow:currentIndex];
                break;
            case 2:
                currentIndex = random() % (int)self.tableData.count;
                [self onSelectRow:currentIndex];
                break;
            case 3:
                [self onSelectRow:currentIndex];
            default:
                break;
        }
    }
}
@end

