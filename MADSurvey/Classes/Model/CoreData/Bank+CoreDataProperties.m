//
//  Bank+CoreDataProperties.m
//  MADSurvey
//
//  Created by seniorcoder on 7/22/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "Bank+CoreDataProperties.h"

@implementation Bank (CoreDataProperties)

+ (NSFetchRequest<Bank *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Bank"];
}

@dynamic bankDescription;
@dynamic bankNum;
@dynamic name;
@dynamic notes;
@dynamic numOfCar;
@dynamic numOfElevator;
@dynamic numOfInteriorCar;
@dynamic numOfRiser;
@dynamic cars;
@dynamic hallEntrances;
@dynamic hallStations;
@dynamic interiorCars;
@dynamic lanterns;
@dynamic photos;
@dynamic project;

@end
