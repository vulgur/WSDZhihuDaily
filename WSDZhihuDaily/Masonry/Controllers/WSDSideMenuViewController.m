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

-(void)viewWillAppear:(BOOL)animated {
    LxPrintAnything(will appear);
    [super viewWillAppear:animated];
    LxDBAnyVar(self.menuTableView.contentSize);
}

-(void)viewDidAppear:(BOOL)animated {
    LxPrintAnything(did appear);
    [super viewDidAppear:animated];
    LxDBAnyVar(self.menuTableView.contentSize);
    
}

//-(void)viewWillLayoutSubviews {
//    LxPrintAnything(will layout);
////    [super viewWillLayoutSubviews];
//    self.menuTableView.contentSize = CGSizeMake(self.view.width, kScreenHeight-20-55-50-50);
//    LxDBAnyVar(self.menuTableView.contentSize);
//}
//
//-(void)viewDidLayoutSubviews {
////    [super viewDidLayoutSubviews];
//    LxPrintAnything(did layout);
//    self.menuTableView.contentSize = CGSizeMake(self.view.width, kScreenHeight-20-55-50-50);
//    LxDBAnyVar(self.menuTableView.contentSize);
//}

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
