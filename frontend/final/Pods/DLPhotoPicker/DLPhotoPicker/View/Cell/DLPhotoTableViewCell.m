/*
 
 MIT License (MIT)
 
 Copyright (c) 2016 DarlingCoder
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import <PureLayout/PureLayout.h>
#import "DLPhotoPickerDefines.h"
#import "DLPhotoTableViewCell.h"
#import "NSBundle+DLPhotoPicker.h"
#import "UIImage+DLPhotoPicker.h"
#import "NSNumberFormatter+DLPhotoPicker.h"
#import "DLPhotoManager.h"

@interface DLPhotoTableViewCell ()

@property (nonatomic, assign) CGSize thumbnailSize;

@property (nonatomic, strong) DLPhotoThumbnailStacks *thumbnailStacks;
@property (nonatomic, strong) UIView *labelsView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic, strong) DLPhotoCollection *collection;
@property (nonatomic, assign) NSUInteger count;

@end





@implementation DLPhotoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _thumbnailSize          = DLPhotoCollectionThumbnailSize;
        
        _titleTextColor         = DLPhotoCollectionViewCellTitleTextColor;
        _selectedTitleTextColor = DLPhotoCollectionViewCellTitleTextColor;
        _countTextColor         = DLPhotoCollectionViewCellCountTextColor;
        _selectedCountTextColor = DLPhotoCollectionViewCellCountTextColor;

        _accessoryColor         = DLPhotoCollectionViewCellAccessoryColor;
        _selectedAccessoryColor = DLPhotoCollectionViewCellAccessoryColor;

        self.opaque                             = YES;
        self.isAccessibilityElement             = YES;
        self.textLabel.backgroundColor          = self.backgroundColor;
        self.detailTextLabel.backgroundColor    = self.backgroundColor;
        self.accessoryType                      = UITableViewCellAccessoryNone;
        
        [self setupViews];
    }
    
    return self;
}

#pragma mark - Setup

- (void)setupViews
{
    DLPhotoThumbnailStacks *thumbnailStacks = [DLPhotoThumbnailStacks newAutoLayoutView];
    thumbnailStacks.thumbnailSize = self.thumbnailSize;
    self.thumbnailStacks = thumbnailStacks;
    
    UILabel *titleLabel = [UILabel newAutoLayoutView];
    titleLabel.font = DLPhotoCollectionViewCellTitleFont;
    titleLabel.textColor = self.titleTextColor;
    self.titleLabel = titleLabel;
    
    UILabel *countLabel = [UILabel newAutoLayoutView];
    countLabel.font = DLPhotoCollectionViewCellCountFont;
    countLabel.textColor = self.countTextColor;
    self.countLabel = countLabel;
    
    UIView *labelsView = [UIView newAutoLayoutView];
    [labelsView addSubview:self.titleLabel];
    [labelsView addSubview:self.countLabel];
    self.labelsView = labelsView;
    
    [self.contentView addSubview:self.thumbnailStacks];
    [self.contentView addSubview:self.labelsView];
    
    UIImage *accessory = [UIImage assetImageNamed:@"DisclosureArrow"];
    accessory = [accessory imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:accessory];
    accessoryView.tintColor = self.accessoryColor;
    self.accessoryView = accessoryView;
}

- (void)setupPlaceholderImage
{
    NSString *imageName = [self placeHolderImageNameOfCollectionSubtype:self.collection.assetCollection.assetCollectionSubtype];
    UIImage *image = [UIImage assetImageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    for (DLPhotoThumbnailView *thumbnailView in self.thumbnailStacks.thumbnailViews)
    {
        [thumbnailView bind:nil assetCollection:nil];
        [thumbnailView setBackgroundImage:image];
    }
}

- (NSString *)placeHolderImageNameOfCollectionSubtype:(PHAssetCollectionSubtype)subtype
{
    if (subtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary)
        return @"GridEmptyCameraRoll";
    
    else if (subtype == PHAssetCollectionSubtypeSmartAlbumAllHidden)
        return @"GridHiddenAlbum";
    
    else if (subtype == PHAssetCollectionSubtypeAlbumCloudShared)
        return @"GridEmptyAlbumShared";
    
    else
        return @"GridEmptyAlbum";
}


#pragma mark - Apperance

- (UIFont *)titleFont
{
    return self.titleLabel.font;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    UIFont *font = (titleFont) ? titleFont : DLPhotoCollectionViewCellTitleFont;
    self.titleLabel.font = font;
}

- (void)setTitleTextColor:(UIColor *)titleTextColor
{
    UIColor *color = (titleTextColor) ? titleTextColor : DLPhotoCollectionViewCellTitleTextColor;
    _titleTextColor = color;
}

- (void)setSelectedTitleTextColor:(UIColor *)titleTextColor
{
    UIColor *color = (titleTextColor) ? titleTextColor : DLPhotoCollectionViewCellTitleTextColor;
    _selectedTitleTextColor = color;
}

- (UIFont *)countFont
{
    return self.countLabel.font;
}

- (void)setCountFont:(UIFont *)countFont
{
    UIFont *font = (countFont) ? countFont : DLPhotoCollectionViewCellCountFont;
    self.countLabel.font = font;
}

- (void)setCountTextColor:(UIColor *)countTextColor
{
    UIColor *color = (countTextColor) ? countTextColor : DLPhotoCollectionViewCellCountTextColor;
    _countTextColor = color;
}

- (void)setSelectedCountTextColor:(UIColor *)countTextColor
{
    UIColor *color = (countTextColor) ? countTextColor : DLPhotoCollectionViewCellCountTextColor;
    _selectedCountTextColor = color;
}

- (void)setAccessoryColor:(UIColor *)accessoryColor
{
    UIColor *color = (accessoryColor) ? accessoryColor : DLPhotoCollectionViewCellAccessoryColor;
    _accessoryColor = color;
}

- (void)setSelectedAccessoryColor:(UIColor *)accessoryColor
{
    UIColor *color = (accessoryColor) ? accessoryColor : DLPhotoCollectionViewCellAccessoryColor;
    _selectedAccessoryColor = color;
}

- (UIColor *)selectedBackgroundColor
{
    return self.selectedBackgroundView.backgroundColor;
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor
{
    if (!selectedBackgroundColor)
        self.selectedBackgroundView = nil;
    else
    {
        UIView *view = [UIView new];
        view.backgroundColor = selectedBackgroundColor;
        self.selectedBackgroundView = view;
    }
}


#pragma mark - Override highlighted / selected

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self.thumbnailStacks setHighlighted:highlighted];
    
    self.titleLabel.textColor = (highlighted) ? self.selectedTitleTextColor : self.titleTextColor;
    self.countLabel.textColor = (highlighted) ? self.selectedCountTextColor : self.countTextColor;
    self.accessoryView.tintColor = (highlighted) ? self.selectedAccessoryColor : self.accessoryColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self.thumbnailStacks setHighlighted:selected];
    
    self.titleLabel.textColor = (selected) ? self.selectedTitleTextColor : self.titleTextColor;
    self.countLabel.textColor = (selected) ? self.selectedCountTextColor : self.countTextColor;
    self.accessoryView.tintColor = (selected) ? self.selectedAccessoryColor : self.accessoryColor;
}

#pragma mark - Update auto layout constraints

- (void)updateConstraints
{
    if (!self.didSetupConstraints)
    {
        CGSize size = self.thumbnailSize;
        CGFloat top = self.thumbnailStacks.edgeInsets.top;
        size.height += top;
        
        [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.thumbnailStacks autoSetDimensionsToSize:size];
        }];
                
        [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            [self.thumbnailStacks autoPinEdgesToSuperviewMarginsExcludingEdge:ALEdgeTrailing];
        }];
        
        [self.labelsView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.labelsView autoPinEdge:ALEdgeLeading
                              toEdge:ALEdgeTrailing
                              ofView:self.thumbnailStacks
                          withOffset:self.labelsView.layoutMargins.left
                            relation:NSLayoutRelationGreaterThanOrEqual];
        
        [self.titleLabel autoPinEdgesToSuperviewMarginsExcludingEdge:ALEdgeBottom];
        [self.countLabel autoPinEdgesToSuperviewMarginsExcludingEdge:ALEdgeTop];
        [self.countLabel autoPinEdge:ALEdgeTop
                              toEdge:ALEdgeBottom
                              ofView:self.titleLabel
                          withOffset:self.countLabel.layoutMargins.top
                            relation:NSLayoutRelationGreaterThanOrEqual];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}


#pragma mark - Bind asset collection

- (void)bind:(DLPhotoCollection *)collection count:(NSUInteger)count
{
    self.collection = collection;
    self.count      = collection.count;

    [self setupPlaceholderImage];

    [self.titleLabel setText:collection.title];

    if (count != NSNotFound)
    {
        NSNumberFormatter *nf = [NSNumberFormatter new];
        [self.countLabel setText:[nf assetStringFromAssetCount:count]];
    }
    
    [self setupThumbnailsImageV2:collection];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)setupThumbnailsImage:(DLPhotoCollection *)collection
{
    NSUInteger count    = self.thumbnailStacks.thumbnailViews.count;
    NSArray *assets     = [[DLPhotoManager sharedInstance] posterAssetsForPhotoCollection:collection count:count];
    
    for (NSUInteger index = 0; index < count; index++)
    {
        DLPhotoThumbnailView *thumbnailView = [self.thumbnailStacks thumbnailAtIndex:index];
        thumbnailView.hidden = (assets.count > 0) ? YES : NO;
        
        if (index < assets.count)
        {
            DLPhotoAsset *asset = assets[index];
            [asset requestThumbnailImageWithSize:self.thumbnailSize completion:^(UIImage *image, NSDictionary *info) {
                [thumbnailView setHidden:NO];
                [thumbnailView bind:image assetCollection:collection];
            }];
        }
    }
}

- (void)setupThumbnailsImageV2:(DLPhotoCollection *)collection
{
    NSUInteger count    = self.thumbnailStacks.thumbnailViews.count;
    NSArray *images     = [[DLPhotoManager sharedInstance] posterImagesForPhotoCollection:collection
                                                                            thumbnailSize:self.thumbnailSize
                                                                                    count:count];
    
    for (NSUInteger index = 0; index < images.count; index++)
    {
        DLPhotoThumbnailView *thumbnailView = [self.thumbnailStacks thumbnailAtIndex:index];
        thumbnailView.hidden = (images.count > 0) ? YES : NO;
        
        UIImage *image = images[index];
        if (image) {
            [thumbnailView setHidden:NO];
            [thumbnailView bind:image assetCollection:collection];
        }
    }
}


#pragma mark - Accessibility label

- (NSString *)accessibilityLabel
{
    NSString *title = self.titleLabel.text;
    NSString *count = [NSString stringWithFormat:DLPhotoPickerLocalizedString(@"%@ Photos", nil), self.countLabel.text];
    
    NSArray *labels = @[title, count];
    return [labels componentsJoinedByString:@","];
}

@end