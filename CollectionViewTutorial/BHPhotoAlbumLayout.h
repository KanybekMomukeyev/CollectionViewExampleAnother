//
//  BHPhotoAlbumLayout.h
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const BHPhotoAlbumLayoutAlbumTitleKind;

@class BHPhotoAlbumLayout;

@protocol GRCollectionViewDelegateLayout <UICollectionViewDelegate>
@required

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(BHPhotoAlbumLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(BHPhotoAlbumLayout *)collectionViewLayout shouldShowDateHeaderAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface BHPhotoAlbumLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) CGFloat titleHeight;

@end
