//
//  HomeViewController.m
//  WSDZhihuDaily
//
//  Created by Wang Shudao on 12/25/15.
//  Copyright © 2015 WSD. All rights reserved.
//

#import "HomeViewController.h"
#import "WSDCarouselView.h"
#import "WSDTopStory.h"
#import "WSDStoryCell.h"
#import "WSDRefreshView.h"
#import "WSDSideMenuViewController.h"
#import "WSDDataUtils.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate,
UIScrollViewDelegate>
@property(weak, nonatomic) IBOutlet WSDCarouselView *carouselView;
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet WSDRefreshView *refreshView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *carouselViewTop;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *carouselViewHeight;
@property(weak, nonatomic) IBOutlet UIButton *showSideMenuButton;
@property(weak, nonatomic) IBOutlet UIView *homeView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *homeViewLeft;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *homeViewRight;
@property (weak, nonatomic) IBOutlet UILabel *todayTitleLabel;

@property(nonatomic, strong) UIView *topView;
@property(nonatomic, assign) BOOL isRefreshing;
@property(nonatomic, assign) BOOL isShowSideMenu;
@property(nonatomic, strong) WSDSideMenuViewController *sideMenuVC;
@property(nonatomic, strong) UITapGestureRecognizer *tapToHideSideMenu;
@property(nonatomic, strong) UIPanGestureRecognizer *pan;
@property(nonatomic, strong) UIView *tapView;
@property(nonatomic, assign) NSInteger days;
@property(nonatomic, assign) BOOL isLoading;
@property(nonatomic, strong) NSMutableArray *data;

@end

@implementation HomeViewController

static CGFloat const kSideMenuWidth = 225.f;
static CGFloat const kRefreshOffsetY = 40.f;
static CGFloat const kSideMenuAnimationDuration = 0.2f;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.days = -1;
    self.data = [NSMutableArray new];
    
    // setup the side menu
    self.sideMenuVC = [[WSDSideMenuViewController alloc]
                       initWithNibName:@"WSDSideMenuViewController"
                       bundle:nil];
    [self.view addSubview:self.sideMenuVC.view];
    [self addChildViewController:self.sideMenuVC];
    [self.sideMenuVC didMoveToParentViewController:self];
    self.sideMenuVC.view.right = 0;
    self.sideMenuVC.view.top = 0;
    self.sideMenuVC.view.height = kScreenHeight;
    self.sideMenuVC.view.width = 225;
    self.isShowSideMenu = NO;
    
    // setup story table view
    [self.tableView registerNib:[UINib nibWithNibName:@"WSDStoryCell" bundle:nil]
         forCellReuseIdentifier:@"StoryCell"];
//    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    // init the gestures for hiding the side menu
    self.tapToHideSideMenu =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(hideSideMenu)];
    self.pan = [[UIPanGestureRecognizer alloc]
                initWithTarget:self
                action:@selector(handlePanGesture:)];
    [self.homeView addGestureRecognizer:self.pan];
    
    // fetch the latest daily stories
    [self fetchData];
}

- (void)fetchData {
    self.isLoading = YES;
    
    NSString *url = nil;
    if (self.days == -1) {
        url = @"http://news-at.zhihu.com/api/4/news/latest";
    } else {
        url = [@"http://news.at.zhihu.com/api/4/news/before/"
               stringByAppendingString:[WSDDataUtils dateStringBeforeDays:self.days]];
    }
    LxDBAnyVar(url);
    
    NSURLSessionConfiguration *config =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    
    [[manager GET:url
       parameters:nil
         progress:^(NSProgress *_Nonnull downloadProgress) {
             
         }
          success:^(NSURLSessionDataTask *_Nonnull task,
                    id _Nullable responseObject) {
              if (self.days == -1) {
                  NSArray *topStoriesJSON = responseObject[@"top_stories"];
                  NSMutableArray *topStories = [NSMutableArray new];
                  for (NSDictionary *json in topStoriesJSON) {
                      WSDTopStory *ts = [[WSDTopStory alloc] initWithJSON:json];
                      [topStories addObject:ts];
                  }
                  [self.carouselView setTopStories:topStories];
              }
              
              NSArray *storiesJSON = responseObject[@"stories"];
              NSMutableArray *stories = [NSMutableArray new];
              
              for (NSDictionary *json in storiesJSON) {
                  WSDStory *story = [[WSDStory alloc] initWithJSON:json];
                  [stories addObject:story];
              }
              [self.data addObject:[NSArray arrayWithArray:stories]];
              
              [self.tableView reloadData];
              
              self.isLoading = NO;
              self.days++;
          }
          failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
              LxDBAnyVar(error);
              self.isLoading = NO;
          }] resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    header.backgroundColor = [UIColor colorWithRed:0.0667 green:0.478 blue:0.804 alpha:1];
    UILabel *dataLabel = [[UILabel alloc]initWithFrame:header.bounds];
    dataLabel.text = [WSDDataUtils dateStringBeforeDays:section];
    dataLabel.textColor = [UIColor whiteColor];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:dataLabel];
    
    return header;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *stories = self.data[section];
    return stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSDStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoryCell"
                                                         forIndexPath:indexPath];
    
    WSDStory *story = self.data[indexPath.section][indexPath.row];
    cell.label.text = story.title;
    [cell.label sizeToFit];
    [cell.righImageView sd_setImageWithURL:story.images[0]];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    CGFloat offsetY = offset.y;
    LxDBAnyVar(offsetY);
    
    if ([scrollView isEqual:self.tableView]) {
        if (offsetY > 0) {
            if (offsetY >= 90 * [self.data[0] count] + 200) {
                self.todayTitleLabel.hidden = YES;
                self.topView.hidden = YES;
            } else {
                self.todayTitleLabel.hidden = NO;
                
                if (!self.topView) {
                    self.topView =
                    [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
                    [self.homeView insertSubview:self.topView
                                    belowSubview:self.showSideMenuButton];
                }
                self.topView.hidden = NO;
                CGFloat alpha = offsetY / 64;
                self.topView.backgroundColor = [UIColor colorWithRed:0.0667 green:0.478 blue:0.804 alpha:alpha];
            }
            self.carouselViewTop.constant = -offsetY;
            
        } else {
            self.carouselViewHeight.constant = 220 - offsetY;
            if (offsetY <= -kRefreshOffsetY * 1.5) {
                self.tableView.contentOffset = CGPointMake(0, -kRefreshOffsetY * 1.5);
            } else if (offsetY <= 0 && offsetY >= -kRefreshOffsetY * 1.5) {
                if (self.isRefreshing) {
                    [self.refreshView updateProgress:0];
                } else {
                    [self.refreshView updateProgress:-offsetY / kRefreshOffsetY];
                }
            }
            if (offsetY < -kRefreshOffsetY && !scrollView.isDragging) {
                [self.refreshView startAnimation];
                self.isRefreshing = YES;
                dispatch_after(
                               dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                               dispatch_get_main_queue(), ^{
                                   [self.refreshView stopAnimation];
                                   self.isRefreshing = NO;
                               });
            }
        }
        [self.view layoutIfNeeded];
        // if scroll to bottom, then fetch the next day
        CGRect bounds = scrollView.bounds;
        CGSize contentSize = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = contentSize.height;
        float reload_distance = 10;
        if (y > h + reload_distance) {
            if (self.isLoading) {
                return;
            } else {
                [self fetchData];
            }
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)showSideMenu:(UIButton *)sender {
    [self.sideMenuVC.menuTableView reloadData];
    self.homeViewLeft.constant = 225;
    self.homeViewRight.constant = -225;
    [self.homeView setNeedsUpdateConstraints];
    [UIView animateWithDuration:kSideMenuAnimationDuration
                     animations:^{
                         self.sideMenuVC.view.left = 0;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         // setup transparent view for tapping to hide the side menu
                         self.tapView = [[UIView alloc] initWithFrame:self.homeView.bounds];
                         self.tapView.backgroundColor = [UIColor clearColor];
                         [self.tapView addGestureRecognizer:self.tapToHideSideMenu];
                         [self.homeView addSubview:self.tapView];
                         self.isShowSideMenu = YES;
                     }];
}

- (void)hideSideMenu {
    [UIView animateWithDuration:kSideMenuAnimationDuration
                     animations:^{
                         self.homeView.left = 0;
                         self.sideMenuVC.view.left = -255;
                     }
                     completion:^(BOOL finished) {
                         [self.tapView removeGestureRecognizer:self.tapToHideSideMenu];
                         [self.tapView removeFromSuperview];
                         self.isShowSideMenu = NO;
                     }];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    CGFloat offsetX = [recognizer translationInView:self.homeView].x;
    if (offsetX > 0 && offsetX < kSideMenuWidth) {
        self.sideMenuVC.view.right = offsetX;
        self.homeViewLeft.constant = offsetX;
        self.homeViewRight.constant = -offsetX;
        [self.homeView layoutIfNeeded];
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        if (offsetX >= kSideMenuWidth / 2) {
            [self showSideMenu:nil];
        } else {
            [self hideSideMenu];
        }
    }
}

@end
