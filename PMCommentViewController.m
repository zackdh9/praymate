//
//  PMCommentViewController.m
//  PrayMate
//
//  Created by zack on 10/19/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import "PMCommentViewController.h"
#import "PrayerTableController.h"
#import "PMEditPrayerViewController.h"

@interface PMCommentViewController ()

@end

@implementation PMCommentViewController

-(void)unwindToCommentView:(UIStoryboardSegue *)segue
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    [self.view endEditing:YES];
    if ([segue.identifier isEqualToString:@"editSegue"]) {
        PMEditPrayerViewController *vc = (PMEditPrayerViewController*)[segue destinationViewController];
        vc.prayer = _prayer;
        vc.textView.text = [_prayer objectForKey:@"Title"];
    }
    if (_boardIsSender == YES) {
        if (_handsNeedHighlighting ==YES) {
            
        
        PrayerTableController *vc = [segue destinationViewController];
        [vc.currentButton setHidden:YES];
        vc.currentLabel.text = [NSString stringWithFormat:@"%d",([vc.currentLabel.text integerValue] +1)];
        
        }
        
    }
    if (sender == _editActionSheet) {
        PrayerTableController *vc = (PrayerTableController*)[segue destinationViewController];
        [vc.prayers removeObjectIdenticalTo:_prayer];
        [vc.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _textView.delegate = self;
    _txtV.delegate = self;
    _handsContainer.layer.cornerRadius = 5;
    _handsContainer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _handsContainer.layer.borderWidth = 3;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    UIView *inputView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    _txtV = [[UITextView alloc] initWithFrame:CGRectMake(8, 8, 234, 36)];
    [_txtV setBackgroundColor:[UIColor whiteColor]];
    [_txtV setFont:[UIFont systemFontOfSize:14]];
    [_txtV setText:@""];
    _sendButt = [[UIButton alloc] initWithFrame:CGRectMake(250, 8, 62, 36)];
    [_sendButt setTitle:@"Send" forState:UIControlStateNormal];
    _sendButt.titleLabel.font = [UIFont systemFontOfSize:21];
    [_sendButt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendButt setBackgroundColor:[UIColor colorWithRed:1 green:120.0/255.0 blue:38.0/255.0 alpha:1]];
    [_sendButt addTarget:self action:@selector(sendButtPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [inputView addSubview:_sendButt];
    [inputView addSubview:_txtV];
    
    
    
    
    [inputView setBackgroundColor:[UIColor colorWithRed:1 green:173.0/255.0 blue:28.0/255.0 alpha:1]];
    
    _textView.inputAccessoryView = inputView;    // Do any additional setup after loading the view.
    
    NSArray *prayedArr = [_prayer objectForKey:@"Prayed"];
    if ([prayedArr containsObject:[token singleton].tokenString]) {
        [_handsButton setHidden:YES];
        _handsContainer.layer.borderColor = [UIColor colorWithRed:1 green:173.0/255.0 blue:28.0/255.0 alpha:1].CGColor;
    }
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    
}
-(void)flagPressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Flag as Innapropriate" otherButtonTitles:nil];
    [actionSheet showFromBarButtonItem:sender animated:YES];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == _editActionSheet) {
        if (buttonIndex == _editActionSheet.destructiveButtonIndex) {
            [_prayer deleteInBackground];
            [self performSegueWithIdentifier:@"unwindToPrayerTable" sender:_editActionSheet];
        }
        else if (buttonIndex == _editActionSheet.cancelButtonIndex) {
            return;
        }
        else
        {
           [self performSegueWithIdentifier:@"editSegue" sender:self];
        }
        
    }
    
    
    
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        NSNumber *num = (NSNumber *)   [_prayer objectForKey:@"flags"];
        NSNumber *numB = [NSNumber numberWithInt:[num intValue] +1];
        [_prayer setObject:numB forKey:@"flags"];
        [_prayer saveInBackground];
    }
}
-(void)editButtonPressed:(id)sender{
    
    _editActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Prayer" otherButtonTitles:@"Edit Prayer", nil];
    _editActionSheet.delegate = self;
    [_editActionSheet showFromBarButtonItem:sender animated:YES];
    
    
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    self.view.tintColor = [UIColor whiteColor];
    PFUser * owner = (PFUser*)[_prayer objectForKey:@"Owner"];
    if ([owner.objectId isEqualToString: [PFUser currentUser].objectId]) {
        
        UIBarButtonItem * EditButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed:)];
        self.navigationItem.rightBarButtonItem = EditButton;
        
        
        
        
    }
    
    
    _titleLabel.text = [_prayer valueForKey:@"Title"];
    _prayerCountLabel.text = [[_prayer valueForKey:@"PrayerCount"] stringValue];
    NSDate *createdDate = _prayer.createdAt;
    double ti = [createdDate timeIntervalSinceDate:[NSDate date]];
    ti = ti * -1;
    if (ti <3600) {
        int diff = round(ti / 60);
        _timeLabel.text = [NSString stringWithFormat:@"α %dm", diff];
        
    }
    else if (ti <86400) {
        int diff = round(ti / 60 / 60);
        _timeLabel.text = [NSString stringWithFormat:@"α %dh", diff];
        
    }
    else if (ti <2629743) {
        int diff = round(ti / 60 /60 /24);
        _timeLabel.text = [NSString stringWithFormat:@"α %dd", diff];
        
    }
    //
    if ([_prayer objectForKey:@"hasGroup"] == [NSNumber numberWithBool:YES]) {
        UILabel * groupLabel = (UILabel*)[self.view viewWithTag:405];
        groupLabel.text = [[_prayer objectForKey:@"Group"] objectForKey:@"groupName"];
        
    }
    
    NSArray *arr = [_prayer objectForKey:@"Comments"];
    _commentsArray = [[NSMutableArray alloc] initWithArray:arr];
    
    [_tableView reloadData];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (_commentsArray.count ==0) {
        return 1;
    }
    
    return _commentsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_commentsArray.count == 0) {
       static NSString *cellIdentifier = @"noCommentCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell; 
    }
    
    else
    {
        static NSString *cellIdentifier = @"commentCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
      
        
            
        
        NSString *comment = _commentsArray[indexPath.row];
        UILabel *commentLabel = (UILabel *)[cell viewWithTag:778];
            commentLabel.text = comment;
        
      //  UILabel *timeLabel = (UILabel *)[cell viewWithTag:779];
            
    
        return cell;
    
    }
    
}


- (IBAction)dbPressed:(UIBarButtonItem *)sender {
    
   
}
- (void)sendButtPressed:(UIButton *)sender {
    
    if (_txtV.text.length >0) {
       
        _tableviewConstraint.constant = 0.f;
        //[_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height + 60)];
        //[_tableView setContentInset:UIEdgeInsetsMake(0, 0, 100, 0)];
        [self.view setNeedsDisplay];
        NSString *comment = _txtV.text;
        
        PFObject * comm = [PFObject objectWithClassName:@"Comm"];
        comm [@"Recipient"] =  [_prayer objectForKey:@"Owner"];
        comm [@"prayerObjectID"] = _prayer.objectId;
       comm[@"Content"] = comment;
        [comm setObject:_prayer forKey:@"Prayer"];
        
        
    //    [_commentsArray addObject:comm];
      
        
        
        
        [comm saveInBackground];
        
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"user" equalTo:[_prayer objectForKey:@"Owner"]];
        
        NSString *message = [NSString stringWithFormat:@"Someone replied to your prayer request."];
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:pushQuery];
        [push setMessage:message];
        [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                
            }
        }];
        
        
        [_commentsArray addObject:comment];
        [_prayer setObject:_commentsArray forKey:@"Comments"];
        [_prayer saveInBackground];
        [_tableView reloadData];
        UIImageView *dogView = [[UIImageView alloc] initWithFrame:CGRectMake(262, 253, 30, 35)];
        dogView.image = [UIImage imageNamed:@"angeldog"];
        [self.view addSubview:dogView];
        [UIView transitionWithView:dogView duration:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            dogView.transform = CGAffineTransformScale(dogView.transform, 1.2   , 1.2);
            dogView.frame = CGRectOffset(dogView.frame, -40, -700);
            
        } completion:^(BOOL finished) {
            
        }];
        [self.view bringSubviewToFront:dogView];
        //[UIView transitionWithView:dogView duration:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
       //     dogView.transform = CGAffineTransformScale(dogView.transform, 1.2   , 1.2);
        //    dogView.frame = CGRectOffset(dogView.frame, -40, -700);
            
       // } completion:^(BOOL finished) {
            
       // }];
        [_txtV setText:@""];
        [self.view endEditing:YES];
        [_txtV resignFirstResponder];
    }
    
[_txtV resignFirstResponder];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
    



-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
  /*  if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [UIView animateWithDuration:0.1f animations:^{
            
            
            
            _commentViewContainer.frame = CGRectOffset(_commentViewContainer.frame, 0, -216);
        } completion:^(BOOL finished) {
            
        }];    }
    else {
        
        [UIView animateWithDuration:0.1f animations:^{
            
            
            
            _commentViewContainer.frame = CGRectOffset(_commentViewContainer.frame, 0, -246);
        } completion:^(BOOL finished) {
            
        }];
        
    }  */  return YES;
    
   
    
    
    
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
   /* if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [UIView animateWithDuration:0.1f animations:^{
            _commentViewContainer.frame = CGRectOffset(_commentViewContainer.frame, 0, +216);
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.1f animations:^{
            
            
            
            _commentViewContainer.frame = CGRectOffset(_commentViewContainer.frame, 0, +246);
        } completion:^(BOOL finished) {
            
        }];
    } */
    return YES;
}
-(void)keyboardDidHide:(NSNotification *)notification{
   }


-(void)keyboardDidShow:(NSNotification*)notification{
    [_sendSomeLove setHidden:YES];
    [_textView resignFirstResponder];
    [_txtV becomeFirstResponder];
    [_commentViewContainer setHidden:YES];
    
    
    [self.view setNeedsDisplay];
        
        
}

  
-(void)handsButtonPressed:(id)sender
{
    
    _handsButton.hidden = YES;
    _handsNeedHighlighting = YES;
    _handsContainer.layer.borderColor = [UIColor colorWithRed:1 green:173.0/255.0 blue:28.0/255.0 alpha:1].CGColor;
    
    
    
    
        
       
        
        UIImageView *dogView = [[UIImageView alloc] initWithFrame:CGRectMake(_handsButton.frame.origin.x, _handsButton.frame.origin.y, 30, 35)];
        dogView.image = [UIImage imageNamed:@"angeldog"];
        [self.view addSubview:dogView];
        [UIView transitionWithView:dogView duration:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            dogView.transform = CGAffineTransformScale(dogView.transform, 1.2   , 1.2);
            dogView.frame = CGRectMake(dogView.frame.origin.x - 30, -300, dogView.frame.size.width, dogView.frame.size.height);
            
        } completion:^(BOOL finished) {
            [dogView removeFromSuperview];
            
        }];
        PFObject *prayer = _prayer;
        NSNumber *prayerCount = [prayer objectForKey:@"PrayerCount"];
       
        
        
        
        PFObject *comm = [PFObject objectWithClassName:@"Comm"];
        comm [@"Recipient"] = [prayer objectForKey:@"Owner"];
        comm [@"Type"] = @"prayer";
        int randomInt = arc4random() %20;
        if (randomInt == 0) {
            comm [@"Content"] = @"A thoughtful person prayed for you.";
        }
        else if (randomInt == 1)
        {
            comm [@"Content"] = @"You've got prayers on deck.";
        }
        else if (randomInt == 2)
        {
            comm [@"Content"] = @"Somebody prayed your intention.";
        }
        else if (randomInt == 3)
        {
            comm [@"Content"] = @"+1 prayer, woo!";
        }
        else if (randomInt == 4)
        {
            comm [@"Content"] = @"A prayer warrior is gearing up.";
        }
        else if (randomInt == 5)
        {
            comm [@"Content"] = @"Houston, a prayer has launched.";
        }
        else if (randomInt == 6)
        {
            comm [@"Content"] = @"A little prayer is on the way.";
        }
        else if (randomInt == 7)
        {
            comm [@"Content"] = @"Fear not, someone's praying.";
        }
        else if (randomInt == 8)
        {
            comm [@"Content"] = @"You've got a friend in prayer.";
        }
        else if (randomInt == 9)
        {
            comm [@"Content"] = @"You're in someone's prayers.";
        }
        else if (randomInt == 10)
        {
            comm [@"Content"] = @"One prayer skyward for you.";
        }
        else if (randomInt == 11)
        {
            comm [@"Content"] = @"Someone unleased a Prayer Puppy.";
        }
        else if (randomInt == 12)
        {
            comm [@"Content"] = @"Be not afraid, people are praying.";
        }
        else if (randomInt == 13)
        {
            comm [@"Content"] = @"Take confidence, a friend is praying.";
        }
        else if (randomInt == 14)
        {
            comm [@"Content"] = @"Rest knowing that someone prayed.";
        }
        else if (randomInt == 15)
        {
            comm [@"Content"] = @"A friend prayed.";
        }
        else if (randomInt == 16)
        {
            comm [@"Content"] = @"Hands are coming together for you.";
        }
        else if (randomInt == 17)
        {
            comm [@"Content"] = @"Sing for joy, a prayer just for you!";
        }
        else if (randomInt == 18)
        {
            comm [@"Content"] = @"One prayer for you.";
        }
        else if (randomInt == 19)
        {
            
            comm [@"Content"] = @"Mad prayers your way, bro.";
            
        }
        
        
        
        
        
        
        comm [@"Sender"] = [token singleton].tokenString;
        [comm setObject:prayer forKey:@"Prayer"];
        [comm saveInBackground];
        
        
        
        NSNumber *newCount = [NSNumber numberWithInt:((int)[prayerCount integerValue] + 1)];
        _prayerCountLabel.text = [newCount stringValue];
        prayer[@"PrayerCount"] = newCount;
        
        [prayer addObject:[token singleton].tokenString forKey:@"Prayed"];
        [prayer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error){
                // NSLog(@"%@",error.localizedDescription);
            }
            else
            {
                
                [self.view setNeedsDisplay];
                
                
                if ([newCount integerValue] ==1) {
                    PFQuery *pushQuery = [PFInstallation query];
                    [pushQuery whereKey:@"user" equalTo:[prayer objectForKey:@"Owner"]];
                    
                    NSString *message = [NSString stringWithFormat:@"Someone is praying for you."];
                    PFPush *push = [[PFPush alloc] init];
                    [push setQuery:pushQuery];
                    [push setMessage:message];
                    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (error) {
                            NSLog(@"%@", error.localizedDescription);
                            
                        }
                    }];
                    
                }
                else if ([newCount integerValue] ==5) {
                    PFQuery *pushQuery = [PFInstallation query];
                    [pushQuery whereKey:@"user" equalTo:[prayer objectForKey:@"Owner"]];
                    
                    NSString *message = [NSString stringWithFormat:@"%@ praymates are praying for you.", [newCount stringValue]];
                    
                    PFPush *push = [[PFPush alloc] init];
                    [push setQuery:pushQuery];
                    [push setMessage:message];
                    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (error) {
                            NSLog(@"%@", error.localizedDescription);
                            
                        }
                    }];
                    
                }
                else if ([newCount integerValue] ==10) {
                    PFQuery *pushQuery = [PFInstallation query];
                    [pushQuery whereKey:@"user" equalTo:[prayer objectForKey:@"Owner"]];
                    
                    NSString *message = [NSString stringWithFormat:@"%@ buddies are praying for you.", [newCount stringValue]];
                    
                    PFPush *push = [[PFPush alloc] init];
                    [push setQuery:pushQuery];
                    [push setMessage:message];
                    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (error) {
                            NSLog(@"%@", error.localizedDescription);
                            
                        }
                    }];
                    
                }
                else if ([newCount integerValue] ==15)
                {
                    PFQuery *pushQuery = [PFInstallation query];
                    [pushQuery whereKey:@"user" equalTo:[prayer objectForKey:@"Owner"]];
                    
                    NSString *message = [NSString stringWithFormat:@"%@ people are praying for you.", [newCount stringValue]];
                    
                    PFPush *push = [[PFPush alloc] init];
                    [push setQuery:pushQuery];
                    [push setMessage:message];
                    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (error) {
                            NSLog(@"%@", error.localizedDescription);
                            
                        }
                    }];
                    
                }
                else if ([newCount integerValue] ==20) {
                    PFQuery *pushQuery = [PFInstallation query];
                    [pushQuery whereKey:@"user" equalTo:[prayer objectForKey:@"Owner"]];
                    
                    NSString *message = [NSString stringWithFormat:@"%@ people are praying for you.", [newCount stringValue]];
                    
                    PFPush *push = [[PFPush alloc] init];
                    [push setQuery:pushQuery];
                    [push setMessage:message];
                    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (error) {
                            NSLog(@"%@", error.localizedDescription);
                            
                        }
                    }];
                    
                }
                
                
                
                
                
                
            }
        }];
        
    }


-(void)handsButtonUnressed:(id)sender
{
    _handsButton.hidden = NO;
    _handsNeedHighlighting = NO;
    _handsContainer.layer.borderColor = [UIColor  lightGrayColor].CGColor;
    
    
    
    
        //[(UIButton *)sender setHidden:YES];
    
        
        PFObject *prayer = _prayer;
        NSNumber *prayerCount = [prayer objectForKey:@"PrayerCount"];
        
        NSNumber *newCount = [NSNumber numberWithInt:((int)[prayerCount integerValue] -1)];
         _prayerCountLabel.text = [newCount stringValue];
        prayer[@"PrayerCount"] = newCount;
        
        
        [prayer removeObject:[token singleton].tokenString forKey:@"Prayed"];
        
        
        [prayer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error){
                //  NSLog(@"%@",error.localizedDescription);
            }
            else
            {
                
            }
        }];
        // UIButton *newButt = (UIButton *)[[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:4];
        
        
        // [[self.tableView cellForRowAtIndexPath:indexPath] addSubview:newButt];
        
    
                [self.view setNeedsDisplay];
        
    }






@end
