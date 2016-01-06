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

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property(weak, nonatomic) IBOutlet WSDCarouselView *carouselView;
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet WSDRefreshView *refreshView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *carouselViewTop;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *carouselViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *showSideMenuButton;
@property (weak, nonatomic) IBOutlet UIView *homeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeViewRight;


@property(nonatomic, strong) NSMutableArray *stories;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, assign) BOOL isRefreshing;
@property(nonatomic, assign) BOOL isShowSideMenu;
@property(nonatomic, strong) WSDSideMenuViewController *sideMenuVC;
@property(nonatomic, strong) UITapGestureRecognizer *tapToHideSideMenu;
@property(nonatomic, strong) UIView *tapView;

@end

@implementation HomeViewController

static CGFloat const kRefreshOffsetY = 40.f;
static CGFloat const kSideMenuAnimationDuration = 0.2f;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
//    [self.sideMenuVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view.mas_left);
//        make.top.equalTo(self.view.mas_top);
//        make.height.equalTo(self.view.mas_height);
//        make.width.equalTo(@225);
//    }];
    self.isShowSideMenu = NO;
    
    // setup story table view
    self.stories = [NSMutableArray new];
    [self.tableView registerNib:[UINib nibWithNibName:@"WSDStoryCell" bundle:nil]
         forCellReuseIdentifier:@"StoryCell"];
    
    // init the tap gesture for hiding the side menu
    self.tapToHideSideMenu = [[UITapGestureRecognizer alloc]
                              initWithTarget:self
                              action:@selector(hideSideMenu)];
    
    // fetch the daily stories
    NSURLSessionConfiguration *config =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    
    [[manager GET:@"http://news-at.zhihu.com/api/4/news/latest"
       parameters:nil
         progress:^(NSProgress *_Nonnull downloadProgress) {
             
         }
          success:^(NSURLSessionDataTask *_Nonnull task,
                    id _Nullable responseObject) {
              NSArray *topStoriesJSON = responseObject[@"top_stories"];
              NSArray *storiesJSON = responseObject[@"stories"];
              NSMutableArray *topStories = [NSMutableArray new];
              for (NSDictionary *json in topStoriesJSON) {
                  WSDTopStory *ts = [[WSDTopStory alloc] initWithJSON:json];
                  [topStories addObject:ts];
              }
              
              for (NSDictionary *json in storiesJSON) {
                  WSDStory *story = [[WSDStory alloc] initWithJSON:json];
                  [self.stories addObject:story];
              }
              
              [self.carouselView setTopStories:topStories];
              [self.tableView reloadData];
              
          }
          failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error){
          }] resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSDStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoryCell"
                                                         forIndexPath:indexPath];
    
    WSDStory *story = self.stories[indexPath.row];
    cell.label.text = story.title;
    [cell.label sizeToFit];
    [cell.righImageView sd_setImageWithURL:story.images[0]];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tableView]) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > 0) {
            if (!self.topView) {
                self.topView =
                [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
                [self.homeView insertSubview:self.topView belowSubview:self.showSideMenuButton];
            }
            CGFloat alpha = offsetY / 64;
            self.topView.backgroundColor = [UIColor colorWithRed:60.f / 255.f
                                                           green:198.f / 255.f
                                                            blue:253.f / 255.f
                                                           alpha:alpha];
            
            CGFloat carouselViewOffsetY = -offsetY;
            self.carouselViewTop.constant = carouselViewOffsetY;
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
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)showSideMenu:(UIButton *)sender {
    [self.sideMenuVC.menuTableView reloadData];
    self.homeViewLeft.constant = 225;
    self.homeViewRight.constant -= 225;
    [self.homeView setNeedsUpdateConstraints];
    [UIView animateWithDuration:kSideMenuAnimationDuration
                     animations:^{
                         self.sideMenuVC.view.left = 0;
//                         self.homeView.left = 225;
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

@end
