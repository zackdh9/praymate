//
//  PMCreateGroupViewController.m
//  PrayMate
//
//  Created by zack on 11/3/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import "PMCreateGroupViewController.h"

@interface PMCreateGroupViewController ()

@end

@implementation PMCreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scroller.delegate = self;
    _pinTextField.delegate =self;
    _scroller.translatesAutoresizingMaskIntoConstraints = YES;
    // Do any additional setup after loading the view.
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 4) {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        return NO;
    }
    return YES;
}
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    
    
    
    
    
    
    
    
    
    
    
    
    
  
  
    if (_nameTextView.text.length > 0) {
        PFObject *group = [[PFObject alloc] initWithClassName:@"Group"];
    NSArray *membersArray = [NSArray arrayWithObjects:[token singleton].tokenString, nil];
    group [@"Members"] = membersArray;
    group [@"groupName"] = _nameTextView.text;
        if (_pinTextField.text.length ==4) {
     group [@"Pin"] = _pinTextField.text;
        }
    else if (_pinTextField.text.length ==0)
    {
        group [@"Pin"] = @"1111";
    }
    else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Designated Pin invalid." message:@"Please recheck the group fields" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        
        
        return;
        
    }
    
    [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error){
            NSLog(@"%@", error.localizedDescription);
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Group creation failed" message:@"Please recheck the group fields" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            [self performSegueWithIdentifier:@"toGroups" sender:self];
        }
    }];
        
    }
    else{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Group name and pin required" message:@"Please retry" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
    
    }
    
    
    
    
}
@end
