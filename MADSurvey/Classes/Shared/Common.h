//
//  Common.h
//  MADSurvey
//
//  Created by seniorcoder on 7/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Common : NSObject

+ (void)showWarningAlert:(NSString *)message;
+ (NSString *)generateUUID;

+ (NSString *)appVersion;

@end
