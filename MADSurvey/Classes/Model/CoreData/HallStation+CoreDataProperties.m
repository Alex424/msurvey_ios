//
//  HallStation+CoreDataProperties.m
//  MADSurvey
//
//  Created by seniorcoder on 7/22/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallStation+CoreDataProperties.h"

@implementation HallStation (CoreDataProperties)

+ (NSFetchRequest<HallStation *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"HallStation"];
}

@dynamic affValue;
@dynamic floorNumber;
@dynamic hallStationDescription;
@dynamic hallStationNum;
@dynamic height;
@dynamic mount;
@dynamic notes;
@dynamic sameAs;
@dynamic screwCenterHeight;
@dynamic screwCenterWidth;
@dynamic uuid;
@dynamic wallFinish;
@dynamic width;
@dynamic bank;
@dynamic photos;

@end
