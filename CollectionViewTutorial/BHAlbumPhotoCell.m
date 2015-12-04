//
//  BHAlbumPhotoCell.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "BHAlbumPhotoCell.h"
#import <QuartzCore/QuartzCore.h>

@interface BHAlbumPhotoCell ()
@property (nonatomic, strong, readwrite) UILabel *cellLabel;
@end

@implementation BHAlbumPhotoCell

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 2.0f;
        self.cellLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.cellLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.cellLabel];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _cellLabel.frame  = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

@end
