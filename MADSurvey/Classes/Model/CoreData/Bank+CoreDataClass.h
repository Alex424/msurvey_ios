//
//  Bank+CoreDataClass.h
//  MADSurvey
//
//  Created by seniorcoder on 7/16/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car, HallEntrance, HallStation, InteriorCar, Lantern, Photo, Project;

NS_ASSUME_NONNULL_BEGIN

@interface Bank : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Bank+CoreDataProperties.h"
