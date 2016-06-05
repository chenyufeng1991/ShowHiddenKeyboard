//
//  ScrollViewController.m
//  ShowHiddenKeyboard
//
//  Created by chenyufeng on 16/6/4.
//  Copyright © 2016年 chenyufengweb. All rights reserved.
//

#import "ScrollViewController.h"
#import "Masonry.h"
#import "CustomCollectionViewCell.h"
#import "AppDelegate.h"

@interface ScrollViewController ()

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong) NSMutableArray *collArr;

@property (nonatomic, assign) KeyBoardState status;


@end

@implementation ScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"主界面";

    [self configUI];



}

- (void)configUI
{
    // 包容整个界面的容器View
    WeakSelf(weakSelf);

    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 200)];
    self.contentView.backgroundColor = [UIColor redColor];
    self.contentView.scrollEnabled = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;/////////////////
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.equalTo(@400);
    }];

    // 顶部图片
    self.topImageView = [[UIImageView alloc] init];
    self.topImageView.image = [UIImage imageNamed:@"bottom"];
//    self.topImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(50);
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView);
//        make.edges.equalTo(weakSelf.contentView);
        make.width.equalTo(weakSelf.contentView);
        make.height.equalTo(@600);
    }];

}


@end
