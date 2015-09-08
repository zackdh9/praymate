//
//  token.m
//  PrayMate
//
//  Created by zack on 10/19/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import "token.h"

@implementation token

+(token*)singleton {
    static dispatch_once_t pred;
    static token *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[token alloc] init];
        shared.tokenString = [[NSString alloc] init];
        
    });
    return shared;
}
@end
