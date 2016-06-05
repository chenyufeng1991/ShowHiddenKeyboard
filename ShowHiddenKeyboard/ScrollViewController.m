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

@interface ScrollViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
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
    WeakSelf(weakSelf);

    // 最外部的scrollView
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor orangeColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];

    // 包含所有子View的容器
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 200)];
    self.contentView.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.scrollView);
        make.width.equalTo(weakSelf.scrollView);
//        make.height.equalTo(@770);
    }];

    // 顶部图片
    self.topImageView = [[UIImageView alloc] init];
    self.topImageView.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.height.equalTo(@50);

    }];

    // 文本输入框
    self.inputField = [[UITextField alloc] init];
    self.inputField.text = @"请输入";
    self.inputField.backgroundColor = [UIColor colorWithRed:0.507 green:1.000 blue:0.520 alpha:1.000];
    [self.contentView addSubview:self.inputField];
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topImageView.mas_bottom);
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.height.equalTo(@150);
    }];


    // CollectionView
    self.collArr = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"beauty"], nil];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 320, 70) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.inputField.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.height.equalTo(@70);

    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(clickCollectionView:)];
    // tap.cancelsTouchesInView = NO;
    [self.collectionView addGestureRecognizer:tap];

    self.bottomImageView = [[UIImageView alloc] init];
    self.bottomImageView.image = [UIImage imageNamed:@"bottom"];
    [self.contentView addSubview:self.bottomImageView];
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.collectionView.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView);
        make.height.equalTo(@500);
    }];

    // 这里要重新设置容器的高度，其实只要固定底部即可。
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomImageView);
    }];

}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"CollectionView中的Cell被点击了:%ld",(long)indexPath.row);
}

#pragma mark - UiCollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    cell.imageView.image = self.collArr[indexPath.row];
    [cell.button addTarget:self
                    action:@selector(clickCloseButton:)
          forControlEvents:UIControlEventTouchUpInside];


    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 60);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}



@end
