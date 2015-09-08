//
//  PrayerTableController.h
//  PrayMate
//
//  Created by zack on 10/3/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h> 
#import "PMPersistentTabBorder.h"

@interface PrayerTableController : UIViewController<CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>{
    CLLocation *userLocation;
}


@property (nonatomic, strong)  NSMutableArray *prayers;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceViewConstraint;

-(IBAction)unwindToPrayerTable:(UIStoryboardSegue *)segue;

-(void)handsButtonPressed:(id)sender;

-(void)handsButtonUnressed:(id)sender;
@property (strong, nonatomic) UIButton *currentButton;
@property (strong, nonatomic) UILabel *currentLabel;
@property (strong, nonatomic)CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)locationFilterPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *locationSegmentedControl;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;

@property (strong, nonatomic) PMPersistentTabBorder *blueBar;
@property (weak, nonatomic) IBOutlet UIView *distanceView;
@property (assign) BOOL distanceViewIsVisible;
@property (strong, nonatomic) NSNumber *selectedDistance;
-(void)refreshFromDistance:(id)sender;
@property (strong, nonatomic  ) PFObject *currentGroup;
@property (nonatomic, assign) BOOL noPrayersFound;
-(void)updateTable;
@property (nonatomic, assign)BOOL groupsIsSender;
@end
