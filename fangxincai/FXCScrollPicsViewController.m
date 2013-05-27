//
//  FXCScrollPicsViewController.m
//  fangxincai
//
//  Created by Bowen GAO on 5/27/13.
//  Copyright (c) 2013 Bowen GAO. All rights reserved.
//

#import "FXCScrollPicsViewController.h"

#define SCROLL_VIEW_WIDTH           320
#define SCROLL_VIEW_HEIGHT          200
#define SCROLL_IMAGES_NUMBER        4
#define SCROLL_IMAGES_BUFFER        3
#define PREV_PAGE_NUMBER            0
#define CURRENT_PAGE_NUMBER         1
#define NEXT_PAGE_NUMBER            2
#define PAGE_CONTROL_HEIGHT         20


@interface FXCScrollPicsViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) UIImageView *prevImage;
@property (strong, nonatomic) UIImageView *currentImage;
@property (strong, nonatomic) UIImageView *nextImage;

@property (strong, nonatomic) NSMutableArray *imageUrlArray;

@property (nonatomic) int prevIndex;
@property (nonatomic) int currentIndex;
@property (nonatomic) int nextIndex;

- (void)loadPageWithId:(int)index onPage:(int)page;

@end

@implementation FXCScrollPicsViewController

@synthesize scrollView = _scrollView, pageControl = _pageControl;
@synthesize prevImage = _prevImage, currentImage = _currentImage, nextImage = _nextImage;
@synthesize imageUrlArray = _imageUrlArray;
@synthesize prevIndex = _prevIndex, currentIndex = _currentIndex, nextIndex = _nextIndex;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Set up the page control
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = SCROLL_IMAGES_NUMBER;
    CGRect pageFrame = _pageControl.frame;
    pageFrame.origin.y = pageFrame.origin.y + pageFrame.size.height - PAGE_CONTROL_HEIGHT;
    pageFrame.size.height = PAGE_CONTROL_HEIGHT;
    _pageControl.frame = pageFrame;
    
    // Init image urls
    _imageUrlArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < SCROLL_IMAGES_NUMBER; i++) {
        [_imageUrlArray addObject:[NSString stringWithFormat:@"test.jpg"]];
    }
    
    // Init imageView frame
    _prevImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCROLL_VIEW_WIDTH, SCROLL_VIEW_HEIGHT)];
    _currentImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCROLL_VIEW_WIDTH, 0, SCROLL_VIEW_WIDTH, SCROLL_VIEW_HEIGHT)];
    _nextImage = [[UIImageView alloc] initWithFrame:CGRectMake(2 * SCROLL_VIEW_WIDTH, 0, SCROLL_VIEW_WIDTH, SCROLL_VIEW_HEIGHT)];

    _prevImage.contentMode = UIViewContentModeScaleToFill;
    _currentImage.contentMode = UIViewContentModeScaleToFill;
    _nextImage.contentMode = UIViewContentModeScaleToFill;

    [self loadPageWithId:SCROLL_IMAGES_NUMBER-1 onPage:PREV_PAGE_NUMBER];
	[self loadPageWithId:0 onPage:CURRENT_PAGE_NUMBER];
	[self loadPageWithId:1 onPage:NEXT_PAGE_NUMBER];
    
    [_scrollView addSubview:_prevImage];
    [_scrollView addSubview:_currentImage];
    [_scrollView addSubview:_nextImage];

    // Init scroll view
	_scrollView.contentSize = CGSizeMake(SCROLL_IMAGES_BUFFER * SCROLL_VIEW_WIDTH, SCROLL_VIEW_HEIGHT);
	[_scrollView scrollRectToVisible:CGRectMake(SCROLL_VIEW_WIDTH, 0, SCROLL_VIEW_WIDTH, SCROLL_VIEW_HEIGHT) animated:NO];
    
    // Auto scrolling
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(autoScrolling) userInfo:nil repeats:YES];

}

- (void)autoScrolling
{
    [UIView animateWithDuration:0.8
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [_scrollView setContentOffset:CGPointMake(2 * SCROLL_VIEW_WIDTH, 0) ];// animated:NO];
                     } completion:^(BOOL finished){
                         [self scrollViewDidEndDecelerating:_scrollView];
                     }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPageWithId:(int)index onPage:(int)page {
	// load data for page
	switch (page) {
		case PREV_PAGE_NUMBER:
            _prevImage.image = [UIImage imageNamed:[_imageUrlArray objectAtIndex:index]];
            break;
		case CURRENT_PAGE_NUMBER:
            _currentImage.image = [UIImage imageNamed:[_imageUrlArray objectAtIndex:index]];
			break;
		case NEXT_PAGE_NUMBER:
            _nextImage.image = [UIImage imageNamed:[_imageUrlArray objectAtIndex:index]];
			break;
	}
}


#pragma mark - ScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {

	if(_scrollView.contentOffset.x > _scrollView.frame.size.width) {
		// We are moving forward. Load the current doc data on the first page.
		[self loadPageWithId:_currentIndex onPage:PREV_PAGE_NUMBER];
		// Add one to the currentIndex or reset to 0 if we have reached the end.
		_currentIndex = (_currentIndex >= SCROLL_IMAGES_NUMBER-1) ? 0 : _currentIndex + 1;
		[self loadPageWithId:_currentIndex onPage:CURRENT_PAGE_NUMBER];
		// Load content on the last page. This is either from the next item in the array
		// or the first if we have reached the end.
		_nextIndex = (_currentIndex >= SCROLL_IMAGES_NUMBER-1) ? 0 : _currentIndex + 1;
		[self loadPageWithId:_nextIndex onPage:NEXT_PAGE_NUMBER];
	}
	if(_scrollView.contentOffset.x < _scrollView.frame.size.width) {
		// We are moving backward. Load the current doc data on the last page.
		[self loadPageWithId:_currentIndex onPage:NEXT_PAGE_NUMBER];
		// Subtract one from the currentIndex or go to the end if we have reached the beginning.
		_currentIndex = (_currentIndex == 0) ? SCROLL_IMAGES_NUMBER-1 : _currentIndex - 1;
		[self loadPageWithId:_currentIndex onPage:CURRENT_PAGE_NUMBER];
		// Load content on the first page. This is either from the prev item in the array
		// or the last if we have reached the beginning.
		_prevIndex = (_currentIndex == 0) ? SCROLL_IMAGES_NUMBER-1 : _currentIndex - 1;
		[self loadPageWithId:_prevIndex onPage:PREV_PAGE_NUMBER];
	}
	
	// Reset offset back to middle page
	[_scrollView scrollRectToVisible:CGRectMake(SCROLL_VIEW_WIDTH, 0, SCROLL_VIEW_WIDTH, SCROLL_VIEW_HEIGHT) animated:NO];


    _pageControl.currentPage = _currentIndex;
}


@end
