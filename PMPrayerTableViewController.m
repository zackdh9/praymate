//
//  PMPrayerTableViewController.m
//  PrayMate
//
//  Created by zack on 10/2/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import "PMPrayerTableViewController.h"

@interface PMPrayerTableViewController ()

@end

@implementation PMPrayerTableViewController

-(void)unwindToPrayerTable:(UIStoryboardSegue *)segue
{
    
}
-(id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        self.className = @"Prayer";
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
