//
//  Photo+CoreDataClass.h
//  MADSurvey
//
//  Created by seniorcoder on 7/16/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bank, Car, Cop, HallEntrance, HallStation, InteriorCar, Lantern, Lobby, Project;

NS_ASSUME_NONNULL_BEGIN

@interface Photo : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Photo+CoreDataProperties.h"
