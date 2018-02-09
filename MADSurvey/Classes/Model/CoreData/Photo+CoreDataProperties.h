//
//  Photo+CoreDataProperties.h
//  MADSurvey
//
//  Created by seniorcoder on 7/22/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "Photo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Photo (CoreDataProperties)

+ (NSFetchRequest<Photo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *fileName;
@property (nullable, nonatomic, copy) NSString *fileURL;
@property (nullable, nonatomic, retain) Bank *bank;
@property (nullable, nonatomic, retain) Car *car;
@property (nullable, nonatomic, retain) Cop *cop;
@property (nullable, nonatomic, retain) HallEntrance *hallEntrance;
@property (nullable, nonatomic, retain) HallStation *hallStation;
@property (nullable, nonatomic, retain) InteriorCar *interiorCar;
@property (nullable, nonatomic, retain) Lantern *lantern;
@property (nullable, nonatomic, retain) Lobby *lobby;
@property (nullable, nonatomic, retain) Project *project;
@property (nullable, nonatomic, retain) Car *cdiCar;
@property (nullable, nonatomic, retain) Car *spiCar;

@end

NS_ASSUME_NONNULL_END
