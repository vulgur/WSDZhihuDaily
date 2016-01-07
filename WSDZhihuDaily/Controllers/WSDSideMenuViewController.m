//
//  WSDSideMenuViewController.m
//  WSDZhihuDaily
//
//  Created by Wang Shudao on 1/3/16.
//  Copyright © 2016 WSD. All rights reserved.
//

#import "WSDSideMenuViewController.h"
#import "WSDSideMenuCell.h"

@interface WSDSideMenuViewController () <UITableViewDataSource>

@property (nonatomic, strong) NSArray *menuItems;

@end

@implementation WSDSideMenuViewController

static NSString *const kCellIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.menuTableView registerNib:[UINib nibWithNibName:@"WSDSideMenuCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.menuTableView.dataSource = self;
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:self.menuTableView.bounds];
    backgroundView.backgroundColor = [UIColor colorWithRed:0.106 green:0.125 blue:0.141 alpha:1];
    self.menuTableView.backgroundView = backgroundView;
    self.menuItems = @[@"首页",
                       @"日常心理学",
                       @"用户推荐日报",
                       @"电影日报",
                       @"不许无聊",
                       @"设计日报",
                       @"大公司日报",
                       @"财经日报",
                       @"互联网安全",
                       @"开始游戏",
                       @"音乐日报",
                       @"动漫日报",
                       @"体育日报"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSDSideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.menuTitle.text = self.menuItems[indexPath.row];
    return cell;
}
@end
