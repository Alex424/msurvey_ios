//
//  DataManager.h
//  MADSurvey
//
//  Created by seniorcoder on 6/30/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Project+CoreDataClass.h"
#import "Bank+CoreDataClass.h"
#import "Lobby+CoreDataClass.h"
#import "HallStation+CoreDataClass.h"
#import "Lantern+CoreDataClass.h"
#import "HallEntrance+CoreDataClass.h"
#import "Car+CoreDataClass.h"
#import "Cop+CoreDataClass.h"
#import "InteriorCar+CoreDataClass.h"
#import "InteriorCarDoor+CoreDataClass.h"
#import "Photo+CoreDataClass.h"
#import "NSString+Double.h"

typedef enum {
    None,
    AddingHallStation,
    AddingLantern,
    AddingCar,
    AddingInteriorCar,
    AddingHallEntrance,
} AddingItemType;

@interface DataManager : NSObject

@property (nonatomic, strong) NSMutableArray *projects;
@property (nonatomic, strong) Project *selectedProject;

@property (nonatomic, assign) NSInteger currentLobbyIndex;
@property (nonatomic, assign) NSInteger currentBankIndex;

@property (nonatomic, assign) NSInteger currentFloorNum;
@property (nonatomic, strong) NSString *floorDescription;

@property (nonatomic, assign) NSInteger currentHallEntranceCarNum;

@property (nonatomic, assign) NSInteger currentHallStationNum;
@property (nonatomic, strong) HallStation *currentHallStation;

@property (nonatomic, assign) NSInteger currentLanternNum;
@property (nonatomic, assign) NSInteger lanternCount;
@property (nonatomic, strong) Lantern *currentLantern;

@property (nonatomic, assign) NSInteger currentCarNum;
@property (nonatomic, strong) Car *currentCar;

@property (nonatomic, assign) NSInteger currentCopNum;
@property (nonatomic, strong) Cop *currentCop;

@property (nonatomic, assign) NSInteger currentInteriorCarNum;
@property (nonatomic, strong) InteriorCar *currentInteriorCar;

@property (nonatomic, assign) NSInteger currentDoorStyle;
@property (nonatomic, assign) NSInteger currentCenterOpening;
@property (nonatomic, assign) NSInteger currentDoorType;
@property (nonatomic, strong) InteriorCarDoor *currentInteriorCarDoor;

@property (nonatomic, assign) BOOL needToGoBack;

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) AddingItemType addingType;

@property (nonatomic, assign) BOOL needInstruction;

+ (instancetype)sharedManager;

- (void)saveChanges;
- (void)revertChanges;

/* Project */
- (NSMutableArray *)loadProjects;
- (Project *)createNewProject;
- (void)deleteProject:(Project *)project;
- (BOOL)checkDuplicateProjectNo:(NSInteger)projectNo;
- (NSDictionary *)getPostJSONForProject:(Project *)project;

/* Lobby */
- (Lobby *)createNewLobbyForProject:(Project *)project;
- (void)deleteLobby:(Lobby *)lobby;

/* Bank */
- (Bank *)createNewBankForProject:(Project *)project;
- (void)deleteBank:(Bank *)bank;

- (NSArray *)floorNumbersForHallStations:(Bank *)bank;
- (NSArray *)floorNumbersForLanterns:(Bank *)bank;
- (NSArray *)floorNumbersForHallEntrances:(Bank *)bank;

/* Hall Entrance */
- (NSArray *)getAllHallEntrancesForProject:(Project *)project;
- (NSInteger)getHallEntranceCountForProject:(Project *)project;
- (NSInteger)getMaxHallEntranceCarNumForBank:(Bank *)bank floorNumber:(NSString *)floorNumber;
- (HallEntrance *)createNewHallEntranceForBank:(Bank *)bank;
- (HallEntrance *)getHallEntranceForBank:(Bank *)bank floorDescription:(NSString *)floorDescription hallEntranceCarNum:(NSInteger)hallEntranceCarNum;
- (void)deleteHallEntrance:(HallEntrance *)hallEntrance;
- (HallEntrance *)createNewHallEntranceForBank:(Bank *)bank sameAs:(HallEntrance *)sameAs;

/* Hall Station */
- (NSArray *)getAllHallStationsForProject:(Project *)project;
- (NSInteger)getHallStationCountForProject:(Project *)project;
- (NSInteger)getMaxHallStationNumForBank:(Bank *)bank floorNumber:(NSString *)floorNumber;
- (HallStation *)createNewHallStationForBank:(Bank *)bank;
- (HallStation *)createNewHallStationForBank:(Bank *)bank sameAs:(HallStation *)sameAs;
- (HallStation *)getHallStationForBank:(Bank *)bank hallStationNum:(NSInteger)hallStationNum floorNumber:(NSString *)floorNumber;
- (void)deleteHallStation:(HallStation *)hallStation;

/* Lantern */
- (NSArray *)getAllLanternsForProject:(Project *)project;
- (NSInteger)getLanternCountForProject:(Project *)project;
- (NSInteger)getLanternCountPerFloor:(Bank *)bank floorNumber:(NSString *)floorNumber;
- (NSInteger)getMaxLanternNumForBank:(Bank *)bank floorNumber:(NSString *)floorNumber;
- (Lantern *)createNewLanternForBank:(Bank *)bank lanternNum:(NSInteger)lanternNum floorNumber:(NSString *)floorNumber;
- (Lantern *)createNewLanternForBank:(Bank *)bank sameAs:(Lantern *)sameAs;
- (Lantern *)getLanternForBank:(Bank *)bank lanternNum:(NSInteger)lanternNum floorNumber:(NSString *)floorNumber;
- (void)deleteLantern:(Lantern *)lantern;

/* Car */
- (NSArray *)getAllCarsForProject:(Project *)project;
- (NSInteger)getCarCountForProject:(Project *)project;
- (NSInteger)getMaxCarNumForBank:(Bank *)bank;
- (Car *)createNewCarForBank:(Bank *)bank carNum:(NSInteger)carNum carNumber:(NSString *)carNumber;
- (Car *)getCarForBank:(Bank *)bank carNum:(NSInteger)carNum;
- (void)deleteCar:(Car *)car;

/* Cop */
- (NSInteger)getCopCountForProject:(Project *)project;
- (Cop *)createNewCopForCar:(Car *)car copNum:(NSInteger)copNum copName:(NSString *)copName;
- (Cop *)getCopForCar:(Car *)car copNum:(NSInteger)copNum;
- (void)deleteCop:(Cop *)cop;

/* Interior Car */
- (NSArray *)getAllInteriorCarsForProject:(Project *)project;
- (NSInteger)getInteriorCarCountForProject:(Project *)project;
- (NSInteger)getMaxInteriorCarNumForBank:(Bank *)bank;
- (InteriorCar *)createNewInteriorCarForBank:(Bank *)bank interiorCarNum:(NSInteger)interiorCarNum interiorCarDescription:(NSString *)interiorCarDescription;
- (InteriorCar *)getInteriorCarForBank:(Bank *)bank interiorCarNum:(NSInteger)interiorCarNum;
- (void)deleteInteriorCar:(InteriorCar *)interiorCar;
- (void)copyInteriorCar:(InteriorCar *)srcCar to:(InteriorCar *)dstCar;

/* Interior Car Door */
- (InteriorCarDoor *)createNewInteriorCarDoorForCar:(InteriorCar *)interiorCar doorStyle:(NSInteger)doorStyle;
- (InteriorCarDoor *)copyFrontToBackDoor:(InteriorCarDoor *)door;
- (void)deleteInteriorCarDoor:(InteriorCarDoor *)door;

/* Photo */
- (NSArray *)getAllPhotosForProject:(Project *)project;
- (Photo *)createNewPhotoWithImage:(UIImage *)image;
- (Photo *)updatePhoto:(Photo *)photo withImage:(UIImage *)image;
- (void)deletePhoto:(Photo *)photo;

@end
