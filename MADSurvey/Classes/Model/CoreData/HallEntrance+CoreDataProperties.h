//
//  HallEntrance+CoreDataProperties.h
//  MADSurvey
//
//  Created by seniorcoder on 7/22/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallEntrance+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface HallEntrance (CoreDataProperties)

+ (NSFetchRequest<HallEntrance *> *)fetchRequest;

@property (nonatomic) int32_t carNum;
@property (nonatomic) int32_t direction;
@property (nonatomic) int32_t doorType;
@property (nullable, nonatomic, copy) NSString *floorDescription;
@property (nonatomic) int32_t floorNum;
@property (nonatomic) double height;
@property (nonatomic) double leftSideA;
@property (nonatomic) double leftSideB;
@property (nonatomic) double leftSideC;
@property (nonatomic) double leftSideD;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nonatomic) double rightSideA;
@property (nonatomic) double rightSideB;
@property (nonatomic) double rightSideC;
@property (nonatomic) double rightSideD;
@property (nonatomic) double transomMeasurementsA;
@property (nonatomic) double transomMeasurementsB;
@property (nonatomic) double transomMeasurementsC;
@property (nonatomic) double transomMeasurementsD;
@property (nonatomic) double transomMeasurementsE;
@property (nonatomic) double transomMeasurementsF;
@property (nonatomic) double transomMeasurementsG;
@property (nonatomic) double transomMeasurementsH;
@property (nonatomic) double transomMeasurementsI;
@property (nullable, nonatomic, retain) Bank *bank;
@property (nullable, nonatomic, retain) NSOrderedSet<Photo *> *photos;

@end

@interface HallEntrance (CoreDataGeneratedAccessors)

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
