//
//  PMFindGroupsViewController.h
//  PrayMate
//
//  Created by zack on 11/3/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMFindGroupsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UITextFieldDelegate>





@property (strong, nonatomic)NSMutableArray *groupsArray;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) PFObject *currentGroup;
- (IBAction)doneButtPressed:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *pinView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pinConstraint;

- (IBAction)cancelButtonPressed:(id)sender;
@property (assign) BOOL pinVisible;
@property (weak, nonatomic) IBOutlet UITextField *pinField;

@end
