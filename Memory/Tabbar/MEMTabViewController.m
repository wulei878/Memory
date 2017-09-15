//
//  MEMTabViewController.m
//  Memory
//
//  Created by owen on 2017/9/15.
//  Copyright © 2017年 owen. All rights reserved.
//

#import "MEMTabViewController.h"
#import "MEMPokerViewController.h"
#import "MEMHomeViewController.h"

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

    MEMHomeViewController *home = [[MEMHomeViewController alloc] init];
    MEMPokerViewController *poker = [[MEMPokerViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:home];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:poker];
    self.viewControllers = @[nav1,nav2];
    UITabBarItem *tab1 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:0];
    nav1.tabBarItem = tab1;
    UITabBarItem *tab2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:1];
    nav2.tabBarItem = tab2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
