//
//  PMMyPrayersViewController.h
//  PrayMate
//
//  Created by zack on 10/19/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMMyPrayersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *commsArray;
@property (strong, nonatomic) UILabel * nothingLabel;


-(IBAction)unwindToNotifications:(UIStoryboardSegue *)segue;


@end
