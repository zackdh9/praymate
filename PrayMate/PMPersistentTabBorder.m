//
//  PMPersistentTabBorder.m
//  Pods
//
//  Created by zack on 3/26/15.
//
//

#import "PMPersistentTabBorder.h"

@implementation PMPersistentTabBorder


- (void)drawRect:(CGRect)rect {
    [self.superview bringSubviewToFront:self];
}


@end
