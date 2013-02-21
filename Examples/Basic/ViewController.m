//
//  ViewController.m
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "ViewController.h"
#import "Cell.h"

@interface ViewController ()

@property (atomic, readwrite, assign) NSInteger cellCount;
@property (atomic, readwrite, assign) BOOL doingInifiniteScroll;

@end


@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

    self.cellCount = 63;
	
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"MY_CELL"];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSTCollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.cellCount;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSTCollectionViewDelegate

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSTCollectionViewDelegateFlowLayout

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(200, 200);
}

- (CGFloat)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 50;
}

//------------------------------------------------------------------------------
#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isViewLoaded || !self.view.window) {
        return;
    }

    // See if we're within the threshold to refresh
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat gridViewHeight = scrollView.bounds.size.height;

    // Make sure the threshold is above 0
    CGFloat threshold = contentHeight - 3 * gridViewHeight;
    CGFloat contentOffset = scrollView.contentOffset.y;

    if (threshold > 0 && contentOffset < threshold) {
        // We have enough content to keep displaying stuff
        return;
    }

    if (self.doingInifiniteScroll) {
        return;
    }

    self.doingInifiniteScroll = YES;

    // Simulate a network request
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSUInteger newCellCount = 40;
        NSUInteger startCellCount = self.cellCount;
        self.cellCount += newCellCount;
        [self.collectionView performBatchUpdates:^{
            for (NSUInteger i = 0; i < newCellCount; i++) {
                NSIndexPath *path = [NSIndexPath indexPathForItem:startCellCount + i inSection:0];
                [self.collectionView insertItemsAtIndexPaths:@[path]];
            }
        } completion:nil];

        self.doingInifiniteScroll = NO;
    });
}

@end
