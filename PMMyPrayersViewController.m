//
//  PMMyPrayersViewController.m
//  PrayMate
//
//  Created by zack on 10/19/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import "PMMyPrayersViewController.h"
#import "PMCommentViewController.h"
@interface PMMyPrayersViewController ()

@end

@implementation PMMyPrayersViewController
@synthesize nothingLabel;


-(void)unwindToNotifications:(UIStoryboardSegue *)segue
{
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toDeets"]) {
        
        
        NSIndexPath *indexPath = sender;
        
        PMCommentViewController *vc =[segue destinationViewController];
 
        
        vc.prayer = [[_commsArray objectAtIndex:indexPath.row] objectForKey:@"Prayer"];
    
    
    
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource= self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    nothingLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 220, 80)];
    [nothingLabel setText:@"Nothing here yet"];
    [nothingLabel setTextAlignment:NSTextAlignmentCenter];
    [nothingLabel setTextColor:[UIColor lightGrayColor]];
    nothingLabel.font = [UIFont systemFontOfSize:20];
    
    UITableViewController *tv = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tv];
    tv.refreshControl = [UIRefreshControl new];
    [tv.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    tv.tableView = _tableView;
    
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Comm"];
    
    [query whereKey:@"Recipient" equalTo:[PFUser currentUser]];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"Prayer"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            //NSLog(@"%@", error.localizedDescription);
        }
        else{
            
            _commsArray = [[NSMutableArray alloc] initWithArray:objects];
            
            if (_commsArray.count > 0) {
                
                
                
                [nothingLabel setHidden:YES];
                
            }
            
            
            [self.tableView reloadData];
            
            
        }
    }];
    
    
    
    
    
    [self.tableView addSubview:nothingLabel];
    
    // Do any additional setup after loading the view.
}
-(void)refresh:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"Comm"];
    
    [query whereKey:@"Recipient" equalTo:[PFUser currentUser]];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"Prayer"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            //NSLog(@"%@", error.localizedDescription);
        }
        else{
            
            _commsArray = [[NSMutableArray alloc] initWithArray:objects];
            
            if (_commsArray.count > 0) {
                
                
                
                [nothingLabel setHidden:YES];
                
            }
            
            
            [self.tableView reloadData];
            [self.view setNeedsDisplay];
            
        }
    }];
    
    
    [(UIRefreshControl *)sender endRefreshing];
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [self performSegueWithIdentifier:@"toDeets" sender:indexPath];
[tableView deselectRowAtIndexPath:indexPath animated:YES];}
-(void)viewDidAppear:(BOOL)animated
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return _commsArray.count;
}
-(CGFloat   )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject * obj = _commsArray[indexPath.row];
    if ([[obj valueForKey:@"Type"] isEqualToString:@"prayer"]) {
     static NSString *CellIdentifier = @"prayedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UILabel *durationLabel = (UILabel *)[cell viewWithTag:778];
        
        
        UILabel * prayerLabel = (UILabel * )[cell viewWithTag:111];
        prayerLabel.text = [obj valueForKey:@"Content"];
        
        NSDate *createdDate = obj.createdAt;
        double ti = [createdDate timeIntervalSinceDate:[NSDate date]];
        ti = ti * -1;
        if (ti <3600) {
            int diff = round(ti / 60);
            durationLabel.text = [NSString stringWithFormat:@"%d minutes ago", diff];
            
        }
        else if (ti <86400) {
            int diff = round(ti / 60 / 60);
            durationLabel.text = [NSString stringWithFormat:@"%d hours ago", diff];
            
        }
        else if (ti <2629743) {
            int diff = round(ti / 60 /60 /24);
            durationLabel.text = [NSString stringWithFormat:@"%d days ago", diff];
            
        }
        
    return cell;   
    }
    else
    {
    
    
        
        static NSString *CellIdentifier = @"loveCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UILabel *lab = (UILabel *)[cell viewWithTag:777];
        lab.text = [NSString stringWithFormat:@"\"%@\"",[obj valueForKey:@"Content"]];
        UILabel *durationLabel = (UILabel *)[cell viewWithTag:779];
        
        NSDate *createdDate = obj.createdAt;
        double ti = [createdDate timeIntervalSinceDate:[NSDate date]];
        ti = ti * -1;
        if (ti <3600) {
            int diff = round(ti / 60);
            durationLabel.text = [NSString stringWithFormat:@"%d minutes ago", diff];
            
        }
        else if (ti <86400) {
            int diff = round(ti / 60 / 60);
            durationLabel.text = [NSString stringWithFormat:@"%d hours ago", diff];
            
        }
        else if (ti <2629743) {
            int diff = round(ti / 60 /60 /24);
            durationLabel.text = [NSString stringWithFormat:@"%d days ago", diff];
            
        }
        
        return cell;
    }
    
    // Configure the cell...
    
    
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
