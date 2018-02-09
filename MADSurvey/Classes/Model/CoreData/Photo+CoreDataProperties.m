//
//  Photo+CoreDataProperties.m
//  MADSurvey
//
//  Created by seniorcoder on 7/22/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "Photo+CoreDataProperties.h"

@implementation Photo (CoreDataProperties)

+ (NSFetchRequest<Photo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
}

@dynamic fileName;
@dynamic fileURL;
@dynamic bank;
@dynamic car;
@dynamic cop;
@dynamic hallEntrance;
@dynamic hallStation;
@dynamic interiorCar;
@dynamic lantern;
@dynamic lobby;
@dynamic project;
@dynamic cdiCar;
@dynamic spiCar;

@end
