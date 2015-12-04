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
        _photoAlbumLayout = [[BHPhotoAlbumLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_photoAlbumLayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor greenColor];
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeObjectFromCollectionView:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addObjectToCollectionView:)];
    
    self.albums = [NSMutableArray array];
    NSURL *urlPrefix = [NSURL URLWithString:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/"];
    NSInteger photoIndex = 0;
    for (NSInteger a = 0; a < 100; a++)
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

#pragma mark - Private
- (void)removeObjectFromCollectionView:(id)sener
{
    NSLog(@"removeObjectFromCollectionView:");
}

- (void)addObjectToCollectionView:(id)sender
{
    NSLog(@"addObjectToCollectionView:");
}

#pragma mark - View Rotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [self.photoAlbumLayout invalidateLayout];
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
    } else {
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.albums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BHAlbumPhotoCell *photoCell =
        [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier
                                                  forIndexPath:indexPath];
    photoCell.cellLabel.text = [NSString stringWithFormat:@" cell index = %@",@(indexPath.item)];
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
    titleView.titleLabel.text = [NSString stringWithFormat:@"suplementary index = %@",@(indexPath.item)];
    return titleView;
}

#pragma mark - GRCollectionViewDelegateLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(200, arc4random()%300 + 70);
}

- (BOOL)collectionView:(UICollectionView *)collectionView layout:(BHPhotoAlbumLayout *)collectionViewLayout shouldShowDateHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row % 3) == 0) {
        return YES;
    }
    return NO;
}

@end
