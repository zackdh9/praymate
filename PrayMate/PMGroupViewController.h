//
//  PMGroupViewController.h
//  PrayMate
//
//  Created by zack on 11/3/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrayerTableController.h"

@interface PMGroupViewController : UIViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

-(IBAction)unwindToGroups:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)addGroupButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)browseGroupButtonPressed:(UIBarButtonItem *)sender;
@property (strong, nonatomic)NSMutableArray *groupsArray;

@end
