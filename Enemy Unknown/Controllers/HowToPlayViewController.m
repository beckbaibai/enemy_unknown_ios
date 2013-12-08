//
//  HowToPlayViewController.m
//  Enemy Unknown
//
//  Created by Frank Zhang on 11/19/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import "HowToPlayViewController.h"
#import "OLImage.h"
#import "OLImageView.h"

@interface HowToPlayViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property bool pageControlUsed;

@end

@implementation HowToPlayViewController

/**
 * In loadView, we load the game logo, which is a GIF animated picture, using OLImage library.
 */
- (void)loadView
{
    [super loadView];
    
    // Use OLImage and OLImageView instead of default UIImage and UIImageView in order to show gif
    self.logo = [[OLImageView alloc] initWithFrame:CGRectMake(312, 100, 400, 125)];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"gif"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    NSData *logoData = [NSData dataWithContentsOfURL:fileURL];
    UIImage *logoImage = [OLImage imageWithData:logoData];
    self.logo.image = logoImage;
    [self.view addSubview:self.logo];
}

/**
 * In viewDidLoad, we load two GIF animated images that help users learn how to play our games.
 * Then we put them in self.pageImages. 
 * We also set the number of pages of our pageView to the number of GIF images we have, i.e. 2.
 * Finally, we initialize self.pageViews, which is an array that will contain UIImageViews enclosing our GIF images.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageControlUsed = NO;
    NSString *filepath1 = [[NSBundle mainBundle] pathForResource:@"howtoplaycamera" ofType:@"gif"];
    NSURL *fileURL1 = [NSURL fileURLWithPath:filepath1];
    NSData *fileData1 = [NSData dataWithContentsOfURL:fileURL1];
    UIImage *howToPlayCamera = [OLImage imageWithData:fileData1];
    NSString *filepath2 = [[NSBundle mainBundle] pathForResource:@"howtoplaymoveattack" ofType:@"gif"];
    NSURL *fileURL2 = [NSURL fileURLWithPath:filepath2];
    NSData *fileData2= [NSData dataWithContentsOfURL:fileURL2];
    UIImage *howToPlayMoveAttack = [OLImage imageWithData:fileData2];
    self.pageImages = [NSArray arrayWithObjects:
                       howToPlayCamera,
                       howToPlayMoveAttack,
                       nil];
    NSInteger pageCount = self.pageImages.count;

    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
}

/**
 * In viewWillAppear:, we calculate the content size of the scroll view and load the visible pages.
 * The content width of the scroll view is the frame width multiplied by the number of images that we have,
 * and pageControl will control which image to show.
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    [self loadVisiblePages];
}

/**
 * Action for back button. Pop out the previous view in navigation controller.
 */
- (IBAction)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PageView

/**
 * Load currently visible pages.
 */
- (void)loadVisiblePages
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    self.pageControl.currentPage = page;
    if (page==0) {
        self.label.text =@"How to move camera";
    } else {
        self.label.text =@"How to move units and attack other units.";
    }
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }

    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
}

/**
 * Load the specified page's view.
 */
- (void)loadPage:(NSInteger)page
{
    if (page < 0 || page >= self.pageImages.count) {
        // Invalid page number
        return;
    }

    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        // This page has not been created
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        UIImageView *newPageView = [[OLImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

/**
 * Purge the specified page's view.
 */
- (void)purgePage:(NSInteger)page
{
    if (page < 0 || page >= self.pageImages.count) {
        return;
    }
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

/**
 * Action to be fired when the user changes page through pageControl.
 */
- (IBAction)pageChanged:(UIPageControl *)sender
{
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;

    self.pageControlUsed = YES;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    if (self.pageControl.currentPage==0) {
        self.label.text =@"How to move camera";
    } else {
        self.label.text =@"How to move units and attack other units.";
    }
    
}

#pragma mark - ScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.pageControlUsed == NO) {
        [self loadVisiblePages];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControlUsed = NO;
}

@end
