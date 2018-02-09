//
//  InteriorCarDoor+CoreDataProperties.m
//  MADSurvey
//
//  Created by seniorcoder on 11/27/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarDoor+CoreDataProperties.h"

@implementation InteriorCarDoor (CoreDataProperties)

+ (NSFetchRequest<InteriorCarDoor *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"InteriorCarDoor"];
}

@dynamic auxCopBottom;
@dynamic auxCopHeight;
@dynamic auxCopLeft;
@dynamic auxCopReturn;
@dynamic auxCopRight;
@dynamic auxCopThroat;
@dynamic auxCopTop;
@dynamic auxCopWidth;
@dynamic carDoorOpeningDirection;
@dynamic carDoorType;
@dynamic centerOpening;
@dynamic doorOpeningHeight;
@dynamic doorOpeningWidth;
@dynamic doorStyle;
@dynamic frontReturnMeasurementsHeight;
@dynamic height;
@dynamic isThereNewCop;
@dynamic leftSideA;
@dynamic leftSideATypeB;
@dynamic leftSideB;
@dynamic leftSideBTypeB;
@dynamic leftSideC;
@dynamic leftSideCTypeB;
@dynamic leftSideD;
@dynamic leftSideE;
@dynamic mainCopBottom;
@dynamic mainCopHeight;
@dynamic mainCopLeft;
@dynamic mainCopReturn;
@dynamic mainCopRight;
@dynamic mainCopThroat;
@dynamic mainCopTop;
@dynamic mainCopWidth;
@dynamic notes;
@dynamic otherFrontReturnMeasurements;
@dynamic otherSlamPost;
@dynamic returnSideWallDepth;
@dynamic rightSideA;
@dynamic rightSideATypeB;
@dynamic rightSideB;
@dynamic rightSideBTypeB;
@dynamic rightSideC;
@dynamic rightSideCTypeB;
@dynamic rightSideD;
@dynamic rightSideE;
@dynamic sideWallAuxWidth;
@dynamic sideWallMainWidth;
@dynamic slamPostMeasurementsA;
@dynamic slamPostMeasurementsB;
@dynamic slamPostMeasurementsC;
@dynamic slamPostMeasurementsD;
@dynamic slamPostMeasurementsE;
@dynamic slamPostMeasurementsF;
@dynamic slamPostMeasurementsG;
@dynamic slamPostMeasurementsH;
@dynamic slamSideWallDepth;
@dynamic slideWallWidth;
@dynamic transomMeasurementsCenter;
@dynamic transomMeasurementsCenterLeft;
@dynamic transomMeasurementsCenterRight;
@dynamic transomMeasurementsHeight;
@dynamic transomMeasurementsLeft;
@dynamic transomMeasurementsRight;
@dynamic transomMeasurementsWidth;
@dynamic transomProfileColonnade;
@dynamic transomProfileColonnade2;
@dynamic transomProfileDepth;
@dynamic transomProfileHeight;
@dynamic transomProfileReturn;
@dynamic typeOfFrontReturn;
@dynamic typeOfSlamPost;
@dynamic uuid;
@dynamic wallType;
@dynamic wallTypeNotes;
@dynamic width;
@dynamic lTransomWidth;
@dynamic lTransomHeight;
@dynamic headerReturnHoistWay;
@dynamic headerThroat;
@dynamic headerWidth;
@dynamic headerHeight;
@dynamic headerReturnWall;
@dynamic flatFrontLeftWidth;
@dynamic flatFrontLeftHeight;
@dynamic flatFrontRightWidth;
@dynamic flatFrontRightHeight;
@dynamic interiorCarBack;
@dynamic interiorCarFront;

@end
