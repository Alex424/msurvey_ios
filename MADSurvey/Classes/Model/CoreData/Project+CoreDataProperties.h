//
//  Project+CoreDataProperties.h
//  MADSurvey
//
//  Created by seniorcoder on 7/24/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "Project+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Project (CoreDataProperties)

+ (NSFetchRequest<Project *> *)fetchRequest;

@property (nonatomic) int32_t cabInteriors;
@property (nullable, nonatomic, copy) NSString *companyContact;
@property (nullable, nonatomic, copy) NSString *companyName;
@property (nonatomic) int32_t cops;
@property (nonatomic) int32_t hallEntrances;
@property (nonatomic) int64_t hallLanterns;
@property (nonatomic) int32_t hallStations;
@property (nonatomic) int32_t id;
@property (nonatomic) int32_t jobType;
@property (nonatomic) int32_t lobbyPanels;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int32_t no;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nonatomic) int32_t numBanks;
@property (nonatomic) int32_t numFloors;
@property (nonatomic) int32_t numLobbyPanels;
@property (nullable, nonatomic, copy) NSString *scaleUnit;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *surveyDate;
@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, copy) NSString *submitTime;
@property (nullable, nonatomic, retain) NSOrderedSet<Bank *> *banks;
@property (nullable, nonatomic, retain) NSOrderedSet<Lobby *> *lobbies;
@property (nullable, nonatomic, retain) NSOrderedSet<Photo *> *photos;

@end

@interface Project (CoreDataGeneratedAccessors)

- (void)insertObject:(Bank *)value inBanksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBanksAtIndex:(NSUInteger)idx;
- (void)insertBanks:(NSArray<Bank *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBanksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBanksAtIndex:(NSUInteger)idx withObject:(Bank *)value;
- (void)replaceBanksAtIndexes:(NSIndexSet *)indexes withBanks:(NSArray<Bank *> *)values;
- (void)addBanksObject:(Bank *)value;
- (void)removeBanksObject:(Bank *)value;
- (void)addBanks:(NSOrderedSet<Bank *> *)values;
- (void)removeBanks:(NSOrderedSet<Bank *> *)values;

- (void)insertObject:(Lobby *)value inLobbiesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLobbiesAtIndex:(NSUInteger)idx;
- (void)insertLobbies:(NSArray<Lobby *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLobbiesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLobbiesAtIndex:(NSUInteger)idx withObject:(Lobby *)value;
- (void)replaceLobbiesAtIndexes:(NSIndexSet *)indexes withLobbies:(NSArray<Lobby *> *)values;
- (void)addLobbiesObject:(Lobby *)value;
- (void)removeLobbiesObject:(Lobby *)value;
- (void)addLobbies:(NSOrderedSet<Lobby *> *)values;
- (void)removeLobbies:(NSOrderedSet<Lobby *> *)values;

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
