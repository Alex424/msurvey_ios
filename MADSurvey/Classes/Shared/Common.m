//
//  Common.m
//  MADSurvey
//
//  Created by seniorcoder on 7/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "Common.h"
#import "MADWarningAlert.h"

@implementation Common

+ (void)showWarningAlert:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@"Warning"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
     show];
    
//    [MADWarningAlert showOnView:[UIApplication sharedApplication].keyWindow withTitle:message];
}

+ (NSString *)generateUUID {
    return [[NSUUID UUID] UUIDString];
}


+ (NSString *)appVersion {
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"]];
    
    return plist[(NSString *)kCFBundleVersionKey];
}

@end
