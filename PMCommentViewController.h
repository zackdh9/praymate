//
//  PMCommentViewController.h
//  PrayMate
//
//  Created by zack on 10/19/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PMCommentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIActionSheetDelegate>
-(IBAction)unwindToCommentView:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) PFObject *prayer;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *commentViewContainer;
@property (weak, nonatomic) IBOutlet UILabel *prayerCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)flagPressed:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *sendSomeLove;
@property (strong, nonatomic) NSMutableArray *commentsArray;

@property(strong, nonatomic) UITextView *txtV;
@property(strong, nonatomic) UIButton *sendButt;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewConstraint;
@property (assign) BOOL notifyIsSender;
- (IBAction)handsButtonPressed:(id)sender;
- (IBAction)handsButtonUnressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *handsContainer;
@property (weak, nonatomic) IBOutlet UIButton *handsButton;
@property (strong, nonatomic) NSIndexPath *ip;
@property (assign) BOOL handsNeedHighlighting;
@property (assign) BOOL boardIsSender;
@property (strong, nonatomic) UIActionSheet *editActionSheet;

@end
