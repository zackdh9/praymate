//
//  PMUITabBarControllerViewController.m
//  PrayMate
//
//  Created by zack on 3/26/15.
//  Copyright (c) 2015 zachary hamblen. All rights reserved.
//

#import "PMUITabBarControllerViewController.h"
#import "PMPersistentTabBorder.h"
#import "PMAppDelegate.h"
@interface PMUITabBarControllerViewController ()

@end

@implementation PMUITabBarControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PMPersistentTabBorder *blueBar = [[PMPersistentTabBorder alloc ] initWithFrame:CGRectMake(0, self.tabBarController.tabBar.frame.origin.y, 320, 1)];
    [blueBar setBackgroundColor:[PMAppDelegate navyColor]];
    
    
    [self.view addSubview:blueBar];
    [self.view bringSubviewToFront:blueBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
