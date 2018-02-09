//
//  InteriorCar+CoreDataProperties.h
//  MADSurvey
//
//  Created by seniorcoder on 7/22/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCar+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface InteriorCar (CoreDataProperties)

+ (NSFetchRequest<InteriorCar *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *birdCage;
@property (nonatomic) double carCapacity;
@property (nullable, nonatomic, copy) NSString *carDescription;
@property (nonatomic) double carFloorHeight;
@property (nullable, nonatomic, copy) NSString *carFlooring;
@property (nonatomic) int32_t carTiller;
@property (nonatomic) double carWeight;
@property (nonatomic) double escapeHatchLength;
@property (nullable, nonatomic, copy) NSString *escapeHatchLocation;
@property (nonatomic) double escapeHatchToBackWall;
@property (nonatomic) double escapeHatchToLeftWall;
@property (nonatomic) double escapeHatchWidth;
@property (nullable, nonatomic, copy) NSString *exhaustFanLocation;
@property (nonatomic) double exhaustLength;
@property (nonatomic) double exhaustToBackWall;
@property (nonatomic) double exhaustToLeftWall;
@property (nonatomic) double exhaustWidth;
@property (nullable, nonatomic, copy) NSString *installNumber;
@property (nonatomic) int32_t interiorCarNum;
@property (nonatomic) int32_t isThereBackDoor;
@property (nonatomic) int32_t isThereExhaustFan;
@property (nullable, nonatomic, copy) NSString *mount;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nonatomic) int32_t numberOfPeople;
@property (nonatomic) double rearWallHeight;
@property (nonatomic) double rearWallWidth;
@property (nullable, nonatomic, copy) NSString *typeOfCar;
@property (nullable, nonatomic, copy) NSString *typeOfCeilingFrame;
@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, copy) NSString *weightScale;
@property (nullable, nonatomic, retain) InteriorCarDoor *backDoor;
@property (nullable, nonatomic, retain) Bank *bank;
@property (nullable, nonatomic, retain) InteriorCarDoor *frontDoor;
@property (nullable, nonatomic, retain) NSOrderedSet<Photo *> *photos;

@end

@interface InteriorCar (CoreDataGeneratedAccessors)

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

@end

NS_ASSUME_NONNULL_END
