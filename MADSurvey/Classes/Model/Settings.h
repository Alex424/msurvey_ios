//
//  Settings.h
//  MADSurvey
//
//  Created by seniorcoder on 7/27/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (nonatomic, strong) NSString *yourName;
@property (nonatomic, strong) NSString *yourEmail;
@property (nonatomic, strong) NSString *yourCompany;
@property (nonatomic, strong) NSString *yourPhone;
@property (nonatomic, strong) NSString *yourState;
@property (nonatomic, assign) NSInteger units;
@property (nonatomic, assign) BOOL reportByEmail;

+ (instancetype)sharedSettings;

- (void)loadSettings;
- (void)saveSettings;

@end
