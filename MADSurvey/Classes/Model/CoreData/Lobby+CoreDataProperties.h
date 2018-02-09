//
//  Lobby+CoreDataProperties.h
//  MADSurvey
//
//  Created by seniorcoder on 7/22/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "Lobby+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Lobby (CoreDataProperties)

+ (NSFetchRequest<Lobby *> *)fetchRequest;

@property (nonatomic) int32_t lobbyNum;
@property (nullable, nonatomic, copy) NSString *location;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nonatomic) double panelHeight;
@property (nonatomic) double panelWidth;
@property (nonatomic) double screwCenterHeight;
@property (nonatomic) double screwCenterWidth;
@property (nullable, nonatomic, copy) NSString *specialCommunicationOption;
@property (nullable, nonatomic, copy) NSString *specialFeature;
@property (nonatomic) int32_t visibility;
@property (nullable, nonatomic, retain) NSOrderedSet<Photo *> *photos;
@property (nullable, nonatomic, retain) Project *project;

@end

@interface Lobby (CoreDataGeneratedAccessors)

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
