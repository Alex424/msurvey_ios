//
//  Car+CoreDataProperties.h
//  MADSurvey
//
//  Created by seniorcoder on 7/22/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "Car+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Car (CoreDataProperties)

+ (NSFetchRequest<Car *> *)fetchRequest;

@property (nonatomic) int32_t capacityNumberPersons;
@property (nonatomic) double capacityWeight;
@property (nullable, nonatomic, copy) NSString *carDescription;
@property (nonatomic) int32_t carNum;
@property (nullable, nonatomic, copy) NSString *carNumber;
@property (nonatomic) double coverHeightCDI;
@property (nonatomic) double coverHeightSPI;
@property (nonatomic) double coverScrewCenterHeightCDI;
@property (nonatomic) double coverScrewCenterHeightSPI;
@property (nonatomic) double coverScrewCenterWidthCDI;
@property (nonatomic) double coverScrewCenterWidthSPI;
@property (nonatomic) double coverWidthCDI;
@property (nonatomic) double coverWidthSPI;
@property (nonatomic) double depthCDI;
@property (nonatomic) double depthSPI;
@property (nullable, nonatomic, copy) NSString *doorsCoinciding;
@property (nullable, nonatomic, copy) NSString *floorMarkings;
@property (nonatomic) double frontDoorOpeningHeight;
@property (nonatomic) double frontDoorSlideJambWidth;
@property (nonatomic) double frontDoorStrikeJambWidth;
@property (nonatomic) double handRailDistanceFromReturn;
@property (nonatomic) double handRailDistanceFromWall;
@property (nonatomic) double handRailHeightFromFloor;
@property (nullable, nonatomic, copy) NSString *installNumber;
@property (nonatomic) int32_t isThereCDI;
@property (nonatomic) int32_t isThereHandRail;
@property (nonatomic) int32_t isThereRearDoor;
@property (nonatomic) int32_t isThereSPI;
@property (nullable, nonatomic, copy) NSString *mountCDI;
@property (nullable, nonatomic, copy) NSString *mountSPI;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nullable, nonatomic, copy) NSString *notesCDI;
@property (nullable, nonatomic, copy) NSString *notesSPI;
@property (nonatomic) int32_t numberOfCops;
@property (nonatomic) int32_t numberOfOpenings;
@property (nonatomic) int32_t numberPerCabCDI;
@property (nonatomic) int32_t numberPerCabSPI;
@property (nonatomic) double rearDoorOpeningHeight;
@property (nonatomic) double rearDoorSlideJambWidth;
@property (nonatomic) double rearDoorStrikeJambWidth;
@property (nonatomic) double spaceAvailableHeightSPI;
@property (nonatomic) double spaceAvailableWidthSPI;
@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, copy) NSString *weightScale;
@property (nullable, nonatomic, copy) NSString *jobType;
@property (nullable, nonatomic, retain) Bank *bank;
@property (nullable, nonatomic, retain) NSOrderedSet<Cop *> *cops;
@property (nullable, nonatomic, retain) NSOrderedSet<Photo *> *photos;
@property (nullable, nonatomic, retain) NSOrderedSet<Photo *> *cdiPhotos;
@property (nullable, nonatomic, retain) NSOrderedSet<Photo *> *spiPhotos;

@end

@interface Car (CoreDataGeneratedAccessors)

- (void)insertObject:(Cop *)value inCopsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCopsAtIndex:(NSUInteger)idx;
- (void)insertCops:(NSArray<Cop *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCopsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCopsAtIndex:(NSUInteger)idx withObject:(Cop *)value;
- (void)replaceCopsAtIndexes:(NSIndexSet *)indexes withCops:(NSArray<Cop *> *)values;
- (void)addCopsObject:(Cop *)value;
- (void)removeCopsObject:(Cop *)value;
- (void)addCops:(NSOrderedSet<Cop *> *)values;
- (void)removeCops:(NSOrderedSet<Cop *> *)values;

- (void)insertObject:(Photo *)value inPhotosAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPhotosAtIndex:(NSUInteger)idx;
- (void)insertPhotos:(NSArray<Photo *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePhotosAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPhotosAtIndex:(NSUInteger)idx withObject:(Photo *)value;
- (void)replacePhotosAtIndexes:(NSIndexSet *)indexes withPhotos:(NSArray<Photo *> *)values;
- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSOrderedSet<Photo *> *)values;
- (void)removePhotos:(NSOrderedSet<Photo *> *)values;

- (void)insertObject:(Photo *)value inCdiPhotosAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCdiPhotosAtIndex:(NSUInteger)idx;
- (void)insertCdiPhotos:(NSArray<Photo *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCdiPhotosAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCdiPhotosAtIndex:(NSUInteger)idx withObject:(Photo *)value;
- (void)replaceCdiPhotosAtIndexes:(NSIndexSet *)indexes withCdiPhotos:(NSArray<Photo *> *)values;
- (void)addCdiPhotosObject:(Photo *)value;
- (void)removeCdiPhotosObject:(Photo *)value;
- (void)addCdiPhotos:(NSOrderedSet<Photo *> *)values;
- (void)removeCdiPhotos:(NSOrderedSet<Photo *> *)values;

- (void)insertObject:(Photo *)value inSpiPhotosAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSpiPhotosAtIndex:(NSUInteger)idx;
- (void)insertSpiPhotos:(NSArray<Photo *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSpiPhotosAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSpiPhotosAtIndex:(NSUInteger)idx withObject:(Photo *)value;
- (void)replaceSpiPhotosAtIndexes:(NSIndexSet *)indexes withSpiPhotos:(NSArray<Photo *> *)values;
- (void)addSpiPhotosObject:(Photo *)value;
- (void)removeSpiPhotosObject:(Photo *)value;
- (void)addSpiPhotos:(NSOrderedSet<Photo *> *)values;
- (void)removeSpiPhotos:(NSOrderedSet<Photo *> *)values;

@end

NS_ASSUME_NONNULL_END
