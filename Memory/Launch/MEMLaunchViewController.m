//
//  ViewController.m
//  Memory
//
//  Created by owen on 2017/9/14.
//  Copyright © 2017年 owen. All rights reserved.
//

#import "MEMLaunchViewController.h"
#import <Lottie/Lottie.h>
#import <Masonry/Masonry.h>
#import "Memory-Swift.h"
#import "MEMTabViewController.h"

static const NSInteger MEMShowDuration = 3;
@interface MEMLaunchViewController ()
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation MEMLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor color:0x7FFFD4];
    NSArray *titleArray = @[@"M",@"E",@"M",@"O",@"R",@"Y"];
    NSArray *subTitleArray = @[@"F",@"O",@"R"];
    NSArray *nameArray = @[@"X",@"I",@"A",@"L",@"E",@"I"];
    NSArray *totalArray = @[titleArray,subTitleArray,nameArray];
    NSMutableArray *animationArray = [NSMutableArray array];
    for (int i = 0 ; i < totalArray.count; i++) {
        NSArray *array = totalArray[i];
        NSMutableArray <LOTAnimationView *> *animations = [NSMutableArray array];
        for (int j = 0 ; j < array.count; j++) {
            NSString *name = array[j];
            LOTAnimationView *animation = [LOTAnimationView animationNamed:name];
            [self.view addSubview:animation];
            CGFloat width;
            if (i > 0) {
                width = 30;
            } else {
                width = (j + 1) % 2 * 20 + 50;
            }

            [animation mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(animation.mas_width).multipliedBy(1);
                make.centerY.mas_equalTo(self.view).offset(-50 + i * 50);
            }];
            [animations addObject:animation];
        }
        for (int k = 0 ; k < animations.count; k++) {
            LOTAnimationView *animation = animations[k];
            if (k > 0) {
                LOTAnimationView *preAnimation = animations[k - 1];
                [animation mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(preAnimation.mas_right);
                }];
            } else {
                [animation mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                }];
            }
        }
        [animationArray addObject:animations];
    }
    for (NSArray *animations in animationArray) {
        for (LOTAnimationView *ani in animations) {
            [ani playWithCompletion:^(BOOL animationFinished) {
            }];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, MEMShowDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

- (void)dismiss {
    [UIApplication sharedApplication].keyWindow.rootViewController = [[MEMTabViewController alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
