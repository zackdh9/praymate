//
//  PMComposePrayerRequestViewController.m
//  PrayMate
//
//  Created by zack on 10/3/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import "PMComposePrayerRequestViewController.h"
#import <Parse/Parse.h>
#import "PrayerTableController.h"

@interface PMComposePrayerRequestViewController ()

@end

@implementation PMComposePrayerRequestViewController
@synthesize locationManager;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"getOut"]) {
        PrayerTableController *vc = (PrayerTableController*)[segue destinationViewController];
        [vc.prayers insertObject:_prayer atIndex:0];
        [vc.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _textView.delegate = self;
    
    _groupsPickerView.delegate = self;
    _groupsPickerView.dataSource = self;
    _groupsArray = [NSMutableArray new];
    PFObject *publicBoardObject = [[PFObject alloc] initWithClassName:@"Group"];
    [publicBoardObject setObject:@"Public Board" forKey:@"groupName"];
    [_groupsArray addObject:publicBoardObject];
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [inputView setBackgroundColor: [UIColor clearColor]];
    UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(270, 0, 40, 25)];
    [countView setBackgroundColor:[UIColor colorWithWhite:.5 alpha:.8f]];
    [countView.layer setCornerRadius:5.0];
    _countLabel = [[UILabel alloc] initWithFrame:countView.frame];
    _countLabel.text = @"175";
    _countLabel.textColor = [UIColor colorWithRed:157.0/255.0 green:223.0/255.0 blue:1 alpha:1];
    [_countLabel setTextAlignment:NSTextAlignmentCenter];
    [inputView addSubview:countView];
    [inputView addSubview:_countLabel];
    [_textView setInputAccessoryView:inputView];
    
    
    
    
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"Group"];
    NSArray *memberArray = [NSArray arrayWithObjects:[token singleton].tokenString, nil];
    [groupQuery whereKey:@"Members" containsAllObjectsInArray:memberArray];
    
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
        else{
            [self.groupsArray removeAllObjects];
            
            PFObject *publicBoardObject = [[PFObject alloc] initWithClassName:@"Group"];
            [publicBoardObject setObject:@"Public Board" forKey:@"groupName"];
            [_groupsArray addObject:publicBoardObject];
            
            [self.groupsArray addObjectsFromArray:objects];
            
            
            [_groupsPickerView reloadAllComponents];
            
            
            
            
            [self.view setNeedsDisplay];
        }
    }];
    
    
    [self CurrentLocationIdentifier];
	// Do any additional setup after loading the view.
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _groupsArray.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    PFObject *group =_groupsArray[row];
    return [group objectForKey:@"groupName"];
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row ==0) {
        _group = nil;
    }
    else
    {
        _group = _groupsArray[row];
    }
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
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{   [locationManager stopUpdatingLocation];
    userLocation = [locations objectAtIndex:0];
    
    
    
    
    
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    int r = 175 - _textView.text.length;
    _countLabel.text = [NSString stringWithFormat:@"%d", r];
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (_textView.text.length == 175) {
        if ([text isEqualToString:@""] ) {
            return YES;
        }
        return NO;
        
    }
    
    return YES;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    
    if (_textView.text.length > 0) {
     
    PFObject *prayer = [PFObject objectWithClassName:@"Prayer"];
    //prayer [@"Title"] = _titleTextField.text;
        [prayer setObject:[PFUser currentUser] forKey:@"Owner"];
        
        if (_group) {
            [prayer setObject:_group forKey:@"Group"];
            [prayer setObject:[NSNumber numberWithBool:YES] forKey:@"hasGroup"];
        }
        else
        {
            [prayer setObject:[NSNumber numberWithBool:NO ] forKey:@"hasGroup"];
        }
    prayer [@"Title"] = _textView.text;
    prayer [@"PrayerCount"] = [NSNumber numberWithInt:0];
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        [prayer setObject:geoPoint forKey:@"Location"];
        
        
        
        _prayer = prayer;
    
    [prayer saveInBackground];
    
    [self performSegueWithIdentifier:@"getOut" sender:self];
    
    }
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    _group = nil;
    
}
- (IBAction)dogButton:(UIButton *)sender {
    
    [UIView transitionWithView:_dogImage duration:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _dogImage.transform = CGAffineTransformScale(_dogImage.transform, .2, .2);
        _dogImage.frame = CGRectOffset(_dogImage.frame, 48, -900);
    } completion:^(BOOL finished) {
        
    }];
    
}
@end
