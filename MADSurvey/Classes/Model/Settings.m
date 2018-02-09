//
//  Settings.m
//  MADSurvey
//
//  Created by seniorcoder on 7/27/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "Settings.h"
#import "Constants.h"

@implementation Settings

+ (instancetype)sharedSettings {
    static Settings *settings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settings = [Settings new];
    });
    return settings;
}

- (id)init {
    self = [super init];
    if (self) {
        [self loadSettings];
    }
    
    return self;
}


- (void)loadSettings {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.yourName = [userDefaults objectForKey:SettingsKeyYourName];
    if (!self.yourName) {
        self.yourName = @"";
    }
    self.yourEmail = [userDefaults objectForKey:SettingsKeyYourEmail];
    if (!self.yourEmail) {
        self.yourEmail = @"";
    }
    self.yourCompany = [userDefaults objectForKey:SettingsKeyYourCompany];
    if (!self.yourCompany) {
        self.yourCompany = @"";
    }
    self.yourPhone = [userDefaults objectForKey:SettingsKeyYourPhone];
    if (!self.yourPhone) {
        self.yourPhone = @"";
    }
    self.yourState = [userDefaults objectForKey:SettingsKeyYourState];
    if (!self.yourState) {
        self.yourState = @"";
    }
    self.units = [userDefaults integerForKey:SettingsKeyUnitsLabel];
    if (!self.units) {
        self.units = ProjectSettingUnitsInches;
    }
    self.reportByEmail = ([userDefaults objectForKey:SettingsKeyReport] == nil);
}

- (void)saveSettings {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:self.yourName forKey:SettingsKeyYourName];
    [userDefaults setObject:self.yourEmail forKey:SettingsKeyYourEmail];
    [userDefaults setObject:self.yourCompany forKey:SettingsKeyYourCompany];
    [userDefaults setObject:self.yourPhone forKey:SettingsKeyYourPhone];
    [userDefaults setObject:self.yourState forKey:SettingsKeyYourState];
    [userDefaults setInteger:self.units forKey:SettingsKeyUnitsLabel];
    if (!self.reportByEmail) {
        [userDefaults setBool:YES forKey:SettingsKeyReport];
    } else {
        [userDefaults removeObjectForKey:SettingsKeyReport];
    }

    [userDefaults synchronize];
}

@end
