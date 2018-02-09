//
//  InteriorCar+CoreDataProperties.m
//  MADSurvey
//
//  Created by seniorcoder on 7/22/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCar+CoreDataProperties.h"

@implementation InteriorCar (CoreDataProperties)

+ (NSFetchRequest<InteriorCar *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"InteriorCar"];
}

@dynamic birdCage;
@dynamic carCapacity;
@dynamic carDescription;
@dynamic carFloorHeight;
@dynamic carFlooring;
@dynamic carTiller;
@dynamic carWeight;
@dynamic escapeHatchLength;
@dynamic escapeHatchLocation;
@dynamic escapeHatchToBackWall;
@dynamic escapeHatchToLeftWall;
@dynamic escapeHatchWidth;
@dynamic exhaustFanLocation;
@dynamic exhaustLength;
@dynamic exhaustToBackWall;
@dynamic exhaustToLeftWall;
@dynamic exhaustWidth;
@dynamic installNumber;
@dynamic interiorCarNum;
@dynamic isThereBackDoor;
@dynamic isThereExhaustFan;
@dynamic mount;
@dynamic notes;
@dynamic numberOfPeople;
@dynamic rearWallHeight;
@dynamic rearWallWidth;
@dynamic typeOfCar;
@dynamic typeOfCeilingFrame;
@dynamic uuid;
@dynamic weightScale;
@dynamic backDoor;
@dynamic bank;
@dynamic frontDoor;
@dynamic photos;

@end
