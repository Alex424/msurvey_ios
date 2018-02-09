//
//  Bank+CoreDataProperties.h
//  MADSurvey
//
//  Created by seniorcoder on 7/22/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "Bank+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Bank (CoreDataProperties)

+ (NSFetchRequest<Bank *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bankDescription;
@property (nonatomic) int32_t bankNum;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nonatomic) int32_t numOfCar;
@property (nonatomic) int32_t numOfElevator;
@property (nonatomic) int32_t numOfInteriorCar;
@property (nonatomic) int32_t numOfRiser;
@property (nullable, nonatomic, retain) NSOrderedSet<Car *> *cars;
@property (nullable, nonatomic, retain) NSOrderedSet<HallEntrance *> *hallEntrances;
@property (nullable, nonatomic, retain) NSOrderedSet<HallStation *> *hallStations;
@property (nullable, nonatomic, retain) NSOrderedSet<InteriorCar *> *interiorCars;
@property (nullable, nonatomic, retain) NSOrderedSet<Lantern *> *lanterns;
@property (nullable, nonatomic, retain) NSOrderedSet<Photo *> *photos;
@property (nullable, nonatomic, retain) Project *project;

@end

@interface Bank (CoreDataGeneratedAccessors)

- (void)insertObject:(Car *)value inCarsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCarsAtIndex:(NSUInteger)idx;
- (void)insertCars:(NSArray<Car *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCarsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCarsAtIndex:(NSUInteger)idx withObject:(Car *)value;
- (void)replaceCarsAtIndexes:(NSIndexSet *)indexes withCars:(NSArray<Car *> *)values;
- (void)addCarsObject:(Car *)value;
- (void)removeCarsObject:(Car *)value;
- (void)addCars:(NSOrderedSet<Car *> *)values;
- (void)removeCars:(NSOrderedSet<Car *> *)values;

- (void)insertObject:(HallEntrance *)value inHallEntrancesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromHallEntrancesAtIndex:(NSUInteger)idx;
- (void)insertHallEntrances:(NSArray<HallEntrance *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeHallEntrancesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInHallEntrancesAtIndex:(NSUInteger)idx withObject:(HallEntrance *)value;
- (void)replaceHallEntrancesAtIndexes:(NSIndexSet *)indexes withHallEntrances:(NSArray<HallEntrance *> *)values;
- (void)addHallEntrancesObject:(HallEntrance *)value;
- (void)removeHallEntrancesObject:(HallEntrance *)value;
- (void)addHallEntrances:(NSOrderedSet<HallEntrance *> *)values;
- (void)removeHallEntrances:(NSOrderedSet<HallEntrance *> *)values;

- (void)insertObject:(HallStation *)value inHallStationsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromHallStationsAtIndex:(NSUInteger)idx;
- (void)insertHallStations:(NSArray<HallStation *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeHallStationsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInHallStationsAtIndex:(NSUInteger)idx withObject:(HallStation *)value;
- (void)replaceHallStationsAtIndexes:(NSIndexSet *)indexes withHallStations:(NSArray<HallStation *> *)values;
- (void)addHallStationsObject:(HallStation *)value;
- (void)removeHallStationsObject:(HallStation *)value;
- (void)addHallStations:(NSOrderedSet<HallStation *> *)values;
- (void)removeHallStations:(NSOrderedSet<HallStation *> *)values;

- (void)insertObject:(InteriorCar *)value inInteriorCarsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromInteriorCarsAtIndex:(NSUInteger)idx;
- (void)insertInteriorCars:(NSArray<InteriorCar *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeInteriorCarsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInInteriorCarsAtIndex:(NSUInteger)idx withObject:(InteriorCar *)value;
- (void)replaceInteriorCarsAtIndexes:(NSIndexSet *)indexes withInteriorCars:(NSArray<InteriorCar *> *)values;
- (void)addInteriorCarsObject:(InteriorCar *)value;
- (void)removeInteriorCarsObject:(InteriorCar *)value;
- (void)addInteriorCars:(NSOrderedSet<InteriorCar *> *)values;
- (void)removeInteriorCars:(NSOrderedSet<InteriorCar *> *)values;

- (void)insertObject:(Lantern *)value inLanternsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLanternsAtIndex:(NSUInteger)idx;
- (void)insertLanterns:(NSArray<Lantern *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLanternsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLanternsAtIndex:(NSUInteger)idx withObject:(Lantern *)value;
- (void)replaceLanternsAtIndexes:(NSIndexSet *)indexes withLanterns:(NSArray<Lantern *> *)values;
- (void)addLanternsObject:(Lantern *)value;
- (void)removeLanternsObject:(Lantern *)value;
- (void)addLanterns:(NSOrderedSet<Lantern *> *)values;
- (void)removeLanterns:(NSOrderedSet<Lantern *> *)values;

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
