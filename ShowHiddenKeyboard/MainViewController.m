//
//  ViewController.m
//  ShowHiddenKeyboard
//
//  Created by chenyufeng on 16/6/4.
//  Copyright © 2016年 chenyufengweb. All rights reserved.
//

#import "MainViewController.h"
#import "Masonry.h"
#import "CustomCollectionViewCell.h"

//定义宏，用于block
#define WeakSelf(weakSelf) __weak __typeof(&*self)weakSelf = self;

NS_ENUM(NSInteger,KeyBoardState){

    KeyboardHidden = 0,
    KeyboardShowing
};

@interface MainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collArr;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"主界面";

    [self configUI];


    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)configUI
{
    // 包容整个界面的容器View

    CGRect tureFame = self.view.frame;
    tureFame.origin.y = 64;// 获取剔除导航栏后的真正y位置

    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.frame = tureFame;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.contentView];

    // 顶部图片
    WeakSelf(weakSelf);
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
    self.collArr = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"beauty"],[UIImage imageNamed:@"beauty"], nil];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 320, 70) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputField.mas_bottom).offset(20);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@70);
    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(hideKeyboard:)];
    tap.cancelsTouchesInView = NO;
    [self.collectionView addGestureRecognizer:tap];
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

#pragma mark - 键盘处理事件
- (void)keyboardWillShow
{
    KeyBoardState = KeyboardShowing;
    CGRect frame = self.contentView.frame;
    frame.origin.y = self.contentView.frame.origin.y - 50;
    self.contentView.frame = frame;
}

- (void)keyboardWillHide
{
    KeyBoardState = KeyboardHidden;
    CGRect frame = self.contentView.frame;
    frame.origin.y = self.contentView.frame.origin.y + 50;
    self.contentView.frame = frame;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.inputField endEditing:YES];
}

- (void)hideKeyboard:(id)sender
{
    CGPoint pointTouch = [sender locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];
    if (indexPath != nil && KeyBoardState == KeyboardShowing)
    {
        [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
    }

    [self.inputField endEditing:YES];// 这里会阻断响应链
}


@end











