//
//  PrayerTableController.m
//  PrayMate
//
//  Created by zack on 10/3/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import "PrayerTableController.h"
#import <Parse/Parse.h>
#import "PMCommentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PMComposePrayerRequestViewController.h"
#import "PMAppDelegate.h"
#import "PMPersistentView.h"


@interface PrayerTableController ()



@end

@implementation PrayerTableController
@synthesize locationManager;
@synthesize tableView = _tableView;
@synthesize segmentedControl = _segmentedControl;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"reply"]) {
        
        
        NSIndexPath *indexPath = sender;
        
        PMCommentViewController *vc =[segue destinationViewController];
        vc.prayer = [_prayers objectAtIndex:indexPath.row];
        vc.ip = indexPath;
        vc.boardIsSender = YES;
        
    }
    
    if ([segue.identifier isEqualToString:@"createGroupPrayer"]) {
        PMComposePrayerRequestViewController *vc = [segue destinationViewController];
        vc.group = _currentGroup;
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    [self performSegueWithIdentifier:@"reply" sender:indexPath];
    
    _currentButton= (UIButton *)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:4];
    
    _currentLabel=(UILabel *)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:3];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


}
-(void)updateTable
{
    PFQuery *query  = [PFQuery queryWithClassName:@"Prayer"];
   /* if (_currentGroup) {
        [query whereKey:@"Group" equalTo:_currentGroup];
        
    }
    else
    {
        [query whereKey:@"hasGroup" equalTo:[NSNumber numberWithBool:NO]];
        
        
    }
    */
    [query includeKey:@"Group"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            //  NSLog(@"find failed");
        }
        else {
            
            [self.prayers removeAllObjects];
            
            [self.prayers addObjectsFromArray:objects];
            // NSLog(@"%@", [_prayers description]);
            
            [self checkForMembership];
            [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
        }
        
    }];
}
-(void)unwindToPrayerTable:(UIStoryboardSegue *)segue
{
    
}
-(NSMutableArray *)prayers
{
    if (!_prayers) {
        _prayers = [NSMutableArray new];
    }
    return _prayers;
}

-(void)viewDidAppear:(BOOL)animated
{
  //  [self.tabBarController.view bringSubviewToFront:_blueBar];
}
-(void)viewWillDisappear:(BOOL)animated
{
   // [_blueBar setHidden:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    
    if (_groupsIsSender) {
        _segmentedControl.selectedSegmentIndex = 1;
        [self segmentedControlChanged:_segmentedControl];
        _groupsIsSender = NO;
    }
    /*if (_blueBar) {
        [_blueBar setHidden:NO];
        return;
    }
    _blueBar = [[PMPersistentTabBorder alloc ] initWithFrame:CGRectMake(0, self.tabBarController.tabBar.frame.origin.y, 320, 1)];
    [_blueBar setBackgroundColor:[PMAppDelegate navyColor]];
    
    
    [self.tabBarController.view addSubview:_blueBar];
    [self.tabBarController.view bringSubviewToFront:_blueBar];
    //[self.tabBarController.view setNeedsDisplay];
    */
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _noPrayersFound = NO;
    //self.tabBarController.tabBar.layer.borderWidth = 0.50;
    
    //self.tabBarController.tabBar.layer.borderColor = [UIColor colorWithRed:0.29803992f green:0.58431373f blue:0.77254902f alpha:1].CGColor;
    
    
    _selectedDistance = [NSNumber numberWithInt:5];
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self CurrentLocationIdentifier];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(CurrentLocationIdentifier) userInfo:nil repeats:YES];
    [timer fire];
    
    
    
    UITableViewController *tv = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tv];
    tv.refreshControl = [UIRefreshControl new];
    [tv.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    tv.tableView = _tableView;
    
   
    _distanceView.layer.masksToBounds = NO;
    _distanceView.layer.shadowColor = [UIColor blackColor].CGColor;
    _distanceView.layer.shadowRadius =5;
    _distanceView.layer.shadowOpacity = .25;
    _distanceView.layer.shadowOffset = CGSizeMake(-15, 20);
    _distanceView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_distanceView.bounds].CGPath;
    
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    /*
    UIImageView *navImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100 , 27)];
    
    UIImage *navBarTitleImage = [UIImage imageNamed:@"pmLR"];
    navImageView.image = navBarTitleImage;
    [navImageView setContentMode:UIViewContentModeScaleAspectFit];
    UIImageView *workaroundImageView = [[UIImageView alloc ]initWithFrame:CGRectMake(0, 0, 100, 27)];
    [workaroundImageView setContentMode:UIViewContentModeScaleAspectFit];
    [workaroundImageView addSubview:navImageView];
    */
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setAllowsSelection:YES];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"New", @"Groups"]];
    _segmentedControl.frame = CGRectMake(0, 0, 80, 30);
    //UIBarButtonItem *segmentedBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    _segmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = _segmentedControl;
    [_segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged ];
    
    
    
    /*if (_currentGroup) {
        self.navigationItem.title = [_currentGroup objectForKey:@"groupName"];
    }
    else{
    //self.navigationItem.titleView = workaroundImageView;
    }
    */
    
    
    
    
    PFQuery *query  = [PFQuery queryWithClassName:@"Prayer"];
    /*
    if (_currentGroup) {
        [query whereKey:@"Group" equalTo:_currentGroup];
        
    }
    else
    {
        [query whereKey:@"hasGroup" equalTo:[NSNumber numberWithBool:NO]];
        
        
    }
    */
    [query includeKey:@"Group"];
    
    [query orderByDescending:@"createdAt"];
    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"Loading Prayer Requests..." mode:MRProgressOverlayViewModeIndeterminate animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
        if (error) {
           // NSLog(@"find failed");
        }
        else {
            [self.prayers removeAllObjects];
            [self.prayers addObjectsFromArray:objects];
            [self checkForMembership];
           // NSLog(@"%@", [_prayers description]);
            
           // [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            //[self.view setNeedsDisplay];
        }
        
    }];    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)segmentedControlChanged:(UISegmentedControl*)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex == 1) {
        NSMutableArray *nonGroupPrayers = [NSMutableArray new];
        for (PFObject* prayer in self.prayers) {
            if ([prayer objectForKey:@"hasGroup"] == [NSNumber numberWithBool:NO] ) {
                [nonGroupPrayers addObject:prayer];
            }
        }
        [self.prayers removeObjectsInArray:nonGroupPrayers];
        if (self.prayers.count == 0) {
            _noPrayersFound = YES;
        }
        [self.tableView reloadData];
    }
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
        [self updateTable];
        
    }
}
-(void)determineTopPrayers
{
    for (PFObject *prayer in _prayers) {
        
        NSDate *created = prayer.createdAt;
        
        
        
        float s = [[prayer objectForKey:@"PrayerCount"] floatValue];
        
        float order = log10(MAX(ABS(s), 1));
        
        double seconds = [created timeIntervalSinceNow];
        
        
         double score =    round(order + (seconds/45000));
        
        
        [prayer setObject:[NSNumber numberWithDouble:score] forKey:@"score"];
        
        
    }
}
-(void)refresh:(id)sender
{
   // NSLog(@"refresh triggered.");
    [_segmentedControl setSelectedSegmentIndex:0];
    PFQuery *query  = [PFQuery queryWithClassName:@"Prayer"];
   /* if (_currentGroup) {
        [query whereKey:@"Group" equalTo:_currentGroup];
        
    }
    else
    {
        [query whereKey:@"hasGroup" equalTo:[NSNumber numberWithBool:NO]];
         
         
    }
    */
    
    [query includeKey:@"Group"];
    
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       [(UIRefreshControl *)sender endRefreshing];
        if (error) {
          //  NSLog(@"find failed");
        }
        else {
            
            [self.prayers removeAllObjects];
            
            [self.prayers addObjectsFromArray:objects];
           // NSLog(@"%@", [_prayers description]);
            [self checkForMembership];
            
        }
        
    }];
    
    
    
    
}
-(void)checkForMembership
{
    _noPrayersFound = NO;
    NSMutableArray *arr = [NSMutableArray new];
    for (PFObject *prayer  in self.prayers) {
        
        if ([prayer objectForKey:@"hasGroup"] == [NSNumber numberWithBool:YES]) {
            
            
            if (![[[prayer objectForKey:@"Group"]objectForKey:@"Members"] containsObject:[token singleton].tokenString]) {
                [arr addObject:prayer];
            }
        }
        
        
        
    }
    [self.prayers removeObjectsInArray:arr];
    if (self.prayers.count == 0) {
        _noPrayersFound = YES;
    }
    [self.tableView reloadData];
   // [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
     //       [self.view setNeedsDisplay];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    
    if (_noPrayersFound) {
        return 1;
        }
    return _prayers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (_prayers.count == 0) {
        static NSString *CellIdentifier = @"noPrayerCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        
        
        return cell;
    }
     
    
    static NSString *CellIdentifier = @"PrayerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    NSString *prayerString = [[_prayers objectAtIndex:indexPath.row] objectForKey:@"Title"];
    
    UIView *buttonBackground = (UIView*)[cell viewWithTag:90];
    buttonBackground.layer.cornerRadius = 14;
    //buttonBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
   // buttonBackground.layer.borderWidth = 1;
    
    
    
       if ([[_prayers objectAtIndex:indexPath.row] objectForKey:@"hasGroup"] == [NSNumber numberWithBool:YES]) {
           UIImageView * groupImageView = (UIImageView*)[cell viewWithTag:47];
           UIImage *groupImage = [[UIImage imageNamed:@"groupsIcon"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
           groupImageView.tintColor = [PMAppDelegate goldColor];
           [groupImageView setImage:groupImage];
           groupImageView.hidden = NO;
           
       }
    else
    {
        UIImageView * groupImageView = (UIImageView*)[cell viewWithTag:47];
        [groupImageView setHidden:YES];
    }
    
    
    titleLabel.text = prayerString;
    [titleLabel sizeToFit];
    
    UILabel *repliesLabel = (UILabel *)[cell viewWithTag:9];
    
    NSArray  *arr = [[_prayers objectAtIndex:indexPath.row] objectForKey:@"Comments"];
    if (arr.count ==0) {
        repliesLabel.text = @"";
    }
    else if (arr.count ==1){
        
    
    repliesLabel.text = [NSString stringWithFormat:@"%lu reply", (unsigned long)arr.count];
    }
    else {
        repliesLabel.text = [NSString stringWithFormat:@"%lu replies", (unsigned long)arr.count];
    }
    [repliesLabel sizeToFit];
   
    UIButton *handsButton = (UIButton *)[cell viewWithTag:4];
    [handsButton addTarget:self action:@selector(handsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *goldButton = (UIButton *)[cell viewWithTag:5];
    [goldButton addTarget:self action:@selector(handsButtonUnressed:) forControlEvents:UIControlEventTouchUpInside];
    
    PMPersistentView *borderView = (PMPersistentView*)[cell viewWithTag:14];
    
    
    
    
    
    UILabel *prayerCountLabel = (UILabel *  )[cell viewWithTag:3];
    prayerCountLabel.text = [[[_prayers objectAtIndex:indexPath.row] objectForKey:@"PrayerCount"] stringValue];
    UILabel *durationLabel = (UILabel*)[cell viewWithTag:1];
    
    UIImageView *clockImgView = (UIImageView*)[cell viewWithTag:48];
    [clockImgView setImage:[[UIImage imageNamed:@"clock@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    clockImgView.tintColor = [PMAppDelegate lightBlueColor];
    
    PFObject *objForDate= [_prayers objectAtIndex:indexPath.row];
    NSDate *createdDate = objForDate.createdAt;
    double ti = [createdDate timeIntervalSinceDate:[NSDate date]];
    ti = ti * -1;
    if (ti <3600) {
        int diff = round(ti / 60);
        durationLabel.text = [NSString stringWithFormat:@"%dm", diff];
        
    }
    else if (ti <86400) {
        int diff = round(ti / 60 / 60);
        durationLabel.text = [NSString stringWithFormat:@"%dh", diff];
        
    }
    else if (ti <2629743) {
        int diff = round(ti / 60 /60 /24);
        durationLabel.text = [NSString stringWithFormat:@"%dd", diff];
        
    }
    borderView.layer.shadowOffset = CGSizeMake(2, 2);
        borderView.layer.shadowRadius = 3;
        borderView.layer.shadowPath = [UIBezierPath bezierPathWithRect:borderView.bounds].CGPath;
        borderView.layer.shadowOpacity = 0.25;
    borderView.layer.cornerRadius = 3;
        borderView.layer.borderWidth = 1;
    borderView.layer.shadowColor = [UIColor blackColor].CGColor;
    NSArray *prayedArr = [objForDate objectForKey:@"Prayed"];
    if ([prayedArr containsObject:[token singleton].tokenString]) {
      [handsButton setHidden:YES];
        [borderView setPersistentBackgroundColor:[UIColor whiteColor]] ;
        borderView.layer.borderColor = [PMAppDelegate goldColor].CGColor;
    }
    else
    {
        [borderView setPersistentBackgroundColor:[PMAppDelegate navyColor]];
        borderView.layer.borderColor = [PMAppDelegate navyColor].CGColor;
       
        
        [handsButton setHidden:NO];
        [goldButton setHidden:NO];
    }
    // Configure the cell...
    
    return cell;
}

/*-(void)replyButtonPressed:(id)sender
{
    
    
    CGPoint buttonPostion = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath =[self.tableView indexPathForRowAtPoint:buttonPostion];
    
    
    [self performSegueWithIdentifier:@"reply" sender:indexPath];
    
    
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(20, buttonPostion.y +55, 1, 1)];
                         
    [testView setBackgroundColor:[UIColor lightGrayColor]];
    [self.tableView addSubview:testView];
    [UIView transitionWithView:testView duration:.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
        testView.transform = CGAffineTransformScale(testView.transform, 280, 200);
        testView.frame = CGRectOffset(testView.frame, 140, 100);
    } completion:^(BOOL finished) {
        
    }];
    
 
    
    
    
    
    
    
}*/
-(void)handsButtonPressed:(id)sender
{
    
    
    
    CGPoint buttonPostion = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath =[self.tableView indexPathForRowAtPoint:buttonPostion];
    
    if (indexPath != nil) {
      [(UIButton *)sender setHidden:YES];
        [[[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:5] setHidden:NO];
        
        
        
        UIImageView *dogView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonPostion.x, (buttonPostion.y  - self.tableView.contentOffset.y), 30, 35)];
        [dogView setAlpha:0.0];
        dogView.image = [UIImage imageNamed:@"angeldog"];
        [self.view addSubview:dogView];
        
        [UIView transitionWithView:dogView duration:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            dogView.transform = CGAffineTransformScale(dogView.transform, 1.2   , 1.2);
            dogView.frame = CGRectMake(dogView.frame.origin.x - 30, -300, dogView.frame.size.width, dogView.frame.size.height);
            [dogView setAlpha:1];
            
        } completion:^(BOOL finished) {
            [dogView removeFromSuperview];
            
        }];
        PFObject *prayer = _prayers[indexPath.row];
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
            comm [@"Content"] = @"\"PikaPrayer, I choose you!\"";
        }
        else if (randomInt == 19)
        {
            
            comm [@"Content"] = @"Mad prayers your way, bro.";
            
        }
        
        
        
        
        
        
        comm [@"Sender"] = [token singleton].tokenString;
        [comm setObject:prayer forKey:@"Prayer"];
        [comm saveInBackground];
        
        NSNumber *newCount = [NSNumber numberWithInt:((int)[prayerCount integerValue] + 1)];
        prayer[@"PrayerCount"] = newCount;
       PMPersistentView *borderview = (PMPersistentView*)[[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:14];
        [self.view layoutIfNeeded];
    
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            borderview.transform = CGAffineTransformMakeScale(1.1, 1.1);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                borderview.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
               
            }];
            
        }];
        
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            
            borderview.layer.borderColor =  [PMAppDelegate goldColor].CGColor;
            [borderview setPersistentBackgroundColor:[UIColor whiteColor]];
            UILabel *label =  (UILabel *)  [[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:3];
            label.text = [newCount stringValue];
            [self.view layoutIfNeeded];
            
        } completion:nil];
        
        
        
        [prayer addObject:[token singleton].tokenString forKey:@"Prayed"];
        [prayer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error){
               // NSLog(@"%@",error.localizedDescription);
            }
            else
            {
            UILabel *label =  (UILabel *)  [[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:3];
                label.text = [newCount stringValue];
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
}
    
-(void)handsButtonUnressed:(id)sender
{
    CGPoint buttonPostion = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath =[self.tableView indexPathForRowAtPoint:buttonPostion];
    
    if (indexPath != nil) {
        
        PMPersistentView *borderview = (PMPersistentView*)[[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:14];
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            borderview.transform = CGAffineTransformMakeScale(1.1, 1.1);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                borderview.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                
            }];
            
        }];
        
        //[(UIButton *)sender setHidden:YES];
        [[[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:4] setHidden:NO];
        
        PFObject *prayer = _prayers[indexPath.row];
        NSNumber *prayerCount = [prayer objectForKey:@"PrayerCount"];
        
        NSNumber *newCount = [NSNumber numberWithInt:((int)[prayerCount integerValue] -1)];
        prayer[@"PrayerCount"] = newCount;
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            
            borderview.layer.borderColor =  [PMAppDelegate navyColor].CGColor;
            [borderview setPersistentBackgroundColor:[PMAppDelegate navyColor]];
            UILabel *label =  (UILabel *)  [[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:3];
            label.text = [newCount stringValue];
            
        } completion:nil];
       
        
        
        [prayer removeObject:[token singleton].tokenString forKey:@"Prayed"];
        
        
        [prayer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error){
              //  NSLog(@"%@",error.localizedDescription);
            }
            else
            {
                UILabel *label =  (UILabel *)  [[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:3];
                label.text = [newCount stringValue];
                [self.view setNeedsDisplay];
            }
        }];
       // UIButton *newButt = (UIButton *)[[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:4];
        
        
       // [[self.tableView cellForRowAtIndexPath:indexPath] addSubview:newButt];
        
        
        
    }
}
#pragma mark location
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{   [locationManager stopUpdatingLocation];
    userLocation = [locations objectAtIndex:0];
    
    
    
    
    
    
}
-(void)CurrentLocationIdentifier
{
    locationManager = [CLLocationManager new];
    
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])  {
        [locationManager requestWhenInUseAuthorization];
    }
    
    
    [locationManager startUpdatingLocation];
    
}/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
-(void)refreshFromDistance:(id)sender
{
    PFQuery *query  = [PFQuery queryWithClassName:@"Prayer"];
    
    /*
    if (_currentGroup) {
        [query whereKey:@"Group" equalTo:_currentGroup];
        
    }
    else
    {
        [query whereKey:@"hasGroup" equalTo:[NSNumber numberWithBool:NO]];
        
        
    }
     */
    PFGeoPoint *geo = [PFGeoPoint geoPointWithLocation:userLocation];
    double distance = [_selectedDistance doubleValue];
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
      [query whereKey:@"Location" nearGeoPoint:geo withinMiles:distance];
    }
    [query includeKey:@"Group"];
    [query orderByDescending:@"createdAt"];
    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"Loading Prayer Requests..." mode:MRProgressOverlayViewModeIndeterminate animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
        
        if (error) {
            //  NSLog(@"find failed");
        }
        else {
            
            [self.prayers removeAllObjects];
            
            [self.prayers addObjectsFromArray:objects];
            // NSLog(@"%@", [_prayers description]);
            
            [self checkForMembership];
        }
        
    }];
    
}
- (IBAction)locationFilterPressed:(id)sender {
    
    if (_distanceViewIsVisible ==NO) {
        _distanceViewConstraint.constant = 0;
        [_distanceView setNeedsUpdateConstraints];
        
        
        
        [UIView animateWithDuration:.5 animations:^{
            
            [_distanceView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            _distanceViewIsVisible = YES;
        }];
    }
    else
    {
        _distanceViewConstraint.constant = -120;
        [_distanceView setNeedsUpdateConstraints];
        
        [self refreshFromDistance:self];
        [UIView animateWithDuration:.5 animations:^{
            
            [_distanceView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            _distanceViewIsVisible = NO;
        }];
    }
    
    
    
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_distanceViewIsVisible==YES)
    {
        _distanceViewConstraint.constant = -120;
        [_distanceView setNeedsUpdateConstraints];
        
        [self refreshFromDistance:self];
        
        [UIView animateWithDuration:.5 animations:^{
            
            [_distanceView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            _distanceViewIsVisible = NO;
        }];
        
    }
}
-(IBAction)sliderValueChanged:(UISlider *)sender
{
    _selectedDistance = [NSNumber numberWithFloat:sender.value];
    
    if (sender.value <=1.5) {
        [_segmentedControl setTitle:@"1 mile"forSegmentAtIndex:0];
    }
    else {
    NSString*miles = [NSString stringWithFormat:@"%.0f miles", sender.value];
    
    [_segmentedControl setTitle:miles forSegmentAtIndex:0];
    
    }
}











@end
