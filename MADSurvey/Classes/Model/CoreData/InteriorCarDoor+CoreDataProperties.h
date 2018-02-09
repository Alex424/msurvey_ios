//
//  InteriorCarDoor+CoreDataProperties.h
//  MADSurvey
//
//  Created by seniorcoder on 11/27/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarDoor+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface InteriorCarDoor (CoreDataProperties)

+ (NSFetchRequest<InteriorCarDoor *> *)fetchRequest;

@property (nonatomic) double auxCopBottom;
@property (nonatomic) double auxCopHeight;
@property (nonatomic) double auxCopLeft;
@property (nonatomic) double auxCopReturn;
@property (nonatomic) double auxCopRight;
@property (nonatomic) double auxCopThroat;
@property (nonatomic) double auxCopTop;
@property (nonatomic) double auxCopWidth;
@property (nonatomic) int32_t carDoorOpeningDirection;
@property (nonatomic) int32_t carDoorType;
@property (nonatomic) int32_t centerOpening;
@property (nonatomic) double doorOpeningHeight;
@property (nonatomic) double doorOpeningWidth;
@property (nonatomic) int32_t doorStyle;
@property (nonatomic) double frontReturnMeasurementsHeight;
@property (nonatomic) double height;
@property (nullable, nonatomic, copy) NSString *isThereNewCop;
@property (nonatomic) double leftSideA;
@property (nonatomic) double leftSideATypeB;
@property (nonatomic) double leftSideB;
@property (nonatomic) double leftSideBTypeB;
@property (nonatomic) double leftSideC;
@property (nonatomic) double leftSideCTypeB;
@property (nonatomic) double leftSideD;
@property (nonatomic) double leftSideE;
@property (nonatomic) double mainCopBottom;
@property (nonatomic) double mainCopHeight;
@property (nonatomic) double mainCopLeft;
@property (nonatomic) double mainCopReturn;
@property (nonatomic) double mainCopRight;
@property (nonatomic) double mainCopThroat;
@property (nonatomic) double mainCopTop;
@property (nonatomic) double mainCopWidth;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nullable, nonatomic, copy) NSString *otherFrontReturnMeasurements;
@property (nullable, nonatomic, copy) NSString *otherSlamPost;
@property (nonatomic) double returnSideWallDepth;
@property (nonatomic) double rightSideA;
@property (nonatomic) double rightSideATypeB;
@property (nonatomic) double rightSideB;
@property (nonatomic) double rightSideBTypeB;
@property (nonatomic) double rightSideC;
@property (nonatomic) double rightSideCTypeB;
@property (nonatomic) double rightSideD;
@property (nonatomic) double rightSideE;
@property (nonatomic) double sideWallAuxWidth;
@property (nonatomic) double sideWallMainWidth;
@property (nonatomic) double slamPostMeasurementsA;
@property (nonatomic) double slamPostMeasurementsB;
@property (nonatomic) double slamPostMeasurementsC;
@property (nonatomic) double slamPostMeasurementsD;
@property (nonatomic) double slamPostMeasurementsE;
@property (nonatomic) double slamPostMeasurementsF;
@property (nonatomic) double slamPostMeasurementsG;
@property (nonatomic) double slamPostMeasurementsH;
@property (nonatomic) double slamSideWallDepth;
@property (nonatomic) double slideWallWidth;
@property (nonatomic) double transomMeasurementsCenter;
@property (nonatomic) double transomMeasurementsCenterLeft;
@property (nonatomic) double transomMeasurementsCenterRight;
@property (nonatomic) double transomMeasurementsHeight;
@property (nonatomic) double transomMeasurementsLeft;
@property (nonatomic) double transomMeasurementsRight;
@property (nonatomic) double transomMeasurementsWidth;
@property (nonatomic) double transomProfileColonnade;
@property (nonatomic) double transomProfileColonnade2;
@property (nonatomic) double transomProfileDepth;
@property (nonatomic) double transomProfileHeight;
@property (nonatomic) double transomProfileReturn;
@property (nullable, nonatomic, copy) NSString *typeOfFrontReturn;
@property (nullable, nonatomic, copy) NSString *typeOfSlamPost;
@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, copy) NSString *wallType;
@property (nullable, nonatomic, copy) NSString *wallTypeNotes;
@property (nonatomic) double width;
@property (nonatomic) double lTransomWidth;
@property (nonatomic) double lTransomHeight;
@property (nonatomic) double headerReturnHoistWay;
@property (nonatomic) double headerThroat;
@property (nonatomic) double headerWidth;
@property (nonatomic) double headerHeight;
@property (nonatomic) double headerReturnWall;
@property (nonatomic) double flatFrontLeftWidth;
@property (nonatomic) double flatFrontLeftHeight;
@property (nonatomic) double flatFrontRightWidth;
@property (nonatomic) double flatFrontRightHeight;
@property (nullable, nonatomic, retain) InteriorCar *interiorCarBack;
@property (nullable, nonatomic, retain) InteriorCar *interiorCarFront;

@end

NS_ASSUME_NONNULL_END
