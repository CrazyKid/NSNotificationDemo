//
//  ViewController.m
//  NotificationDemo
//
//  Created by jjyy on 16/8/26.
//  Copyright © 2016年 Arthur. All rights reserved.
//

#import "ViewController.h"

#define kTestNotificationName @"kTestNotificationName"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAnimation) name:kTestNotificationName object:nil];
    //
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    //
    [[NSNotificationCenter defaultCenter] addObserverForName:kTestNotificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self showAnimation];
    }];
}
- (void)btnAction {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"post notification thread :%@",[NSThread currentThread]);
        [[NSNotificationCenter defaultCenter] postNotificationName:kTestNotificationName object:nil];
    });
}

- (void)showAnimation {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"callback thread:%@",[NSThread currentThread]);
        [self.view addSubview:[[UIView alloc] init]];
    });
    
    /**
     *  log
     *  post notification thread :<NSThread: 0x7fda72403400>{number = 3, name = (null)}
     *  callback thread:<NSThread: 0x7fda72403400>{number = 3, name = (null)}
     *
     *  This application is modifying the autolayout engine from a background thread, which can lead to engine corruption and weird crashes.
     *  This will cause an exception in a future release.
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
