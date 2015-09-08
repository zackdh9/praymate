//
//  PMFindGroupsViewController.m
//  PrayMate
//
//  Created by zack on 11/3/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import "PMFindGroupsViewController.h"

@interface PMFindGroupsViewController ()

@end

@implementation PMFindGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _pinField.delegate = self;
    
    
    _groupsArray = [NSMutableArray new];
    
    
    UITableViewController *tv = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tv];
    tv.refreshControl = [UIRefreshControl new];
    [tv.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    tv.tableView = _tableView;
    
    
    
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"Group"];
    //[groupQuery includeKey:@"Members"];
    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"Searching for Groups..." mode:MRProgressOverlayViewModeIndeterminate animated:YES];
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
        else{
            [self.groupsArray removeAllObjects];
            
            
            [self.groupsArray addObjectsFromArray:objects];
            
            int i;
            for (i= 0; i < [_groupsArray count] ; i++) {
                PFObject *group = [_groupsArray objectAtIndex:i];
                NSMutableArray *arr = [group objectForKey:@"Members"];
                if ([arr containsObject:[token singleton].tokenString]) {
                    [_groupsArray removeObject:group];
                }
                
                
            }
            
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            [self.view setNeedsDisplay];
        }
    }];
    
    
    // Do any additional setup after loading the view.
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 4)
    
    
    { if([string isEqualToString:@""])
    {
        return YES;
        
    }
    else
    {
        
        return NO;
    }
        
        
        
        
        
        
           }
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_pinField.text.length ==4) {
        [self checkPin];
    }
}
-(void)checkPin
{
     [_pinField resignFirstResponder];
    
    
    NSString *pinString = [_currentGroup valueForKey:@"Pin"];
     
     
     
     if ([_pinField.text isEqualToString:pinString]) {
            UIActionSheet *actionSheet =[[ UIActionSheet alloc] initWithTitle:@"Join this group?" delegate:self cancelButtonTitle:@"Nevermind." destructiveButtonTitle:nil otherButtonTitles:@"Yes, of course!", nil];
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
            
        }
                                            else
                                            {
                                             _pinField.text =@"";
                                                UIAlertView *alert = [[UIAlertView alloc]   initWithTitle:@"Pin entered incorrectly." message:@"Please try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                                                [alert show];
                                            }

}
-(void)refresh:(id)sender;
{
    
    
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"Group"];
    //[groupQuery includeKey:@"Members"];
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
        else{
            [self.groupsArray removeAllObjects];
            
            
            [self.groupsArray addObjectsFromArray:objects];
            
            int i;
            for (i= 0; i < [_groupsArray count] ; i++) {
                PFObject *group = [_groupsArray objectAtIndex:i];
                NSMutableArray *arr = [group objectForKey:@"Members"];
                if ([arr containsObject:[token singleton].tokenString]) {
                    [_groupsArray removeObject:group];
                }
                
                
            }
            
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            [self.view setNeedsDisplay];
        }
    }];

    [(UIRefreshControl *)sender endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (_groupsArray.count >0) {
        static NSString *CellIdentifier = @"GroupCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        PFObject *group = [_groupsArray objectAtIndex:indexPath.row];
        UILabel *groupNameLabel= (UILabel *)[cell viewWithTag:1002];
        groupNameLabel.text = [group valueForKey:@"groupName"];
        NSArray *arr = [group objectForKey:@"Members"];
        UILabel *countLabel = (UILabel * )[cell viewWithTag:1003];
        countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)arr.count];
        if (arr.count ==1) {
            UILabel *memberLabel = (UILabel *)[cell viewWithTag:1005];
            memberLabel.text = @"member";
            memberLabel.textAlignment =NSTextAlignmentCenter;
        }
        
        
        
        return cell;
        
        
    }
    
    
    static NSString *CellIdentifier = @"noGroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (_groupsArray.count > 0) {
        return _groupsArray.count;
    }
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_groupsArray.count > 0) {
        return 64;
    }
    return 300;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _currentGroup = _groupsArray[indexPath.row];
    if ([[_groupsArray[indexPath.row] valueForKey:@"Pin"] isEqualToString:@"1111"]) {
        UIActionSheet *actionSheet =[[ UIActionSheet alloc] initWithTitle:@"Join this group?" delegate:self cancelButtonTitle:@"Nevermind." destructiveButtonTitle:nil otherButtonTitles:@"Yes, of course!", nil];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        
        
    }
    else
    {
        
        if (_pinVisible ==NO) {
            _pinConstraint.constant = 84;
            [_pinView setNeedsUpdateConstraints];
            [_pinField becomeFirstResponder];
            
            
            [UIView animateWithDuration:.8 animations:^{
                
                [_pinView layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                _pinVisible = YES;
            }];
        
        }
        
        
        
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        NSMutableArray *arr = [_currentGroup objectForKey:@"Members"];
        [arr addObject:[token singleton].tokenString];
        [_currentGroup setObject:arr forKey:@"Members"];
        [_currentGroup saveInBackground];
        [self performSegueWithIdentifier:@"toGroups" sender:self];
    }
}






- (IBAction)cancelButtonPressed:(id)sender {
    [_pinField resignFirstResponder];
    
    if (_pinVisible ==YES) {
        _pinConstraint.constant = -100;
        [_pinView setNeedsUpdateConstraints];
        
        
        
        [UIView animateWithDuration:.8 animations:^{
            
            [_pinView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            _pinVisible = NO;
        }];
    
    }
    
    
    
    
    
    
}

- (IBAction)doneButtPressed:(id)sender {
    
    [_pinField resignFirstResponder];
    
    if (_pinVisible ==YES) {
        _pinConstraint.constant = -100;
        [_pinView setNeedsUpdateConstraints];
        
        
        
        [UIView animateWithDuration:.8 animations:^{
            
            [_pinView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            _pinVisible = NO;
        }];
        
    }
}
@end
