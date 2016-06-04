//
//  CustomCollectionViewCell.m
//  ShowHiddenKeyboard
//
//  Created by chenyufeng on 16/6/4.
//  Copyright © 2016年 chenyufengweb. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [self.imageView setUserInteractionEnabled:YES];
        [self addSubview:self.imageView];

        self.button = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 20, 20)];
        [self.button setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [self addSubview:self.button];
    }
    return self;
}



@end
