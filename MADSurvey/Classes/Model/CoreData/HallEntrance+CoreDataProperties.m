//
//  HallEntrance+CoreDataProperties.m
//  MADSurvey
//
//  Created by seniorcoder on 7/22/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallEntrance+CoreDataProperties.h"

@implementation HallEntrance (CoreDataProperties)

+ (NSFetchRequest<HallEntrance *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"HallEntrance"];
}

@dynamic carNum;
@dynamic direction;
@dynamic doorType;
@dynamic floorDescription;
@dynamic floorNum;
@dynamic height;
@dynamic leftSideA;
@dynamic leftSideB;
@dynamic leftSideC;
@dynamic leftSideD;
@dynamic notes;
@dynamic rightSideA;
@dynamic rightSideB;
@dynamic rightSideC;
@dynamic rightSideD;
@dynamic transomMeasurementsA;
@dynamic transomMeasurementsB;
@dynamic transomMeasurementsC;
@dynamic transomMeasurementsD;
@dynamic transomMeasurementsE;
@dynamic transomMeasurementsF;
@dynamic transomMeasurementsG;
@dynamic transomMeasurementsH;
@dynamic transomMeasurementsI;
@dynamic bank;
@dynamic photos;

@end
