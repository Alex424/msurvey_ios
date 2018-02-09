//
//  Cop+CoreDataProperties.h
//  MADSurvey
//
//  Created by seniorcoder on 7/22/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "Cop+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Cop (CoreDataProperties)

+ (NSFetchRequest<Cop *> *)fetchRequest;

@property (nonatomic) int32_t carNum;
@property (nullable, nonatomic, copy) NSString *copName;
@property (nonatomic) int32_t copNum;
@property (nonatomic) double coverAff;
@property (nonatomic) double coverHeight;
@property (nonatomic) double coverToOpening;
@property (nonatomic) double coverWidth;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nullable, nonatomic, copy) NSString *options;
@property (nullable, nonatomic, copy) NSString *returnHinging;
@property (nonatomic) double returnPanelHeight;
@property (nonatomic) double returnPanelWidth;
@property (nonatomic) double swingPanelHeight;
@property (nonatomic) double swingPanelWidth;
@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, retain) Car *car;
@property (nullable, nonatomic, retain) NSOrderedSet<Photo *> *photos;

@end

@interface Cop (CoreDataGeneratedAccessors)

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
