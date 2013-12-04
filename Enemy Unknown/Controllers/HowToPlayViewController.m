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


- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    [self loadVisiblePages];
}

- (void)loadVisiblePages {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    self.pageControl.currentPage = page;
    if(page==0){
        self.label.text =@"How to move camera";
    }else{
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
- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        return;
    }

    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
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

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        return;
    }
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.pageControlUsed == NO){
        [self loadVisiblePages];
    }
}

- (IBAction)pageChanged:(UIPageControl *)sender {
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;

    self.pageControlUsed = YES;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    if(self.pageControl.currentPage==0){
        self.label.text =@"How to move camera";
    }else{
        self.label.text =@"How to move units and attack other units.";
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControlUsed = NO;
}

@end
