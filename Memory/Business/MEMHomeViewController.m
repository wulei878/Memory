//
//  MEMHomeViewController.m
//  Memory
//
//  Created by Owen on 2017/9/15.
//  Copyright © 2017年 owen. All rights reserved.
//

#import "MEMHomeViewController.h"
#import "UIView+ViewFrameGeometry.h"
#import "Memory-Swift.h"

@interface MEMHomeViewController ()
@property (nonatomic, strong) NSArray *destinations;
@property (nonatomic, strong) NSMutableArray *destArray;
@property (nonatomic, strong) UIImageView *mapView;
@end

@implementation MEMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我们的旅行";
    self.view.backgroundColor = [UIColor color:0xf6f6f6];
    UIImageView *mapView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map"]];
    mapView.size = self.view.size;
    mapView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:mapView];
    self.mapView = mapView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGSize originSize = CGSizeMake(610, 465);
    CGFloat widthScale = _mapView.size.width / originSize.width;
    CGFloat top = (_mapView.height - _mapView.width * (originSize.height / originSize.width)) / 2;
    _destArray = [NSMutableArray array];
    for (int i = 0; i < self.destinations.count; i++) {
        UIImageView *dest = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
        if (i == 0) {
            dest.origin = CGPointMake(445 * widthScale, 0);
        } else if (i == 1) {
            dest.origin = CGPointMake(454 * widthScale, 0);
        } else if (i == 2) {
            dest.origin = CGPointMake(475 * widthScale, 0);
        } else if (i == 3) {
            dest.origin = CGPointMake(502 * widthScale, 0);
        } else if (i == 4) {
            dest.origin = CGPointMake(272 * widthScale, 0);
        } else if (i == 5) {
            dest.origin = CGPointMake(20, 0);
        }
        [_destArray addObject:dest];
        [_mapView addSubview:dest];
    }
    for (int i = 0;i < _destArray.count;i++) {
        UIImageView *dest = _destArray[i];
        CGFloat dis = top - dest.height;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (i == 0) {
                dest.origin = CGPointMake(445 * widthScale, 175 * widthScale + dis);
            } else if (i == 1) {
                dest.origin = CGPointMake(454 * widthScale, 189 * widthScale + dis);
            } else if (i == 2) {
                dest.origin = CGPointMake(475 * widthScale, 275 * widthScale + dis);
            } else if (i == 3) {
                dest.origin = CGPointMake(502 * widthScale, 177 * widthScale + dis);
            } else if (i == 4) {
                dest.origin = CGPointMake(272 * widthScale, 377 * widthScale + dis);
            } else if (i == 5) {
                dest.origin = CGPointMake(20, _mapView.height - dest.height - 20 - top);
            }
        } completion:nil];
    }
}

- (NSArray *)destinations {
    return @[@"北京",@"天津",@"南京",@"大连",@"云南",@"马尔代夫"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
