//
//  token.h
//  PrayMate
//
//  Created by zack on 10/19/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface token : NSObject

@property NSString *tokenString;

+(token*)singleton;

@end
