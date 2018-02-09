//
//  NSString+Double.m
//  MADSurvey
//
//  Created by seniorcoder on 12/21/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "NSString+Double.h"

@implementation NSString (Double)

- (double)doubleValueCheckingEmpty {
    if (self.length == 0) {
        return -1;
    }
    
    return [self doubleValue];
}

@end
