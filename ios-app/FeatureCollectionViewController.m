//
//  FeatureCollectionViewController.m
//  ios-app
//
//  Created by Shannon Phu on 9/8/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "FeatureCollectionViewController.h"
#import "TileCollectionViewCell.h"
#import "FeaturedTileCollectionViewCell.h"
#import "TileCollectionViewCellB.h"
#import "DataParser.h"
#import <UIImageView+AFNetworking.h>
#import "FullPostViewController.h"

#define CELL_IDENTIFIER @"TileCell"
#define CELL_IDENTIFIER_2 @"TileCell2"
#define HEADER_IDENTIFIER @"TopFeatured"
static NSString * const SEGUE_IDENTIFIER = @"viewPost";

@interface FeatureCollectionViewController () {
    int page;
    Post *seguePost;
}
@property (nonatomic, strong) NSArray *cellSizes;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) Post *topFeatured;
@end

@implementation FeatureCollectionViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    
    // Start loading data from JSON page 1
    page = 1;
    self.topFeatured = [[DataParser DataForRecentPostsWithPageNumber:1] firstObject];
    self.posts = [self getDataForPage:page];
}

- (void)viewWillAppear:(BOOL)animated {
    seguePost = nil;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (NSArray *)getDataForPage:(int)pageNum {
    int p = pageNum;
    if (pageNum <= 0 || pageNum > self.posts.count) {
        p = 1;
    }
    return [DataParser DataForFeaturedPostsWithPageNumber:p];
}

#pragma mark - Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
        layout.headerHeight = self.view.frame.size.height / 1.5;
        // layout.footerHeight = 10;
        layout.minimumColumnSpacing = 10.0f;
        layout.minimumInteritemSpacing = 10.0f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50.0f, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
        [_collectionView registerClass:[TileCollectionViewCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_collectionView registerClass:[TileCollectionViewCellB class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER_2];
        
        [_collectionView registerClass:[FeaturedTileCollectionViewCell class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:HEADER_IDENTIFIER];
    }
    return _collectionView;
}

- (NSArray *)cellSizes {
    if (!_cellSizes) {
        _cellSizes = @[
                       
       // staggering causes some dequeue placement errors
//       [NSValue valueWithCGSize:CGSizeMake(1, 1.5)],
//       [NSValue valueWithCGSize:CGSizeMake(1, 1)],
//       [NSValue valueWithCGSize:CGSizeMake(1, 1.25)],
//       [NSValue valueWithCGSize:CGSizeMake(1, 1.33)]

       [NSValue valueWithCGSize:CGSizeMake(1, 1.5)],
       [NSValue valueWithCGSize:CGSizeMake(1, 1.5)],
       [NSValue valueWithCGSize:CGSizeMake(1, 1.5)],
       [NSValue valueWithCGSize:CGSizeMake(1, 1.5)]
       
//       [NSValue valueWithCGSize:CGSizeMake(1, 2)],
//       [NSValue valueWithCGSize:CGSizeMake(1, 1)],
//       [NSValue valueWithCGSize:CGSizeMake(1, 1)],
//       [NSValue valueWithCGSize:CGSizeMake(1, 1)],
//       [NSValue valueWithCGSize:CGSizeMake(1, 2)],
//       [NSValue valueWithCGSize:CGSizeMake(1, 1)]
       
//       [NSValue valueWithCGSize:CGSizeMake(1, 2)],
//       [NSValue valueWithCGSize:CGSizeMake(1, 1)],
//       [NSValue valueWithCGSize:CGSizeMake(1, 1)]
       
       ];
    }
    return _cellSizes;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item % 2 == 0) {
        TileCollectionViewCell *cell = [self setTileInfoWithIndexPath:indexPath];
        
        return cell;
    } else {
        TileCollectionViewCellB *cell = [self setTileBInfo:indexPath];
        return cell;
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        __weak FeaturedTileCollectionViewCell *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(showTopFeatured:)];
        
        [reusableView addGestureRecognizer:tap];
        
        Post *post = [self.posts objectAtIndex:indexPath.item];
        reusableView.title.text = post.title;
        reusableView.excerpt.text = post.excerpt;

        
        NSURLRequest *requestLeft = [NSURLRequest requestWithURL:[NSURL URLWithString:post.thumbnailCoverImageURL]];
        [reusableView.imageView setImageWithURLRequest:requestLeft placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            reusableView.imageView.image = image;
        } failure:nil];
        
        reusableView.backgroundColor = [UIColor whiteColor];
        
        return reusableView;
    }
    
    return nil;
}

- (TileCollectionViewCell *)setTileInfoWithIndexPath:(NSIndexPath *)indexPath {
    
    __weak TileCollectionViewCell *cell = (TileCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    Post *post = [self.posts objectAtIndex:indexPath.item];
    
    NSURLRequest *requestLeft = [NSURLRequest requestWithURL:[NSURL URLWithString:post.thumbnailCoverImageURL]];
    [cell.imageView setImageWithURLRequest:requestLeft placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageView.image = image;
    } failure:nil];
    
    cell.title.text = post.title;
    NSString *tagStr = @"";
    for (NSString *tag in post.tags) {
        tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"#%@ ", tag]];
    }
    cell.excerpt.text = tagStr;
    
    return cell;

    
}

- (TileCollectionViewCellB *)setTileBInfo:(NSIndexPath *)indexPath {
    __weak TileCollectionViewCellB *cell = (TileCollectionViewCellB *)[self.collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER_2 forIndexPath:indexPath];
    
    Post *post = [self.posts objectAtIndex:indexPath.item];
    
    NSURLRequest *requestLeft = [NSURLRequest requestWithURL:[NSURL URLWithString:post.thumbnailCoverImageURL]];
    [cell.imageView setImageWithURLRequest:requestLeft placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageView.image = image;
    } failure:nil];
    
    cell.title.text = post.title;
    cell.excerpt.text = post.excerpt;
    
    return cell;
}

- (void)showTopFeatured:(UITapGestureRecognizer *)recognizer {
    [self performSegueWithIdentifier:SEGUE_IDENTIFIER sender:self.topFeatured];
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellSizes[indexPath.item % 4] CGSizeValue];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:SEGUE_IDENTIFIER sender:[self.posts objectAtIndex:indexPath.item]];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:SEGUE_IDENTIFIER] && [segue.destinationViewController isKindOfClass:[FullPostViewController class]]) {
        FullPostViewController *postVC = segue.destinationViewController;
        if ([sender isKindOfClass:[Post class]])
            postVC.post = sender;
        else
            postVC.post = nil;
    }
}


@end
