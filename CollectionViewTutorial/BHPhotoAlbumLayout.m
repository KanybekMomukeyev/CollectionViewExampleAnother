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

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGRect)frameForSuplementaryAtIndexPath:(NSIndexPath *)indexPath;
- (CGRect)frameForDecorative;

@end

@implementation BHPhotoAlbumLayout

- (NSMutableArray *)layouttInfosArray
{
    if (!_layouttInfosArray) {
        _layouttInfosArray = [NSMutableArray new];
    }
    return _layouttInfosArray;
}


#pragma mark - Properties
- (void)setItemInsets:(UIEdgeInsets)itemInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(_itemInsets, itemInsets)) return;
    
    _itemInsets = itemInsets;
    
    [self invalidateLayout];
}

- (void)setItemSize:(CGSize)itemSize
{
    if (CGSizeEqualToSize(_itemSize, itemSize)) return;
    
    _itemSize = itemSize;
    
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
    self.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    self.itemSize = CGSizeMake(125.0f, 125.0f);
    self.interItemSpacingY = 20.0f;
    self.titleHeight = 30.0f;
    [self registerClass:[BHEmblemView class] forDecorationViewOfKind:BHPhotoEmblemKind];
}


#pragma mark - Layout

- (void)prepareLayout
{
    NSMutableDictionary *newLayoutInfoDict   = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfoDict  = [NSMutableDictionary dictionary];
    NSMutableDictionary *titleLayoutInfoDict = [NSMutableDictionary dictionary];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *emblemAttributes = [UICollectionViewLayoutAttributes
                                                          layoutAttributesForDecorationViewOfKind:BHPhotoEmblemKind withIndexPath:indexPath];
    emblemAttributes.frame = [self frameForDecorative];
    newLayoutInfoDict[BHPhotoEmblemKind] = @{indexPath: emblemAttributes};
    
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger item = 0; item < itemCount; item++) {
        indexPath = [NSIndexPath indexPathForItem:item inSection:0];

        // -------- ITEM ATTRIBUTE CALLCULATION --------- //
        UICollectionViewLayoutAttributes *itemAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        itemAttributes.frame = [self frameForItemAtIndexPath:indexPath];
        
        cellLayoutInfoDict[indexPath] = itemAttributes;
        
        // -------- SUPLEMENTARY ATTRIBUTE CALLCULATION ------------ //
        UICollectionViewLayoutAttributes *titleAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleKind withIndexPath:indexPath];
        titleAttributes.frame = [self frameForSuplementaryAtIndexPath:indexPath];
        titleLayoutInfoDict[indexPath] = titleAttributes;
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
    CGFloat height = self.itemInsets.top + rowCount * self.itemSize.height +
                     (rowCount - 1) * self.interItemSpacingY + rowCount * self.titleHeight +
    self.itemInsets.bottom;
    
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

#pragma mark - Private
- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSInteger row = indexPath.item;
    CGFloat originY = floor(self.itemInsets.top +
                      (self.itemSize.height + self.titleHeight + self.interItemSpacingY) * row);
    
    CGRect rect = CGRectMake(self.itemInsets.left, originY, self.itemSize.width, self.itemSize.height);
    return rect;
}

- (CGRect)frameForSuplementaryAtIndexPath:(NSIndexPath *)indexPath;
{
    CGRect frame = [self frameForItemAtIndexPath:indexPath];
    
    frame.origin.y += frame.size.height;
    frame.size.height = self.titleHeight;
    return frame;
}

- (CGRect)frameForDecorative;
{
    CGSize size = [BHEmblemView defaultSize];
    CGFloat originX = floorf((self.collectionView.bounds.size.width - size.width) * 0.5f);
    CGFloat originY = -size.height - 30.0f;
    return CGRectMake(originX, originY, size.width, size.height);
}

@end
