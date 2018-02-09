//
//  HallStation+CoreDataProperties.h
//  MADSurvey
//
//  Created by seniorcoder on 7/22/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallStation+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface HallStation (CoreDataProperties)

+ (NSFetchRequest<HallStation *> *)fetchRequest;

@property (nonatomic) double affValue;
@property (nullable, nonatomic, copy) NSString *floorNumber;
@property (nullable, nonatomic, copy) NSString *hallStationDescription;
@property (nonatomic) int32_t hallStationNum;
@property (nonatomic) double height;
@property (nullable, nonatomic, copy) NSString *mount;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nullable, nonatomic, copy) NSString *sameAs;
@property (nonatomic) double screwCenterHeight;
@property (nonatomic) double screwCenterWidth;
@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, copy) NSString *wallFinish;
@property (nonatomic) double width;
@property (nullable, nonatomic, retain) Bank *bank;
@property (nullable, nonatomic, retain) NSOrderedSet<Photo *> *photos;

@end

@interface HallStation (CoreDataGeneratedAccessors)

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
