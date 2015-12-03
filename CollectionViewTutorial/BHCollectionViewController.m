//
//  BHCollectionViewController.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "BHCollectionViewController.h"
#import "BHPhotoAlbumLayout.h"
#import "BHAlbumPhotoCell.h"
#import "BHAlbum.h"
#import "BHPhoto.h"
#import "BHAlbumTitleReusableView.h"

static NSString * const PhotoCellIdentifier = @"PhotoCell";
static NSString * const AlbumTitleIdentifier = @"AlbumTitle";

@interface BHCollectionViewController ()
@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, strong)   BHPhotoAlbumLayout *photoAlbumLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation BHCollectionViewController
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        self.photoAlbumLayout = [[BHPhotoAlbumLayout alloc] init];
//      layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//      layout.headerHeight = 15;
//      layout.footerHeight = 10;
//      layout.minimumColumnSpacing = 20;
//      layout.minimumInteritemSpacing = 30;
//      layout.columnCount = 1;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.photoAlbumLayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[BHAlbumPhotoCell class]
                forCellWithReuseIdentifier:PhotoCellIdentifier];
        [_collectionView registerClass:[BHAlbumTitleReusableView class]
                forSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleKind
                       withReuseIdentifier:AlbumTitleIdentifier];
    }
    return _collectionView;
}


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    self.albums = [NSMutableArray array];
    NSURL *urlPrefix = [NSURL URLWithString:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/"];
    NSInteger photoIndex = 0;
    for (NSInteger a = 0; a < 120; a++)
    {
        BHAlbum *album = [[BHAlbum alloc] init];
        album.name = @"";
        
        NSUInteger photoCount = arc4random()%4 + 2;
        for (NSInteger p = 0; p < photoCount; p++) {
            BHPhoto *photo = [BHPhoto photoWithImageURL:[urlPrefix URLByAppendingPathComponent:@""]];
            [album addPhoto:photo];
            photoIndex ++;
        }
        
        [self.albums addObject:album];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View Rotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [self.photoAlbumLayout invalidateLayout];
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width;
        NSLog(@"sideInset = %@",@(sideInset));
    } else {
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width;
        NSLog(@"sideInset = %@",@(sideInset));
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //return 10;
    return self.albums.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    BHAlbum *album = self.albums[section];
    return album.photos.count;
    //return self.albums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BHAlbumPhotoCell *photoCell =
        [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier
                                                  forIndexPath:indexPath];
    return photoCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;
{
    BHAlbumTitleReusableView *titleView =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                           withReuseIdentifier:AlbumTitleIdentifier
                                                  forIndexPath:indexPath];
    titleView.titleLabel.text = @"test test";
    return titleView;
}

@end
