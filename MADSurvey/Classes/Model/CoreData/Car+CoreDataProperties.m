//
//  Car+CoreDataProperties.m
//  MADSurvey
//
//  Created by seniorcoder on 7/22/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "Car+CoreDataProperties.h"

@implementation Car (CoreDataProperties)

+ (NSFetchRequest<Car *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Car"];
}

@dynamic capacityNumberPersons;
@dynamic capacityWeight;
@dynamic carDescription;
@dynamic carNum;
@dynamic carNumber;
@dynamic coverHeightCDI;
@dynamic coverHeightSPI;
@dynamic coverScrewCenterHeightCDI;
@dynamic coverScrewCenterHeightSPI;
@dynamic coverScrewCenterWidthCDI;
@dynamic coverScrewCenterWidthSPI;
@dynamic coverWidthCDI;
@dynamic coverWidthSPI;
@dynamic depthCDI;
@dynamic depthSPI;
@dynamic doorsCoinciding;
@dynamic floorMarkings;
@dynamic frontDoorOpeningHeight;
@dynamic frontDoorSlideJambWidth;
@dynamic frontDoorStrikeJambWidth;
@dynamic handRailDistanceFromReturn;
@dynamic handRailDistanceFromWall;
@dynamic handRailHeightFromFloor;
@dynamic installNumber;
@dynamic isThereCDI;
@dynamic isThereHandRail;
@dynamic isThereRearDoor;
@dynamic isThereSPI;
@dynamic mountCDI
;
@dynamic mountSPI;
@dynamic notes;
@dynamic notesCDI;
@dynamic notesSPI;
@dynamic numberOfCops;
@dynamic numberOfOpenings;
@dynamic numberPerCabCDI;
@dynamic numberPerCabSPI;
@dynamic rearDoorOpeningHeight;
@dynamic rearDoorSlideJambWidth;
@dynamic rearDoorStrikeJambWidth;
@dynamic spaceAvailableHeightSPI;
@dynamic spaceAvailableWidthSPI;
@dynamic uuid;
@dynamic weightScale;
@dynamic jobType;
@dynamic bank;
@dynamic cops;
@dynamic photos;
@dynamic cdiPhotos;
@dynamic spiPhotos;

@end
