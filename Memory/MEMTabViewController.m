//
//  MEMTabViewController.m
//  Memory
//
//  Created by owen on 2017/9/15.
//  Copyright © 2017年 owen. All rights reserved.
//

#import "MEMTabViewController.h"
#import "MEMPockerViewController.h"

@interface MEMTabViewController ()

@end

@implementation MEMTabViewController

- (instancetype)init {
    if (self = [super init]) {
        [self initViewControllers];
    }
    return self;
}

- (void)initViewControllers {
    MEMPockerViewController *vc = [[MEMPockerViewController alloc] init];
    self.viewControllers = @[vc];
    UITabBarItem *tab1 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:0];
    vc.tabBarItem = tab1;
    vc.tabBarItem.title = @"试试运气";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
