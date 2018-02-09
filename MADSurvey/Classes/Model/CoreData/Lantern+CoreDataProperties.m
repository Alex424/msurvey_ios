//
//  Lantern+CoreDataProperties.m
//  MADSurvey
//
//  Created by seniorcoder on 7/22/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "Lantern+CoreDataProperties.h"

@implementation Lantern (CoreDataProperties)

+ (NSFetchRequest<Lantern *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Lantern"];
}

@dynamic affValue;
@dynamic depth;
@dynamic floorNumber;
@dynamic height;
@dynamic lanternDescription;
@dynamic lanternNum;
@dynamic mount;
@dynamic notes;
@dynamic quantity;
@dynamic sameAs;
@dynamic screwCenterHeight;
@dynamic screwCenterWidth;
@dynamic spaceAvailableHeight;
@dynamic spaceAvailableWidth;
@dynamic uuid;
@dynamic wallFinish;
@dynamic width;
@dynamic bank;
@dynamic photos;

@end
