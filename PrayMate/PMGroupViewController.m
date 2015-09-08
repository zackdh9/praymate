//
//  PMGroupViewController.m
//  PrayMate
//
//  Created by zack on 11/3/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import "PMGroupViewController.h"
#import "PrayerTableController.h"

@interface PMGroupViewController ()

@end

@implementation PMGroupViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"groupBoard"]) {
        
        
        NSIndexPath *ip = (NSIndexPath*)sender;
        
        PrayerTableController *vc = [segue destinationViewController];
        
        vc.currentGroup = _groupsArray[ip.row];
        
        
        
        
        
    }
}
-(IBAction)unwindToGroups:(UIStoryboardSegue *)segue{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _groupsArray = [NSMutableArray new];
    
    
    
    UITableViewController *tv = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tv];
    tv.refreshControl = [UIRefreshControl new];
    [tv.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    tv.tableView = _tableView;
    
    
    
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"Group"];
    NSArray *memberArray = [NSArray arrayWithObjects:[token singleton].tokenString, nil];
    [groupQuery whereKey:@"Members" containsAllObjectsInArray:memberArray];
    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"Loading Groups..." mode:MRProgressOverlayViewModeIndeterminate animated:YES];
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
        else{
            [self.groupsArray removeAllObjects];
            
            
            [self.groupsArray addObjectsFromArray:objects];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            [self.view setNeedsDisplay];
        }
    }];
    
    
    
    
    
    // Do any additional setup after loading the view.
    
}
-(void)refresh:(id)sender;
{
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"Group"];
    
    //[groupQuery includeKey:@"Members"];
    [groupQuery whereKey:@"Members" equalTo:[NSString stringWithFormat:@"%@",[token singleton].tokenString]];
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
        else{
            [self.groupsArray removeAllObjects];
            
            
            [self.groupsArray addObjectsFromArray:objects];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            [self.view setNeedsDisplay];        }
    }];
    [(UIRefreshControl *)sender endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row != _groupsArray.count) {
      static NSString *CellIdentifier = @"GroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        PFObject *group = [_groupsArray objectAtIndex:indexPath.row];
        UILabel *groupNameLabel= (UILabel *)[cell viewWithTag:1000];
        groupNameLabel.text = [group valueForKey:@"groupName"];
        NSArray *arr = [group objectForKey:@"Members"];
        UILabel *countLabel = (UILabel * )[cell viewWithTag:1001];
        countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)arr.count];
        if (arr.count ==1) {
            UILabel *memberLabel = (UILabel *)[cell viewWithTag:1006];
            memberLabel.text = @"member";
            memberLabel.textAlignment =NSTextAlignmentCenter;
        }
        
        
        return cell;
        
        
    }
    

    static NSString *CellIdentifier = @"findGroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return (_groupsArray.count +1);
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.row == _groupsArray.count) {
       return 110;
    }
    
    
    
    return 64;
    
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Delete the row from the data source
            PFObject *group = _groupsArray[indexPath.row];
            
            
            [_groupsArray removeObjectAtIndex:(indexPath.row)];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            NSMutableArray *arr = [group objectForKey:@"Members"];
            [arr removeObject:[token singleton].tokenString];
            [group setObject:arr forKey:@"Members"];
            
            
            [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"delete successful");
                }
                if (error) {
                    NSLog(@"error: %@", error.localizedDescription);
                }
            }];
            
        }
        else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }   
    }



}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _groupsArray.count) {
        return NO;
    }
    return YES;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row != _groupsArray.count) {
        
        
        UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
        PrayerTableController *vc = [[nav viewControllers] objectAtIndex:0];
        vc.groupsIsSender = YES;
      [self.tabBarController setSelectedViewController:[self.tabBarController.viewControllers objectAtIndex:0   ]];
        
   // [self performSegueWithIdentifier:@"groupBoard" sender:indexPath];
    }
    
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addGroupButtonPressed:(UIBarButtonItem *)sender {
}

- (IBAction)browseGroupButtonPressed:(UIBarButtonItem *)sender {
    
    
    
    
    
}
@end
