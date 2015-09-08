//
//  PMEditPrayerViewController.m
//  PrayMate
//
//  Created by zack on 3/3/15.
//  Copyright (c) 2015 zachary hamblen. All rights reserved.
//

#import "PMEditPrayerViewController.h"
#import "PMCommentViewController.h"

@interface PMEditPrayerViewController ()

@end

@implementation PMEditPrayerViewController


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender == _doneButton) {
        PMCommentViewController *vc = (PMCommentViewController*)[segue destinationViewController];
        [_prayer setObject:_textView.text forKey:@"Title"];
        vc.prayer = _prayer;
        [_prayer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
        }];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _textView.text = [_prayer objectForKey:@"Title"];
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

@end
