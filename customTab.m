//
//  customTab.m
//  gui7
//
//  Created by zack on 8/18/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import "customTab.h"

@implementation customTab

-(void)setSelectedImageName:(NSString *)selectedImageName
{
    self.selectedImage = [UIImage imageNamed:selectedImageName];
}

@end
