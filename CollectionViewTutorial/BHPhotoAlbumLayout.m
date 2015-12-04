//
//  BHPhotoAlbumLayout.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "BHPhotoAlbumLayout.h"
#import "BHEmblemView.h"

static NSString * const BHPhotoAlbumLayoutPhotoCellKind = @"PhotoCell";
NSString * const BHPhotoAlbumLayoutAlbumTitleKind = @"AlbumTitle";
static NSString * const BHPhotoEmblemKind = @"Emblem";

@interface BHPhotoAlbumLayout ()

@property (nonatomic, strong) NSMutableArray *layouttInfosArray;
@property (nonatomic, strong) NSDictionary *layoutInfoDict;

@property (nonatomic, assign) CGSize currentContentSize;
@property (nonatomic, assign) CGFloat totalOriginYCalculation;

@property (nonatomic, weak) id <GRCollectionViewDelegateLayout> delegate;

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath forCellItemSize:(CGSize )cellSize;
- (CGRect)frameForSuplementaryAtIndexPath:(NSIndexPath *)indexPath forCellItemSize:(CGSize )cellSize;
- (CGRect)frameForDecorative;

@end

@implementation BHPhotoAlbumLayout

#pragma mark - Properties
- (NSMutableArray *)layouttInfosArray
{
    if (!_layouttInfosArray) {
        _layouttInfosArray = [NSMutableArray new];
    }
    return _layouttInfosArray;
}

- (id <GRCollectionViewDelegateLayout> )delegate
{
    return (id <GRCollectionViewDelegateLayout> )self.collectionView.delegate;
}

#pragma mark - Setters
- (void)setItemInsets:(UIEdgeInsets)itemInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(_itemInsets, itemInsets)) return;
    
    _itemInsets = itemInsets;
    
    [self invalidateLayout];
}

- (void)setInterItemSpacingY:(CGFloat)interItemSpacingY
{
    if (_interItemSpacingY == interItemSpacingY) return;
    
    _interItemSpacingY = interItemSpacingY;
    
    [self invalidateLayout];
}

- (void)setTitleHeight:(CGFloat)titleHeight
{
    if (_titleHeight == titleHeight) return;
    
    _titleHeight = titleHeight;
    
    [self invalidateLayout];
}


#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.interItemSpacingY = 20.0f;
    self.titleHeight = 30.0f;
    self.itemInsets = UIEdgeInsetsMake((22.0f + self.titleHeight), 22.0f, 130.0f, 22.0f);
    [self registerClass:[BHEmblemView class] forDecorationViewOfKind:BHPhotoEmblemKind];
}


#pragma mark - Layout

- (void)prepareLayout
{
    self.totalOriginYCalculation = self.itemInsets.top;
    
    NSMutableDictionary *newLayoutInfoDict   = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfoDict  = [NSMutableDictionary dictionary];
    NSMutableDictionary *titleLayoutInfoDict = [NSMutableDictionary dictionary];
    

    NSIndexPath *decorativeIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *emblemAttributes = [UICollectionViewLayoutAttributes
                                                          layoutAttributesForDecorationViewOfKind:BHPhotoEmblemKind withIndexPath:decorativeIndexPath];
    emblemAttributes.frame = [self frameForDecorative];
    newLayoutInfoDict[BHPhotoEmblemKind] = @{decorativeIndexPath: emblemAttributes};
    
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat heightOfContent = 0.0f;
    for (NSInteger item = 0; item < itemCount; item ++) {

        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        heightOfContent = heightOfContent + itemSize.height;

        // -------- ITEM ATTRIBUTE CALLCULATION --------- //
        UICollectionViewLayoutAttributes *itemAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        itemAttributes.frame = [self frameForItemAtIndexPath:indexPath forCellItemSize:itemSize];
        cellLayoutInfoDict[indexPath] = itemAttributes;
        
        // -------- SUPLEMENTARY ATTRIBUTE CALLCULATION ------------ //
        BOOL shouldShowDateHeader = [self.delegate collectionView:self.collectionView
                                                           layout:self
                                  shouldShowDateHeaderAtIndexPath:indexPath];
        //if (shouldShowDateHeader)
        //{
            UICollectionViewLayoutAttributes *titleAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleKind withIndexPath:indexPath];
            titleAttributes.frame = [self frameForSuplementaryAtIndexPath:indexPath forCellItemSize:itemSize];
            titleLayoutInfoDict[indexPath] = titleAttributes;
        //}
    }
    
    newLayoutInfoDict[BHPhotoAlbumLayoutPhotoCellKind]  =  cellLayoutInfoDict;
    newLayoutInfoDict[BHPhotoAlbumLayoutAlbumTitleKind] =  titleLayoutInfoDict;
    
    self.layoutInfoDict = newLayoutInfoDict;

    // -------- CONVERT TO ARRAY OF ATTRIBUTES --------- //
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfoDict.count];
    [self.layoutInfoDict enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier, NSDictionary *elementsInfo, BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *innerStop) {
            [allAttributes addObject:attributes];
        }];
    }];
    [self.layouttInfosArray removeAllObjects];
    [self.layouttInfosArray addObjectsFromArray:allAttributes];
    
    // -------- CONTENT SIZE CALCULATIONS ------------ //
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
    
    CGFloat height = self.itemInsets.top + heightOfContent +
                     (rowCount - 1) * self.interItemSpacingY +
                     rowCount * self.titleHeight + self.itemInsets.bottom;
    self.currentContentSize = CGSizeMake(self.collectionView.bounds.size.width, height);
}

- (CGSize)collectionViewContentSize
{
    return self.currentContentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.layouttInfosArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemLayoutDict = [self.layoutInfoDict objectForKey:BHPhotoAlbumLayoutPhotoCellKind];
    return [itemLayoutDict objectForKey:indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *supplementaryLayoutDict = [self.layoutInfoDict objectForKey:BHPhotoAlbumLayoutAlbumTitleKind];
    return [supplementaryLayoutDict objectForKey:indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind
                                                                  atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *decorationLayoutDict = [self.layoutInfoDict objectForKey:BHPhotoEmblemKind];
    return [decorationLayoutDict objectForKey:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

#pragma mark - Private methods
- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath forCellItemSize:(CGSize )cellSize;
{
    CGRect cellFrame      = CGRectZero;
    cellFrame.origin.x    = self.itemInsets.left;
    cellFrame.origin.y    = self.totalOriginYCalculation;
    cellFrame.size.width  = cellSize.width;
    cellFrame.size.height = cellSize.height;
    
    self.totalOriginYCalculation += floor(cellSize.height);
    return cellFrame;
}

- (CGRect)frameForSuplementaryAtIndexPath:(NSIndexPath *)indexPath forCellItemSize:(CGSize )cellSize;
{
    CGRect suplementaryFrame      = CGRectZero;
    suplementaryFrame.origin.x    = self.itemInsets.left;
    suplementaryFrame.origin.y    = (self.totalOriginYCalculation - cellSize.height - self.titleHeight);
    suplementaryFrame.size.width  = cellSize.width;
    suplementaryFrame.size.height = self.titleHeight;
    self.totalOriginYCalculation += self.titleHeight + self.interItemSpacingY;
    return suplementaryFrame;
}

- (CGRect)frameForDecorative;
{
    CGSize size = [BHEmblemView defaultSize];
    CGFloat originX = floorf((self.collectionView.bounds.size.width - size.width) * 0.5f);
    CGFloat originY = -size.height - 30.0f;
    return CGRectMake(originX, originY, size.width, size.height);
}

@end
