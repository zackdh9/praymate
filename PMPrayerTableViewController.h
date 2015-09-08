//
//  PMPrayerTableViewController.h
//  PrayMate
//
//  Created by zack on 10/2/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import <Parse/Parse.h>

@interface PMPrayerTableViewController : PFQueryTableViewController


-(IBAction)unwindToPrayerTable:(UIStoryboardSegue *)segue;


@end
