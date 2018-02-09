//
//  DataManager.m
//  MADSurvey
//
//  Created by seniorcoder on 6/30/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "DataManager.h"
#import "AppDelegate.h"
#import "Common.h"
#import "Constants.h"

#define NONNULL(x)      (x ? x : @"")
#define NONNEGATIVE(x)  (x < 0 ? @"" : @(x))

@implementation DataManager

+ (instancetype)sharedManager {
    static DataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [DataManager new];
    });
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.projects = [self loadProjects];
    }
    
    return self;
}


- (void)saveChanges {
    [[AppDelegate sharedDeleate] saveContext];
}

- (void)revertChanges {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    [context rollback];
}


#pragma mark Project
    
- (NSMutableArray *)loadProjects {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Project"];
    NSError *requestError = nil;
    NSArray *projects = [context executeFetchRequest:fetchRequest error:&requestError];
    
    return [projects mutableCopy];
}

- (Project *)createNewProject {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Project"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO];
    fetchRequest.sortDescriptors = @[sort];
    fetchRequest.fetchLimit = 1;
    NSArray *projects = [context executeFetchRequest:fetchRequest error:nil];
    
    Project *project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:context];
    project.uuid = [Common generateUUID];

    if (projects.count > 0) {
        Project *lastProject = [projects lastObject];
        project.id = lastProject.id + 1;
    } else {
        project.id = 1;
    }

    [self.projects addObject:project];
    
    return project;
}

- (void)deleteProject:(Project *)project {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    NSArray *banks = [project.banks array];
    for (Bank *bank in banks) {
        [self deleteBank:bank];
    }
    
    NSArray *lobbies = [project.lobbies array];
    for (Lobby *lobby in lobbies) {
        [self deleteLobby:lobby];
    }
    
    NSArray *photos = [project.photos array];
    for (Photo *photo in photos) {
        [self deletePhoto:photo];
    }

    [context deleteObject:project];

    [self.projects removeObject:project];
}

- (BOOL)checkDuplicateProjectNo:(NSInteger)projectNo {
    for (Project *project in self.projects) {
        if (project.no == projectNo) {
            return YES;
        }
    }
    
    return NO;
}

- (NSDictionary *)getPostJSONForProject:(Project *)project {
    NSString *model = [UIDevice currentDevice].model;
    NSMutableArray *summary = [NSMutableArray array];
    [summary addObject:@{@"name" : @"_version", @"value" : NONNULL([Common appVersion])}];
    [summary addObject:@{@"name" : @"_deviceModel", @"value" : NONNULL(model)}];
    [summary addObject:[NSNull null]];
    [summary addObject:@{@"name" : @"_mobilePlatform", @"value" : @"iOS"}];
    [summary addObject:@{@"name" : @"_osVersion", @"value" : [UIDevice currentDevice].systemVersion}];
    [summary addObject:@{@"name" : @"_uuid", @"value" : NONNULL(project.uuid)}];
    [summary addObject:@{@"name" : @"_scale_unit", @"value" : NONNULL(project.scaleUnit)}];
    [summary addObject:@{@"name" : @"m_number", @"value" : @(project.no)}];
    [summary addObject:@{@"name" : @"project_name", @"value" : NONNULL(project.name)}];
    [summary addObject:@{@"name" : @"project_company", @"value" : NONNULL(project.companyName)}];
    [summary addObject:@{@"name" : @"project_contact", @"value" : NONNULL(project.companyContact)}];
    [summary addObject:@{@"name" : @"project_date", @"value" : NONNULL(project.surveyDate)}];
    
    NSInteger index = 0;
    for (Photo *photo in project.photos) {
        [summary addObject:[self getPostJSONForPhoto:photo index:index++]];
    }
    
    NSMutableArray *lobbies = [NSMutableArray array];
    for (Lobby *lobby in project.lobbies) {
        [lobbies addObject:[self getPostJSONForLobby:lobby]];
    }
    
    NSMutableArray *banks = [NSMutableArray array];
    for (Bank *bank in project.banks) {
        [banks addObject:[self getPostJSONForBank:bank]];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    return @{@"project_id" : @(project.id),
             @"project_summary" : summary,
             @"submit_time" : [formatter stringFromDate:[NSDate date]],
             @"project_status" : NONNULL(project.status),
             @"panel_list" : lobbies,
             @"bank_list" : banks};
}

#pragma mark Lobby

- (Lobby *)createNewLobbyForProject:(Project *)project {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    Lobby *lobby = [NSEntityDescription insertNewObjectForEntityForName:@"Lobby" inManagedObjectContext:context];
    lobby.project = project;
    [project addLobbiesObject:lobby];
    
    return lobby;
}

- (void)deleteLobby:(Lobby *)lobby {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;

    NSArray *photos  = [lobby.photos array];
    for (Photo *photo in photos) {
        [self deletePhoto:photo];
    }
    
    lobby.project = nil;
    
    [context deleteObject:lobby];
}

- (NSArray *)getPostJSONForLobby:(Lobby *)lobby {
    NSMutableArray *json = [NSMutableArray array];
    
    [json addObject:@{@"name" : @"panel_location", @"value" : NONNULL(lobby.location)}];
    [json addObject:@{@"name" : @"elevator_visibility", @"value" : (lobby.visibility == LobbyElevatorsVisible) ? @"YES" : @"NO"}];
    [json addObject:@{@"name" : @"panel_width", @"value" : NONNEGATIVE(lobby.panelWidth)}];
    [json addObject:@{@"name" : @"panel_height", @"value" : NONNEGATIVE(lobby.panelHeight)}];
    [json addObject:@{@"name" : @"screw_center_width", @"value" : NONNEGATIVE(lobby.screwCenterWidth)}];
    [json addObject:@{@"name" : @"screw_center_height", @"value" : NONNEGATIVE(lobby.screwCenterHeight)}];
    [json addObject:@{@"name" : @"feature", @"value" : NONNULL(lobby.specialFeature)}];
    [json addObject:@{@"name" : @"integral_communication", @"value" : NONNULL(lobby.specialCommunicationOption)}];
    [json addObject:@{@"name" : @"notes", @"value" : NONNULL(lobby.notes)}];
    
    NSInteger index = 0;
    for (Photo *photo in lobby.photos) {
        [json addObject:[self getPostJSONForPhoto:photo index:index ++]];
    }
    
    return json;
}

#pragma mark Bank

- (Bank *)createNewBankForProject:(Project *)project {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    Bank *bank = [NSEntityDescription insertNewObjectForEntityForName:@"Bank" inManagedObjectContext:context];
    bank.project = project;
    [project addBanksObject:bank];
    
    return bank;
}

- (void)deleteBank:(Bank *)bank {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    NSArray *cars  = [bank.cars array];
    for (Car *car in cars) {
        [self deleteCar:car];
    }

    NSArray *hallEntrances  = [bank.hallEntrances array];
    for (HallEntrance *hallEntrance in hallEntrances) {
        [self deleteHallEntrance:hallEntrance];
    }

    NSArray *hallStations  = [bank.hallStations array];
    for (HallStation *hallStation in hallStations) {
        [self deleteHallStation:hallStation];
    }

    NSArray *interiorCars  = [bank.interiorCars array];
    for (InteriorCar *interiorCar in interiorCars) {
        [self deleteInteriorCar:interiorCar];
    }

    NSArray *lanterns  = [bank.lanterns array];
    for (Lantern *lantern in lanterns) {
        [self deleteLantern:lantern];
    }

    NSArray *photos  = [bank.photos array];
    for (Photo *photo in photos) {
        [self deletePhoto:photo];
    }
    
    bank.project = nil;

    [context deleteObject:bank];
}

- (NSDictionary *)getPostJSONForBank:(Bank *)bank {
    NSMutableArray *summary = [NSMutableArray array];
    
    [summary addObject:@{@"name" : @"bank_name", @"value" : NONNULL(bank.name)}];
    [summary addObject:@{@"name" : @"num_of_car", @"value" : @(bank.numOfCar)}];
    [summary addObject:@{@"name" : @"notes", @"value" : NONNULL(bank.notes)}];
    
    NSInteger index = 0;
    for (Photo *photo in bank.photos) {
        [summary addObject:[self getPostJSONForPhoto:photo index:index ++]];
    }
    
    NSMutableArray *hallsArray = [NSMutableArray array];
    for (HallStation *hallStation in bank.hallStations) {
        [hallsArray addObject:[self getPostJSONForHallStation:hallStation]];
    }
    
    NSMutableArray *lanternsArray = [NSMutableArray array];
    for (Lantern *lantern in bank.lanterns) {
        [lanternsArray addObject:[self getPostJSONForLantern:lantern]];
    }
    
    NSMutableArray *carsArray = [NSMutableArray array];
    for (Car *car in bank.cars) {
        [carsArray addObject:[self getPostJSONForCar:car]];
    }
    
    NSMutableArray *cabsArray = [NSMutableArray array];
    for (InteriorCar *cab in bank.interiorCars) {
        [cabsArray addObject:[self getPostJSONForInteriorCar:cab]];
    }
    
    NSMutableArray *entrancesArray = [NSMutableArray array];
    for (HallEntrance *entrance in bank.hallEntrances) {
        [entrancesArray addObject:[self getPostJSONForHallEntrance:entrance]];
    }
    
    return @{@"bank_summary" : summary,
             @"hallstation_list" : hallsArray,
             @"lanternpi_list" : lanternsArray,
             @"car_list" : carsArray,
             @"cab_interior_list" : cabsArray,
             @"hall_entrance_list" : entrancesArray};
}


- (NSArray *)floorNumbersForHallStations:(Bank *)bank {
    NSMutableArray *floors = [NSMutableArray array];

    for (HallStation *hallStation in bank.hallStations) {
        [floors addObject:hallStation.floorNumber];
    }
    
    return floors;
}

- (NSArray *)floorNumbersForLanterns:(Bank *)bank {
    NSMutableArray *floors = [NSMutableArray array];
    
    for (Lantern *lantern in bank.lanterns) {
        [floors addObject:lantern.floorNumber];
    }
    
    return floors;
}

- (NSArray *)floorNumbersForHallEntrances:(Bank *)bank {
    NSMutableArray *floors = [NSMutableArray array];
    
    for (HallEntrance *hallEntrance in bank.hallEntrances) {
        if (hallEntrance.floorDescription &&
            ![floors containsObject:hallEntrance.floorDescription]) {
            [floors addObject:hallEntrance.floorDescription];
        }
    }
    
    return floors;
}

#pragma mark Hall Entrance

- (NSArray *)getAllHallEntrancesForProject:(Project *)project {
    NSMutableArray *array = [NSMutableArray array];
    
    for (Bank *bank in project.banks) {
        [array addObjectsFromArray:[bank.hallEntrances array]];
    }
    
    return array;
}

- (NSInteger)getHallEntranceCountForProject:(Project *)project {
    NSInteger count = 0;
    for (Bank *bank in project.banks) {
        count += bank.hallEntrances.count;
    }
    return count;
}

- (NSInteger)getMaxHallEntranceCarNumForBank:(Bank *)bank floorNumber:(NSString *)floorNumber {
    NSInteger max = -1;
    for (HallEntrance *entrance in bank.hallEntrances) {
        if ([entrance.floorDescription isEqualToString:floorNumber]) {
            max = MAX(max, entrance.carNum);
        }
    }
    return max;
}

- (HallEntrance *)createNewHallEntranceForBank:(Bank *)bank {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    HallEntrance *hallEntrance = [NSEntityDescription insertNewObjectForEntityForName:@"HallEntrance" inManagedObjectContext:context];
    hallEntrance.floorNum = (int32_t)self.currentFloorNum;
    hallEntrance.floorDescription = self.floorDescription;
    hallEntrance.carNum = (int32_t)self.currentHallEntranceCarNum;

    hallEntrance.bank = bank;
    [bank addHallEntrancesObject:hallEntrance];
    
    return hallEntrance;
}

- (HallEntrance *)getHallEntranceForBank:(Bank *)bank floorDescription:(NSString *)floorDescription hallEntranceCarNum:(NSInteger)hallEntranceCarNum {
    for (HallEntrance *hallEntrance in bank.hallEntrances) {
        if ([hallEntrance.floorDescription isEqualToString:floorDescription] && hallEntrance.carNum == hallEntranceCarNum) {
            return hallEntrance;
        }
    }
    
    return nil;
}

- (void)deleteHallEntrance:(HallEntrance *)hallEntrance {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    NSArray *photos  = [hallEntrance.photos array];
    for (Photo *photo in photos) {
        [self deletePhoto:photo];
    }
    
    hallEntrance.bank = nil;
    
    [context deleteObject:hallEntrance];
}

- (HallEntrance *)createNewHallEntranceForBank:(Bank *)bank sameAs:(HallEntrance *)sameAs {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    HallEntrance *hallEntrance = [NSEntityDescription insertNewObjectForEntityForName:@"HallEntrance" inManagedObjectContext:context];
    hallEntrance.floorNum = (int32_t)self.currentFloorNum;
    hallEntrance.floorDescription = self.floorDescription;
    hallEntrance.carNum = (int32_t)self.currentHallEntranceCarNum;

    hallEntrance.bank = bank;
    [bank addHallEntrancesObject:hallEntrance];
    
    if (sameAs) {
        hallEntrance.doorType = sameAs.doorType;
        hallEntrance.direction = sameAs.direction;
        hallEntrance.leftSideA = sameAs.leftSideA;
        hallEntrance.leftSideB = sameAs.leftSideB;
        hallEntrance.leftSideC = sameAs.leftSideC;
        hallEntrance.leftSideD = sameAs.leftSideD;
        hallEntrance.rightSideA = sameAs.rightSideA;
        hallEntrance.rightSideB = sameAs.rightSideB;
        hallEntrance.rightSideC = sameAs.rightSideC;
        hallEntrance.rightSideD = sameAs.rightSideD;
        hallEntrance.height = sameAs.height;
        hallEntrance.transomMeasurementsA = sameAs.transomMeasurementsA;
        hallEntrance.transomMeasurementsB = sameAs.transomMeasurementsB;
        hallEntrance.transomMeasurementsC = sameAs.transomMeasurementsC;
        hallEntrance.transomMeasurementsD = sameAs.transomMeasurementsD;
        hallEntrance.transomMeasurementsE = sameAs.transomMeasurementsE;
        hallEntrance.transomMeasurementsF = sameAs.transomMeasurementsF;
        hallEntrance.transomMeasurementsG = sameAs.transomMeasurementsG;
        hallEntrance.transomMeasurementsH = sameAs.transomMeasurementsH;
        hallEntrance.transomMeasurementsI = sameAs.transomMeasurementsI;
    }
    
    return hallEntrance;
}

- (NSArray *)getPostJSONForHallEntrance:(HallEntrance *)hallEntrance {
    NSMutableArray *json = [NSMutableArray array];
    
    [json addObject:@{@"name" : @"floor_number", @"value" : NONNULL(hallEntrance.floorDescription)}];
    switch (hallEntrance.doorType) {
        case 3:
            [json addObject:@{@"name" : @"door_type", @"value" : @"Center"}];
            break;
        case 2:
            [json addObject:@{@"name" : @"door_type", @"value" : @"Single Speed"}];
            break;
        case 1:
            [json addObject:@{@"name" : @"door_type", @"value" : @"Two Speed"}];
            break;
        default:
            [json addObject:@{@"name" : @"door_type", @"value" : @""}];
            break;
    }
    switch (hallEntrance.direction) {
        case 1:
            [json addObject:@{@"name" : @"direction", @"value" : @"slides_open_to_left"}];
            break;
        case 2:
            [json addObject:@{@"name" : @"direction", @"value" : @"slides_open_to_right"}];
            break;
        default:
            [json addObject:@{@"name" : @"direction", @"value" : @""}];
            break;
    }
    [json addObject:@{@"name" : @"left_side_A", @"value" : NONNEGATIVE(hallEntrance.leftSideA)}];
    [json addObject:@{@"name" : @"left_side_B", @"value" : NONNEGATIVE(hallEntrance.leftSideB)}];
    [json addObject:@{@"name" : @"left_side_C", @"value" : NONNEGATIVE(hallEntrance.leftSideC)}];
    [json addObject:@{@"name" : @"left_side_D", @"value" : NONNEGATIVE(hallEntrance.leftSideD)}];
    [json addObject:@{@"name" : @"right_side_A", @"value" : NONNEGATIVE(hallEntrance.rightSideA)}];
    [json addObject:@{@"name" : @"right_side_B", @"value" : NONNEGATIVE(hallEntrance.rightSideB)}];
    [json addObject:@{@"name" : @"right_side_C", @"value" : NONNEGATIVE(hallEntrance.rightSideC)}];
    [json addObject:@{@"name" : @"right_side_D", @"value" : NONNEGATIVE(hallEntrance.rightSideD)}];
    [json addObject:@{@"name" : @"height", @"value" : NONNEGATIVE(hallEntrance.height)}];
    [json addObject:@{@"name" : @"transom_measurements_A", @"value" : NONNEGATIVE(hallEntrance.transomMeasurementsA)}];
    [json addObject:@{@"name" : @"transom_measurements_B", @"value" : NONNEGATIVE(hallEntrance.transomMeasurementsB)}];
    [json addObject:@{@"name" : @"transom_measurements_C", @"value" : NONNEGATIVE(hallEntrance.transomMeasurementsC)}];
    [json addObject:@{@"name" : @"transom_measurements_D", @"value" : NONNEGATIVE(hallEntrance.transomMeasurementsD)}];
    [json addObject:@{@"name" : @"transom_measurements_E", @"value" : NONNEGATIVE(hallEntrance.transomMeasurementsE)}];
    [json addObject:@{@"name" : @"transom_measurements_F", @"value" : NONNEGATIVE(hallEntrance.transomMeasurementsF)}];
    [json addObject:@{@"name" : @"transom_measurements_G", @"value" : NONNEGATIVE(hallEntrance.transomMeasurementsG)}];
    [json addObject:@{@"name" : @"transom_measurements_H", @"value" : hallEntrance.doorType != 2 ? NONNEGATIVE(hallEntrance.transomMeasurementsH) : @""}];
    [json addObject:@{@"name" : @"transom_measurements_I", @"value" : hallEntrance.doorType != 2 ? NONNEGATIVE(hallEntrance.transomMeasurementsI) : @""}];
    [json addObject:@{@"name" : @"notes", @"value" : NONNULL(hallEntrance.notes)}];
    
    NSInteger index = 0;
    for (Photo *photo in hallEntrance.photos) {
        [json addObject:[self getPostJSONForPhoto:photo index:index ++]];
    }

    return json;
}

#pragma mark Hall Station

- (NSArray *)getAllHallStationsForProject:(Project *)project {
    NSMutableArray *array = [NSMutableArray array];
    
    for (Bank *bank in project.banks) {
        [array addObjectsFromArray:[bank.hallStations array]];
    }
    
    return array;
}

- (NSInteger)getHallStationCountForProject:(Project *)project {
    NSInteger count = 0;
    for (Bank *bank in project.banks) {
        count += bank.hallStations.count;
    }
    return count;
}

- (NSInteger)getMaxHallStationNumForBank:(Bank *)bank floorNumber:(NSString *)floorNumber {
    NSInteger max = -1;
    for (HallStation *station in bank.hallStations) {
        if ([station.floorNumber isEqualToString:floorNumber]) {
            max = MAX(max, station.hallStationNum);
        }
    }
    return max;
}

- (HallStation *)createNewHallStationForBank:(Bank *)bank {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    HallStation *hallStation = [NSEntityDescription insertNewObjectForEntityForName:@"HallStation" inManagedObjectContext:context];
    
    hallStation.floorNumber = self.floorDescription;
    hallStation.hallStationNum = (int32_t)self.currentHallStationNum;
    hallStation.uuid = [Common generateUUID];
    hallStation.bank = bank;
    
    [bank addHallStationsObject:hallStation];

    return hallStation;
}

- (HallStation *)createNewHallStationForBank:(Bank *)bank sameAs:(HallStation *)sameAs {
    if (sameAs == nil) {
        sameAs = [bank.hallStations lastObject];
        if (sameAs == nil) {
            return nil;
        }
    }
    
    HallStation *existOne = [self getHallStationForBank:bank hallStationNum:self.currentHallStationNum floorNumber:self.floorDescription];
    
    if (!existOne) {
        HallStation *hallStation = [self createNewHallStationForBank:bank];
        
        hallStation.affValue = sameAs.affValue;
        hallStation.hallStationDescription = sameAs.hallStationDescription;
        hallStation.height = sameAs.height;
        hallStation.mount = sameAs.mount;
        hallStation.notes = @"";
        hallStation.sameAs = sameAs.uuid;
        hallStation.screwCenterHeight = sameAs.screwCenterWidth;
        hallStation.screwCenterWidth = sameAs.screwCenterHeight;
        hallStation.wallFinish = sameAs.wallFinish;
        hallStation.width = sameAs.width;
        hallStation.hallStationNum = (int32_t)self.currentHallStationNum;
        hallStation.floorNumber = self.floorDescription;
        
        return hallStation;
    } else {
        existOne.affValue = sameAs.affValue;
        existOne.hallStationDescription = sameAs.hallStationDescription;
        existOne.height = sameAs.height;
        existOne.mount = sameAs.mount;
        existOne.notes = @"";
        existOne.sameAs = sameAs.uuid;
        existOne.screwCenterHeight = sameAs.screwCenterHeight;
        existOne.screwCenterWidth = sameAs.screwCenterWidth;
        existOne.uuid = [Common generateUUID];
        existOne.wallFinish = sameAs.wallFinish;
        existOne.width = sameAs.width;
        existOne.bank = bank;
        
        return existOne;
    }
}

- (HallStation *)getHallStationForBank:(Bank *)bank hallStationNum:(NSInteger)hallStationNum floorNumber:(NSString *)floorNumber {
    for (HallStation *station in bank.hallStations) {
        if (station.hallStationNum == hallStationNum &&
            [station.floorNumber isEqualToString:floorNumber]) {
            return station;
        }
    }
    return nil;
}

- (void)deleteHallStation:(HallStation *)hallStation {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    NSArray *photos  = [hallStation.photos array];
    for (Photo *photo in photos) {
        [self deletePhoto:photo];
    }
    
    hallStation.bank = nil;
    
    [context deleteObject:hallStation];
}

- (NSArray *)getPostJSONForHallStation:(HallStation *)hallStation {
    NSMutableArray *json = [NSMutableArray array];
    
    [json addObject:@{@"name" : @"floor_number", @"value" : NONNULL(hallStation.floorNumber)}];
    [json addObject:@{@"name" : @"description", @"value" : NONNULL(hallStation.hallStationDescription)}];
    [json addObject:@{@"name" : @"mount", @"value" : NONNULL(hallStation.mount)}];
    [json addObject:@{@"name" : @"wall_finish", @"value" : NONNULL(hallStation.wallFinish)}];
    [json addObject:@{@"name" : @"width", @"value" : NONNEGATIVE(hallStation.width)}];
    [json addObject:@{@"name" : @"height", @"value" : NONNEGATIVE(hallStation.height)}];
    [json addObject:@{@"name" : @"screw_center_width", @"value" : NONNEGATIVE(hallStation.screwCenterWidth)}];
    [json addObject:@{@"name" : @"screw_center_height", @"value" : NONNEGATIVE(hallStation.screwCenterHeight)}];
    [json addObject:@{@"name" : @"bottom_of_plate_aff", @"value" : NONNEGATIVE(hallStation.affValue)}];
//    [json addObject:@{@"name" : @"uuid", @"value" : hallStation.uuid}];
//    [json addObject:@{@"name" : @"sameas", @"value" : hallStation.sameAs}];
    [json addObject:@{@"name" : @"notes", @"value" : NONNULL(hallStation.notes)}];
    
    NSInteger index = 0;
    for (Photo *photo in hallStation.photos) {
        [json addObject:[self getPostJSONForPhoto:photo index:index ++]];
    }
    
    return json;
}

#pragma mark - Lantern

- (NSArray *)getAllLanternsForProject:(Project *)project {
    NSMutableArray *array = [NSMutableArray array];
    
    for (Bank *bank in project.banks) {
        [array addObjectsFromArray:[bank.lanterns array]];
    }
    
    return array;
}

- (NSInteger)getLanternCountForProject:(Project *)project {
    NSInteger count = 0;
    for (Bank *bank in project.banks) {
        count += bank.lanterns.count;
    }
    return count;
}

- (NSInteger)getLanternCountPerFloor:(Bank *)bank floorNumber:(NSString *)floorNumber {
    NSMutableArray *lanterns = [NSMutableArray array];
    
    for (Lantern *lantern in bank.lanterns) {
        if ([lantern.floorNumber isEqualToString:floorNumber]) {
            [lanterns addObject:lantern];
        }
    }
    
    if (lanterns.count == 1) {
        Lantern *lantern = lanterns.firstObject;
        if (lantern.lanternNum == EmptyLanternRecordID) {
            return 0;
        }
    }
    
    return lanterns.count;
}

- (NSInteger)getMaxLanternNumForBank:(Bank *)bank floorNumber:(NSString *)floorNumber {
    NSInteger max = -1;
    for (Lantern *lantern in bank.lanterns) {
        if ([lantern.floorNumber isEqualToString:floorNumber]) {
            max = MAX(max, lantern.lanternNum);
        }
    }
    return max;
}

- (Lantern *)createNewLanternForBank:(Bank *)bank lanternNum:(NSInteger)lanternNum floorNumber:(NSString *)floorNumber {
    Lantern *lantern = [self getLanternForBank:bank lanternNum:lanternNum floorNumber:floorNumber];
    if (lantern) {
        return lantern;
    }
    
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    lantern = [NSEntityDescription insertNewObjectForEntityForName:@"Lantern" inManagedObjectContext:context];
    lantern.lanternNum = (int32_t)lanternNum;
    lantern.floorNumber = floorNumber;
    lantern.bank = bank;
    [bank addLanternsObject:lantern];
    
    return lantern;
}

- (Lantern *)createNewLanternForBank:(Bank *)bank sameAs:(Lantern *)sameAs {
    if (sameAs == nil) {
        sameAs = [bank.lanterns lastObject];
        if (sameAs == nil) {
            return nil;
        }
    }
    
    Lantern *existOne = [self getLanternForBank:bank lanternNum:self.currentLanternNum floorNumber:self.floorDescription];
    
    if (!existOne) {
        Lantern *lantern = [self createNewLanternForBank:bank lanternNum:self.currentLanternNum floorNumber:self.floorDescription];
        
        lantern.affValue = sameAs.affValue;
        lantern.depth = sameAs.depth;
        lantern.height = sameAs.height;
        lantern.lanternDescription = sameAs.lanternDescription;
        lantern.mount = sameAs.mount;
        lantern.notes = @"";
        lantern.quantity = sameAs.quantity;
        lantern.sameAs = sameAs.uuid;
        lantern.screwCenterHeight = sameAs.screwCenterHeight;
        lantern.screwCenterWidth = sameAs.screwCenterWidth;
        lantern.spaceAvailableHeight = sameAs.spaceAvailableHeight;
        lantern.spaceAvailableWidth = sameAs.spaceAvailableWidth;
        lantern.wallFinish = sameAs.wallFinish;
        lantern.width = sameAs.width;
        
        return lantern;
    } else {
        existOne.affValue = sameAs.affValue;
        existOne.depth = sameAs.depth;
        existOne.height = sameAs.height;
        existOne.lanternDescription = sameAs.lanternDescription;
        existOne.mount = sameAs.mount;
        existOne.notes = @"";
        existOne.quantity = sameAs.quantity;
        existOne.sameAs = sameAs.uuid;
        existOne.screwCenterHeight = sameAs.screwCenterHeight;
        existOne.screwCenterWidth = sameAs.screwCenterWidth;
        existOne.spaceAvailableHeight = sameAs.spaceAvailableHeight;
        existOne.spaceAvailableWidth = sameAs.spaceAvailableWidth;
        existOne.wallFinish = sameAs.wallFinish;
        existOne.width = sameAs.width;
        
        return existOne;
    }
}

- (Lantern *)getLanternForBank:(Bank *)bank lanternNum:(NSInteger)lanternNum floorNumber:(NSString *)floorNumber {
    for (Lantern *lantern in bank.lanterns) {
        if (lantern.lanternNum == lanternNum &&
            [floorNumber isEqualToString:lantern.floorNumber]) {
            return lantern;
        }
    }
    
    return nil;
}

- (void)deleteLantern:(Lantern *)lantern {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    NSArray *photos  = [lantern.photos array];
    for (Photo *photo in photos) {
        [self deletePhoto:photo];
    }
    
    lantern.bank = nil;
    
    [context deleteObject:lantern];
}

- (NSArray *)getPostJSONForLantern:(Lantern *)lantern {
    NSMutableArray *json = [NSMutableArray array];
    
    [json addObject:@{@"name" : @"floor_number", @"value" : NONNULL(lantern.floorNumber)}];
    [json addObject:@{@"name" : @"description", @"value" : NONNULL(lantern.lanternDescription)}];
    [json addObject:@{@"name" : @"mount", @"value" : NONNULL(lantern.mount)}];
    [json addObject:@{@"name" : @"wall_finish", @"value" : NONNULL(lantern.wallFinish)}];
    [json addObject:@{@"name" : @"width", @"value" : NONNEGATIVE(lantern.width)}];
    [json addObject:@{@"name" : @"height", @"value" : NONNEGATIVE(lantern.height)}];
    [json addObject:@{@"name" : @"depth", @"value" : NONNEGATIVE(lantern.depth)}];
    [json addObject:@{@"name" : @"screw_center_width", @"value" : NONNEGATIVE(lantern.screwCenterWidth)}];
    [json addObject:@{@"name" : @"screw_center_height", @"value" : NONNEGATIVE(lantern.screwCenterHeight)}];
    [json addObject:@{@"name" : @"space_available_width", @"value" : NONNEGATIVE(lantern.spaceAvailableWidth)}];
    [json addObject:@{@"name" : @"space_available_height", @"value" : NONNEGATIVE(lantern.spaceAvailableHeight)}];
//    [json addObject:@{@"name" : @"uuid", @"value" : lantern.uuid}];
//    [json addObject:@{@"name" : @"sameas", @"value" : lantern.sameAs}];
    [json addObject:@{@"name" : @"notes", @"value" : NONNULL(lantern.notes)}];
    
    NSInteger index = 0;
    for (Photo *photo in lantern.photos) {
        [json addObject:[self getPostJSONForPhoto:photo index:index ++]];
    }
    
    return json;
}

#pragma mark Car

- (NSArray *)getAllCarsForProject:(Project *)project {
    NSMutableArray *array = [NSMutableArray array];
    
    for (Bank *bank in project.banks) {
        [array addObjectsFromArray:[bank.cars array]];
    }
    
    return array;
}

- (NSInteger)getCarCountForProject:(Project *)project {
    NSInteger count = 0;
    for (Bank *bank in project.banks) {
        count += bank.cars.count;
    }
    return count;
}

- (NSInteger)getMaxCarNumForBank:(Bank *)bank {
    NSInteger max = -1;
    for (Car *car in bank.cars) {
        max = MAX(max, car.carNum);
    }
    return max;
}

- (Car *)createNewCarForBank:(Bank *)bank carNum:(NSInteger)carNum carNumber:(NSString *)carNumber {
    Car *car = [self getCarForBank:bank carNum:carNum];
    if (car) {
        car.carNumber = carNumber;
        return car;
    }
    
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    car = [NSEntityDescription insertNewObjectForEntityForName:@"Car" inManagedObjectContext:context];
    car.carNum = (int32_t)carNum;
    car.carNumber = carNumber;
    car.bank = bank;
    [bank addCarsObject:car];
    
    return car;
}

- (Car *)getCarForBank:(Bank *)bank carNum:(NSInteger)carNum {
    for (Car *car in bank.cars) {
        if (car.carNum == carNum) {
            return car;
        }
    }
    
    return nil;
}

- (void)deleteCar:(Car *)car {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;

    NSArray *cops  = [car.cops array];
    for (Cop *cop in cops) {
        [self deleteCop:cop];
    }
    
    NSArray *photos  = [car.photos array];
    for (Photo *photo in photos) {
        [self deletePhoto:photo];
    }

    photos  = [car.cdiPhotos array];
    for (Photo *photo in photos) {
        [self deletePhoto:photo];
    }

    photos  = [car.spiPhotos array];
    for (Photo *photo in photos) {
        [self deletePhoto:photo];
    }
    
    car.bank = nil;

    [context deleteObject:car];
}

- (NSDictionary *)getPostJSONForCar:(Car *)car {
    car.jobType = (car.bank.project.jobType == ProjectJobTypeService) ? @"Service" : @"Mod";

    NSMutableArray *summary = [NSMutableArray array];
    
    [summary addObject:@{@"name" : @"car_number", @"value" : NONNULL(car.carNumber)}];
    [summary addObject:@{@"name" : @"install_number", @"value" : NONNULL(car.installNumber)}];
    [summary addObject:@{@"name" : @"weight_scale", @"value" : NONNULL(car.weightScale)}];
    [summary addObject:@{@"name" : @"job_type", @"value" : NONNULL(car.jobType)}];
    [summary addObject:@{@"name" : @"capacity_weight", @"value" : NONNEGATIVE(car.capacityWeight)}];
    [summary addObject:@{@"name" : @"capacity_number_persons", @"value" : @(car.capacityNumberPersons)}];
    [summary addObject:@{@"name" : @"description", @"value" : NONNULL(car.carDescription)}];
    [summary addObject:@{@"name" : @"doors_coinciding", @"value" : NONNULL(car.doorsCoinciding)}];
    [summary addObject:@{@"name" : @"number_of_openings", @"value" : @(car.numberOfOpenings)}];
    [summary addObject:@{@"name" : @"floor_markings", @"value" : NONNULL(car.floorMarkings)}];
    [summary addObject:@{@"name" : @"front_door_opening_height", @"value" : NONNEGATIVE(car.frontDoorOpeningHeight)}];
    [summary addObject:@{@"name" : @"front_door_slide_jamb_width", @"value" : NONNEGATIVE(car.frontDoorSlideJambWidth)}];
    [summary addObject:@{@"name" : @"front_door_strike_jamb_width", @"value" : NONNEGATIVE(car.frontDoorStrikeJambWidth)}];
    [summary addObject:@{@"name" : @"is_there_rear_door", @"value" : car.isThereRearDoor == 1 ? @"yes" : @"no"}];
    [summary addObject:@{@"name" : @"rear_door_opening_height", @"value" : NONNEGATIVE(car.rearDoorOpeningHeight)}];
    [summary addObject:@{@"name" : @"rear_door_slide_jamb_width", @"value" : NONNEGATIVE(car.rearDoorSlideJambWidth)}];
    [summary addObject:@{@"name" : @"rear_door_strike_jamb_width", @"value" : NONNEGATIVE(car.rearDoorStrikeJambWidth)}];
    [summary addObject:@{@"name" : @"is_there_hand_rail", @"value" : car.isThereHandRail == 1 ? @"yes" : @"no"}];
    [summary addObject:@{@"name" : @"hand_rail_height_from_floor", @"value" : NONNEGATIVE(car.handRailHeightFromFloor)}];
    [summary addObject:@{@"name" : @"hand_rail_distance_from_wall", @"value" : NONNEGATIVE(car.handRailDistanceFromWall)}];
    [summary addObject:@{@"name" : @"hand_rail_distance_from_return", @"value" : NONNEGATIVE(car.handRailDistanceFromReturn)}];
    [summary addObject:@{@"name" : @"notes", @"value" : NONNULL(car.notes)}];

    NSInteger index = 0;
    for (Photo *photo in car.photos) {
        [summary addObject:[self getPostJSONForPhoto:photo index:index ++]];
    }
    
    NSMutableArray *copsArray = [NSMutableArray array];
    for (Cop *cop in car.cops) {
        [copsArray addObject:[self getPostJSONForCop:cop]];
    }
    
    NSMutableArray *cda = [NSMutableArray array];
    if (car.isThereCDI == 1) {
        [cda addObject:@{@"name" : @"mount", @"value" : NONNULL(car.mountCDI)}];
        [cda addObject:@{@"name" : @"number_per_cab", @"value" : @(car.numberPerCabCDI)}];
        [cda addObject:@{@"name" : @"cover_width", @"value" : NONNEGATIVE(car.coverWidthCDI)}];
        [cda addObject:@{@"name" : @"cover_height", @"value" : NONNEGATIVE(car.coverHeightCDI)}];
        [cda addObject:@{@"name" : @"depth", @"value" : NONNEGATIVE(car.depthCDI)}];
        [cda addObject:@{@"name" : @"cover_screw_center_width", @"value" : NONNEGATIVE(car.coverScrewCenterWidthCDI)}];
        [cda addObject:@{@"name" : @"cover_screw_center_height", @"value" : NONNEGATIVE(car.coverScrewCenterHeightCDI)}];
        [cda addObject:@{@"name" : @"notes", @"value" : NONNULL(car.notesCDI)}];
        
        NSInteger index = 0;
        for (Photo *photo in car.cdiPhotos) {
            [cda addObject:[self getPostJSONForPhoto:photo index:index ++]];
        }
    }

    NSMutableArray *separatepi = [NSMutableArray array];
    if (car.isThereSPI == 1) {
        [separatepi addObject:@{@"name" : @"mount", @"value" : NONNULL(car.mountSPI)}];
        [separatepi addObject:@{@"name" : @"number_per_cab", @"value" : @(car.numberPerCabSPI)}];
        [separatepi addObject:@{@"name" : @"cover_width", @"value" : NONNEGATIVE(car.coverWidthSPI)}];
        [separatepi addObject:@{@"name" : @"cover_height", @"value" : NONNEGATIVE(car.coverHeightSPI)}];
        [separatepi addObject:@{@"name" : @"depth", @"value" : NONNEGATIVE(car.depthSPI)}];
        [separatepi addObject:@{@"name" : @"cover_screw_center_width", @"value" : NONNEGATIVE(car.coverScrewCenterWidthSPI)}];
        [separatepi addObject:@{@"name" : @"cover_screw_center_height", @"value" : NONNEGATIVE(car.coverScrewCenterHeightSPI)}];
        [separatepi addObject:@{@"name" : @"space_available_width", @"value" : NONNEGATIVE(car.spaceAvailableWidthSPI)}];
        [separatepi addObject:@{@"name" : @"space_available_height", @"value" : NONNEGATIVE(car.spaceAvailableHeightSPI)}];
        [separatepi addObject:@{@"name" : @"notes", @"value" : NONNULL(car.notesSPI)}];
        
        NSInteger index = 0;
        for (Photo *photo in car.spiPhotos) {
            [separatepi addObject:[self getPostJSONForPhoto:photo index:index ++]];
        }
    }

    return @{@"car_summary" : summary,
             @"cop_list" : copsArray,
             @"cda" : cda,
             @"separatepi" : separatepi};
}

#pragma mark Cop

- (NSInteger)getCopCountForProject:(Project *)project {
    NSInteger count = 0;
    for (Bank *bank in project.banks) {
        for (Car *car in bank.cars) {
            count += car.cops.count;
        }
    }
    return count;
}

- (Cop *)createNewCopForCar:(Car *)car copNum:(NSInteger)copNum copName:(NSString *)copName {
    Cop *cop = [self getCopForCar:car copNum:copNum];
    if (cop) {
        cop.copName = copName;
        return cop;
    }
    
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    cop = [NSEntityDescription insertNewObjectForEntityForName:@"Cop" inManagedObjectContext:context];
    cop.copNum = (int32_t)copNum;
    cop.copName = copName;
    cop.car = car;
    [car addCopsObject:cop];
    
    return cop;
}

- (Cop *)getCopForCar:(Car *)car copNum:(NSInteger)copNum {
    for (Cop *cop in car.cops) {
        if (cop.copNum == copNum) {
            return cop;
        }
    }
    
    return nil;
}

- (void)deleteCop:(Cop *)cop {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;

    NSArray *photos  = [cop.photos array];
    for (Photo *photo in photos) {
        [self deletePhoto:photo];
    }
    
    cop.car = nil;

    [context deleteObject:cop];
}

- (NSArray *)getPostJSONForCop:(Cop *)cop {
    NSMutableArray *json = [NSMutableArray array];
    
    [json addObject:@{@"name" : @"cop_name", @"value" : NONNULL(cop.copName)}];
    [json addObject:@{@"name" : @"options", @"value" : NONNULL(cop.options)}];
    [json addObject:@{@"name" : @"return_hinging", @"value" : NONNULL(cop.returnHinging)}];
    [json addObject:@{@"name" : @"return_panel_width", @"value" : [cop.options isEqualToString:@"Applied"] ? NONNEGATIVE(cop.returnPanelWidth) : @""}];
    [json addObject:@{@"name" : @"return_panel_height", @"value" : [cop.options isEqualToString:@"Applied"] ? NONNEGATIVE(cop.returnPanelHeight) : @""}];
    [json addObject:@{@"name" : @"cover_width", @"value" : [cop.options isEqualToString:@"Applied"] ? NONNEGATIVE(cop.coverWidth) : @""}];
    [json addObject:@{@"name" : @"cover_height", @"value" : [cop.options isEqualToString:@"Applied"] ? NONNEGATIVE(cop.coverHeight) : @""}];
    [json addObject:@{@"name" : @"cover_to_opening", @"value" : [cop.options isEqualToString:@"Applied"] ? NONNEGATIVE(cop.coverToOpening) : @""}];
    [json addObject:@{@"name" : @"swing_panel_width", @"value" : [cop.options isEqualToString:@"Swing"] ? NONNEGATIVE(cop.swingPanelWidth) : @""}];
    [json addObject:@{@"name" : @"swing_panel_height", @"value" : [cop.options isEqualToString:@"Swing"] ? NONNEGATIVE(cop.swingPanelHeight) : @""}];
    [json addObject:@{@"name" : @"cover_aff", @"value" : @(cop.coverAff)}];
    [json addObject:@{@"name" : @"notes", @"value" : NONNULL(cop.notes)}];
    
    NSInteger index = 0;
    for (Photo *photo in cop.photos) {
        [json addObject:[self getPostJSONForPhoto:photo index:index ++]];
    }
    
    return json;
}

#pragma mark Interior Car

- (NSArray *)getAllInteriorCarsForProject:(Project *)project {
    NSMutableArray *array = [NSMutableArray array];
    
    for (Bank *bank in project.banks) {
        [array addObjectsFromArray:[bank.interiorCars array]];
    }
    
    return array;
}

- (NSInteger)getInteriorCarCountForProject:(Project *)project {
    NSInteger count = 0;
    for (Bank *bank in project.banks) {
        count += bank.interiorCars.count;
    }
    return count;
}

- (NSInteger)getMaxInteriorCarNumForBank:(Bank *)bank {
    NSInteger max = -1;
    for (InteriorCar *car in bank.interiorCars) {
        max = MAX(max, car.interiorCarNum);
    }
    return max;
}

- (InteriorCar *)createNewInteriorCarForBank:(Bank *)bank interiorCarNum:(NSInteger)interiorCarNum interiorCarDescription:(NSString *)interiorCarDescription {
    InteriorCar *interiorCar = [self getInteriorCarForBank:bank interiorCarNum:interiorCarNum];
    if (interiorCar) {
        interiorCar.carDescription = interiorCarDescription;
        return interiorCar;
    }
    
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    interiorCar = [NSEntityDescription insertNewObjectForEntityForName:@"InteriorCar" inManagedObjectContext:context];
    interiorCar.interiorCarNum = (int32_t)interiorCarNum;
    interiorCar.carDescription = interiorCarDescription;
    interiorCar.bank = bank;
    [bank addInteriorCarsObject:interiorCar];
    
    return interiorCar;
}

- (InteriorCar *)getInteriorCarForBank:(Bank *)bank interiorCarNum:(NSInteger)interiorCarNum {
    for (InteriorCar *interiorCar in bank.interiorCars) {
        if (interiorCar.interiorCarNum == interiorCarNum) {
            return interiorCar;
        }
    }
    
    return nil;
}

- (void)deleteInteriorCar:(InteriorCar *)interiorCar {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    if (interiorCar.frontDoor) {
        [self deleteInteriorCarDoor:interiorCar.frontDoor];
    }
    if (interiorCar.backDoor) {
        [self deleteInteriorCarDoor:interiorCar.backDoor];
    }
    
    NSArray *photos  = [interiorCar.photos array];
    for (Photo *photo in photos) {
        [self deletePhoto:photo];
    }
    
    interiorCar.bank = nil;
    
    [context deleteObject:interiorCar];
}

- (void)copyInteriorCar:(InteriorCar *)srcCar to:(InteriorCar *)dstCar {
    dstCar.birdCage = srcCar.birdCage;
    dstCar.carFloorHeight = srcCar.carFloorHeight;
    dstCar.carFlooring = srcCar.carFlooring;
    dstCar.carTiller = srcCar.carTiller;
    dstCar.escapeHatchLocation = srcCar.escapeHatchLocation;
    dstCar.escapeHatchToLeftWall = srcCar.escapeHatchToLeftWall;
    dstCar.escapeHatchToBackWall = srcCar.escapeHatchToBackWall;
    dstCar.escapeHatchWidth = srcCar.escapeHatchWidth;
    dstCar.escapeHatchLength = srcCar.escapeHatchLength;
    dstCar.exhaustFanLocation = srcCar.exhaustFanLocation;
    dstCar.exhaustToLeftWall = srcCar.exhaustToLeftWall;
    dstCar.exhaustToBackWall = srcCar.exhaustToBackWall;
    dstCar.exhaustWidth = srcCar.exhaustWidth;
    dstCar.exhaustLength = srcCar.exhaustLength;
    dstCar.isThereBackDoor = srcCar.isThereBackDoor;
    dstCar.isThereExhaustFan = srcCar.isThereExhaustFan;
    dstCar.mount = srcCar.mount;
    dstCar.rearWallHeight = srcCar.rearWallHeight;
    dstCar.rearWallWidth = srcCar.rearWallWidth;
    dstCar.typeOfCar = srcCar.typeOfCar;
    dstCar.typeOfCeilingFrame = srcCar.typeOfCeilingFrame;
    
    if (srcCar.backDoor) {
        dstCar.backDoor = [[DataManager sharedManager] cloneInteriorCarDoor:srcCar.backDoor];
    } else {
        dstCar.backDoor = nil;
    }
    if (srcCar.frontDoor) {
        dstCar.frontDoor = [[DataManager sharedManager] cloneInteriorCarDoor:srcCar.frontDoor];
    } else {
        dstCar.frontDoor = nil;
    }

}

- (NSDictionary *)getPostJSONForInteriorCar:(InteriorCar *)interiorCar {
    NSMutableArray *summary = [NSMutableArray array];
    
    [summary addObject:@{@"name" : @"car_number", @"value" : NONNULL(interiorCar.carDescription)}];
    [summary addObject:@{@"name" : @"install_number", @"value" : NONNULL(interiorCar.installNumber)}];
    [summary addObject:@{@"name" : @"weight_scale", @"value" : NONNULL(interiorCar.weightScale)}];
    [summary addObject:@{@"name" : @"car_capacity", @"value" : NONNEGATIVE(interiorCar.carCapacity)}];
    [summary addObject:@{@"name" : @"number_people", @"value" : @(interiorCar.numberOfPeople)}];
    [summary addObject:@{@"name" : @"car_weight", @"value" : NONNEGATIVE(interiorCar.carWeight)}];
    [summary addObject:@{@"name" : @"car_flooring", @"value" : NONNULL(interiorCar.carFlooring)}];
    [summary addObject:@{@"name" : @"car_tiller", @"value" : @(interiorCar.carTiller)}];
    [summary addObject:@{@"name" : @"car_floor_height", @"value" : NONNEGATIVE(interiorCar.carFloorHeight)}];
    [summary addObject:@{@"name" : @"exhaust_fan_location", @"value" : interiorCar.isThereExhaustFan ? interiorCar.exhaustFanLocation : @""}];
    [summary addObject:@{@"name" : @"exhaust_to_left_wall", @"value" : interiorCar.isThereExhaustFan ? NONNEGATIVE(interiorCar.exhaustToLeftWall) : @""}];
    [summary addObject:@{@"name" : @"exhaust_to_back_wall", @"value" : interiorCar.isThereExhaustFan ? NONNEGATIVE(interiorCar.exhaustToBackWall) : @""}];
    [summary addObject:@{@"name" : @"exhaust_width", @"value" : interiorCar.isThereExhaustFan ? NONNEGATIVE(interiorCar.exhaustWidth) : @""}];
    [summary addObject:@{@"name" : @"exhaust_length", @"value" : interiorCar.isThereExhaustFan ? NONNEGATIVE(interiorCar.exhaustLength) : @""}];
    [summary addObject:@{@"name" : @"type_ceiling_frame", @"value" : NONNULL(interiorCar.typeOfCeilingFrame)}];
    [summary addObject:@{@"name" : @"mount", @"value" : NONNULL(interiorCar.mount)}];
    [summary addObject:@{@"name" : @"escape_hatch_location", @"value" : NONNULL(interiorCar.escapeHatchLocation)}];
    [summary addObject:@{@"name" : @"hatch_to_left_wall", @"value" : NONNEGATIVE(interiorCar.escapeHatchToLeftWall)}];
    [summary addObject:@{@"name" : @"hatch_to_back_wall", @"value" : NONNEGATIVE(interiorCar.escapeHatchToBackWall)}];
    [summary addObject:@{@"name" : @"hatch_width", @"value" : NONNEGATIVE(interiorCar.escapeHatchWidth)}];
    [summary addObject:@{@"name" : @"hatch_length", @"value" : NONNEGATIVE(interiorCar.escapeHatchLength)}];

    [summary addObject:@{@"name" : @"type_car", @"value" : NONNULL(interiorCar.typeOfCar)}];
    [summary addObject:@{@"name" : @"bird_cage", @"value" : NONNULL(interiorCar.birdCage)}];
    [summary addObject:@{@"name" : @"rear_wall_width", @"value" : NONNEGATIVE(interiorCar.rearWallWidth)}];
    [summary addObject:@{@"name" : @"rear_wall_height", @"value" : NONNEGATIVE(interiorCar.rearWallHeight)}];
    [summary addObject:@{@"name" : @"notes", @"value" : NONNULL(interiorCar.notes)}];
    
    NSInteger index = 0;
    for (Photo *photo in interiorCar.photos) {
        [summary addObject:[self getPostJSONForPhoto:photo index:index ++]];
    }
    
    return @{@"interior_summary" : summary,
             @"front_door" : interiorCar.frontDoor ? [self getPostJSONForInteriorCarDoor:interiorCar.frontDoor] : [NSArray array],
             @"back_door" : interiorCar.backDoor ? [self getPostJSONForInteriorCarDoor:interiorCar.backDoor] : [NSArray array]};
}

#pragma mark Interior Car Door

- (InteriorCarDoor *)createNewInteriorCarDoorForCar:(InteriorCar *)interiorCar doorStyle:(NSInteger)doorStyle {
    if (doorStyle == 1) {
        if (interiorCar.frontDoor) {
            return interiorCar.frontDoor;
        }
    } else if (doorStyle == 2) {
        if (interiorCar.backDoor) {
            return interiorCar.backDoor;
        }
    }
    
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    InteriorCarDoor *door = [NSEntityDescription insertNewObjectForEntityForName:@"InteriorCarDoor" inManagedObjectContext:context];
    if (doorStyle == 1) {
        interiorCar.frontDoor = door;
        door.interiorCarFront = interiorCar;
    } else {
        interiorCar.backDoor = door;
        door.interiorCarBack = interiorCar;
    }
    door.doorStyle = (int32_t)doorStyle;
    
    return door;
}

- (InteriorCarDoor *)copyFrontToBackDoor:(InteriorCarDoor *)door {
    InteriorCar *interiorCar = door.interiorCarFront;
    if (!interiorCar) {
        return nil;
    }
    
    if (interiorCar.backDoor) {
        return interiorCar.backDoor;
    }
    
    InteriorCarDoor *backDoor = [self createNewInteriorCarDoorForCar:interiorCar doorStyle:2];
    
    backDoor.wallType = door.wallType;
    backDoor.centerOpening = door.centerOpening;
    backDoor.auxCopBottom = door.auxCopBottom;
    backDoor.auxCopHeight = door.auxCopHeight;
    backDoor.auxCopLeft = door.auxCopLeft;
    backDoor.auxCopReturn = door.auxCopReturn;
    backDoor.auxCopRight = door.auxCopRight;
    backDoor.auxCopThroat = door.auxCopThroat;
    backDoor.auxCopTop = door.auxCopTop;
    backDoor.auxCopWidth = door.auxCopWidth;
    backDoor.carDoorOpeningDirection = door.carDoorOpeningDirection;
    backDoor.carDoorType = door.carDoorType;
    backDoor.doorOpeningHeight = door.doorOpeningHeight;
    backDoor.doorOpeningWidth = door.doorOpeningWidth;
    backDoor.frontReturnMeasurementsHeight = door.frontReturnMeasurementsHeight;
    backDoor.height = door.height;
    backDoor.isThereNewCop = door.isThereNewCop;
    backDoor.leftSideA = door.leftSideA;
    backDoor.leftSideATypeB = door.leftSideATypeB;
    backDoor.leftSideB = door.leftSideB;
    backDoor.leftSideBTypeB = door.leftSideBTypeB;
    backDoor.leftSideC = door.leftSideC;
    backDoor.leftSideCTypeB = door.leftSideCTypeB;
    backDoor.leftSideD = door.leftSideD;
    backDoor.leftSideE = door.leftSideE;
    backDoor.mainCopBottom = door.mainCopBottom;
    backDoor.mainCopHeight = door.mainCopHeight;
    backDoor.mainCopLeft = door.mainCopLeft;
    backDoor.mainCopReturn = door.mainCopReturn;
    backDoor.mainCopRight = door.mainCopRight;
    backDoor.mainCopThroat = door.mainCopThroat;
    backDoor.mainCopTop = door.mainCopTop;
    backDoor.mainCopWidth = door.mainCopWidth;
    backDoor.notes = door.notes;
    backDoor.otherFrontReturnMeasurements = door.otherFrontReturnMeasurements;
    backDoor.otherSlamPost = door.otherSlamPost;
    backDoor.returnSideWallDepth = door.returnSideWallDepth;
    backDoor.rightSideA = door.rightSideA;
    backDoor.rightSideATypeB = door.rightSideATypeB;
    backDoor.rightSideB = door.rightSideB;
    backDoor.rightSideBTypeB = door.rightSideBTypeB;
    backDoor.rightSideC = door.rightSideC;
    backDoor.rightSideCTypeB = door.rightSideCTypeB;
    backDoor.rightSideD = door.rightSideD;
    backDoor.rightSideE = door.rightSideE;
    backDoor.sideWallAuxWidth = door.sideWallAuxWidth;
    backDoor.sideWallMainWidth = door.sideWallMainWidth;
    backDoor.slamPostMeasurementsA = door.slamPostMeasurementsA;
    backDoor.slamPostMeasurementsB = door.slamPostMeasurementsB;
    backDoor.slamPostMeasurementsC = door.slamPostMeasurementsC;
    backDoor.slamPostMeasurementsD = door.slamPostMeasurementsD;
    backDoor.slamPostMeasurementsE = door.slamPostMeasurementsE;
    backDoor.slamPostMeasurementsF = door.slamPostMeasurementsF;
    backDoor.slamPostMeasurementsG = door.slamPostMeasurementsG;
    backDoor.slamPostMeasurementsH = door.slamPostMeasurementsH;
    backDoor.slamSideWallDepth = door.slamSideWallDepth;
    backDoor.slideWallWidth = door.slideWallWidth;
    backDoor.transomMeasurementsCenter = door.transomMeasurementsCenter;
    backDoor.transomMeasurementsCenterLeft = door.transomMeasurementsCenterLeft;
    backDoor.transomMeasurementsCenterRight = door.transomMeasurementsCenterRight;
    backDoor.transomMeasurementsHeight = door.transomMeasurementsHeight;
    backDoor.transomMeasurementsLeft = door.transomMeasurementsLeft;
    backDoor.transomMeasurementsRight = door.transomMeasurementsRight;
    backDoor.transomMeasurementsWidth = door.transomMeasurementsWidth;
    backDoor.transomProfileColonnade = door.transomProfileColonnade;
    backDoor.transomProfileColonnade2 = door.transomProfileColonnade2;
    backDoor.transomProfileDepth = door.transomProfileDepth;
    backDoor.transomProfileHeight = door.transomProfileHeight;
    backDoor.transomProfileReturn = door.transomProfileReturn;
    backDoor.typeOfFrontReturn = door.typeOfFrontReturn;
    backDoor.typeOfSlamPost = door.typeOfSlamPost;
    backDoor.uuid = door.uuid;
    backDoor.width = door.width;
    backDoor.lTransomWidth = door.lTransomWidth;
    backDoor.lTransomHeight = door.lTransomHeight;
    backDoor.headerReturnHoistWay = door.headerReturnHoistWay;
    backDoor.headerThroat = door.headerThroat;
    backDoor.headerWidth = door.headerWidth;
    backDoor.headerHeight = door.headerHeight;
    backDoor.headerReturnWall = door.headerReturnWall;
    backDoor.flatFrontLeftWidth = door.flatFrontLeftWidth;
    backDoor.flatFrontLeftHeight = door.flatFrontLeftHeight;
    backDoor.flatFrontRightWidth = door.flatFrontRightWidth;
    backDoor.flatFrontRightHeight = door.flatFrontRightHeight;
    
    return backDoor;
}

- (InteriorCarDoor *)cloneInteriorCarDoor:(InteriorCarDoor *)door {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    InteriorCarDoor *newDoor = [NSEntityDescription insertNewObjectForEntityForName:@"InteriorCarDoor" inManagedObjectContext:context];
    newDoor.centerOpening = door.centerOpening;
    newDoor.doorStyle = door.doorStyle;
    newDoor.wallType = door.wallType;
    newDoor.auxCopBottom = door.auxCopBottom;
    newDoor.auxCopHeight = door.auxCopHeight;
    newDoor.auxCopLeft = door.auxCopLeft;
    newDoor.auxCopReturn = door.auxCopReturn;
    newDoor.auxCopRight = door.auxCopRight;
    newDoor.auxCopThroat = door.auxCopThroat;
    newDoor.auxCopTop = door.auxCopTop;
    newDoor.auxCopWidth = door.auxCopWidth;
    newDoor.carDoorOpeningDirection = door.carDoorOpeningDirection;
    newDoor.carDoorType = door.carDoorType;
    newDoor.doorOpeningHeight = door.doorOpeningHeight;
    newDoor.doorOpeningWidth = door.doorOpeningWidth;
    newDoor.frontReturnMeasurementsHeight = door.frontReturnMeasurementsHeight;
    newDoor.height = door.height;
    newDoor.isThereNewCop = door.isThereNewCop;
    newDoor.leftSideA = door.leftSideA;
    newDoor.leftSideATypeB = door.leftSideATypeB;
    newDoor.leftSideB = door.leftSideB;
    newDoor.leftSideBTypeB = door.leftSideBTypeB;
    newDoor.leftSideC = door.leftSideC;
    newDoor.leftSideCTypeB = door.leftSideCTypeB;
    newDoor.leftSideD = door.leftSideD;
    newDoor.leftSideE = door.leftSideE;
    newDoor.mainCopBottom = door.mainCopBottom;
    newDoor.mainCopHeight = door.mainCopHeight;
    newDoor.mainCopLeft = door.mainCopLeft;
    newDoor.mainCopReturn = door.mainCopReturn;
    newDoor.mainCopRight = door.mainCopRight;
    newDoor.mainCopThroat = door.mainCopThroat;
    newDoor.mainCopTop = door.mainCopTop;
    newDoor.mainCopWidth = door.mainCopWidth;
    newDoor.notes = door.notes;
    newDoor.otherFrontReturnMeasurements = door.otherFrontReturnMeasurements;
    newDoor.otherSlamPost = door.otherSlamPost;
    newDoor.returnSideWallDepth = door.returnSideWallDepth;
    newDoor.rightSideA = door.rightSideA;
    newDoor.rightSideATypeB = door.rightSideATypeB;
    newDoor.rightSideB = door.rightSideB;
    newDoor.rightSideBTypeB = door.rightSideBTypeB;
    newDoor.rightSideC = door.rightSideC;
    newDoor.rightSideCTypeB = door.rightSideCTypeB;
    newDoor.rightSideD = door.rightSideD;
    newDoor.rightSideE = door.rightSideE;
    newDoor.sideWallAuxWidth = door.sideWallAuxWidth;
    newDoor.sideWallMainWidth = door.sideWallMainWidth;
    newDoor.slamPostMeasurementsA = door.slamPostMeasurementsA;
    newDoor.slamPostMeasurementsB = door.slamPostMeasurementsB;
    newDoor.slamPostMeasurementsC = door.slamPostMeasurementsC;
    newDoor.slamPostMeasurementsD = door.slamPostMeasurementsD;
    newDoor.slamPostMeasurementsE = door.slamPostMeasurementsE;
    newDoor.slamPostMeasurementsF = door.slamPostMeasurementsF;
    newDoor.slamPostMeasurementsG = door.slamPostMeasurementsG;
    newDoor.slamPostMeasurementsH = door.slamPostMeasurementsH;
    newDoor.slamSideWallDepth = door.slamSideWallDepth;
    newDoor.slideWallWidth = door.slideWallWidth;
    newDoor.transomMeasurementsCenter = door.transomMeasurementsCenter;
    newDoor.transomMeasurementsCenterLeft = door.transomMeasurementsCenterLeft;
    newDoor.transomMeasurementsCenterRight = door.transomMeasurementsCenterRight;
    newDoor.transomMeasurementsHeight = door.transomMeasurementsHeight;
    newDoor.transomMeasurementsLeft = door.transomMeasurementsLeft;
    newDoor.transomMeasurementsRight = door.transomMeasurementsRight;
    newDoor.transomMeasurementsWidth = door.transomMeasurementsWidth;
    newDoor.transomProfileColonnade = door.transomProfileColonnade;
    newDoor.transomProfileColonnade2 = door.transomProfileColonnade2;
    newDoor.transomProfileDepth = door.transomProfileDepth;
    newDoor.transomProfileHeight = door.transomProfileHeight;
    newDoor.transomProfileReturn = door.transomProfileReturn;
    newDoor.typeOfFrontReturn = door.typeOfFrontReturn;
    newDoor.typeOfSlamPost = door.typeOfSlamPost;
    newDoor.uuid = door.uuid;
    newDoor.width = door.width;
    newDoor.lTransomWidth = door.lTransomWidth;
    newDoor.lTransomHeight = door.lTransomHeight;
    newDoor.headerReturnHoistWay = door.headerReturnHoistWay;
    newDoor.headerThroat = door.headerThroat;
    newDoor.headerWidth = door.headerWidth;
    newDoor.headerHeight = door.headerHeight;
    newDoor.headerReturnWall = door.headerReturnWall;
    newDoor.flatFrontLeftWidth = door.flatFrontLeftWidth;
    newDoor.flatFrontLeftHeight = door.flatFrontLeftHeight;
    newDoor.flatFrontRightWidth = door.flatFrontRightWidth;
    newDoor.flatFrontRightHeight = door.flatFrontRightHeight;

    return newDoor;
}

- (void)deleteInteriorCarDoor:(InteriorCarDoor *)door {
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    [context deleteObject:door];
}

- (NSArray *)getPostJSONForInteriorCarDoor:(InteriorCarDoor *)door {
    NSMutableArray *json = [NSMutableArray array];
    
    [json addObject:@{@"name" : @"opening", @"value" : @(1)}];
    [json addObject:@{@"name" : @"wall_type", @"value" : NONNULL(door.wallType)}];
    [json addObject:@{@"name" : @"notes", @"value" : NONNULL(door.wallTypeNotes)}];
    [json addObject:@{@"name" : @"center_opening", @"value" : door.centerOpening == 1 ? @"YES" : @"NO"}];
    [json addObject:@{@"name" : @"width", @"value" : NONNEGATIVE(door.width)}];
    [json addObject:@{@"name" : @"height", @"value" : NONNEGATIVE(door.height)}];
    [json addObject:@{@"name" : @"side_wall_main_width", @"value" : door.centerOpening == 1 ? NONNEGATIVE(door.sideWallMainWidth) : @""}];
    [json addObject:@{@"name" : @"side_wall_aux_width", @"value" : door.centerOpening == 1 ? NONNEGATIVE(door.sideWallAuxWidth) : @""}];
    [json addObject:@{@"name" : @"return_side_wall_depth", @"value" : door.centerOpening == 2 ? NONNEGATIVE(door.returnSideWallDepth) : @""}];
    [json addObject:@{@"name" : @"slam_side_wall_depth", @"value" : door.centerOpening == 2 ? NONNEGATIVE(door.slamSideWallDepth) : @""}];
//    [json addObject:@{@"name" : @"slide_wall_width", @"value" : door.centerOpening == 2 ? @(door.slideWallWidth) : @(0)}];
    [json addObject:@{@"name" : @"door_opening_width", @"value" : NONNEGATIVE(door.doorOpeningWidth)}];
    [json addObject:@{@"name" : @"door_opening_height", @"value" : NONNEGATIVE(door.doorOpeningHeight)}];
    [json addObject:@{@"name" : @"type_of_slam_post", @"value" : (door.centerOpening == 2 && ![door.typeOfSlamPost isEqualToString:@"OTHER"]) ? NONNULL(door.typeOfSlamPost) : @""}];
    [json addObject:@{@"name" : @"type_of_slam_post_image", @"value" : (door.centerOpening == 2 && ![door.typeOfSlamPost isEqualToString:@"OTHER"]) ? NONNULL(door.typeOfSlamPost) : @""}];
    [json addObject:@{@"name" : @"other_slam_post", @"value" : (door.centerOpening == 2 && ![door.typeOfSlamPost isEqualToString:@"OTHER"]) ? NONNULL(door.otherSlamPost) : @""}];
    [json addObject:@{@"name" : @"slam_post_measurements_A", @"value" : (door.centerOpening == 2 && ![door.typeOfSlamPost isEqualToString:@"OTHER"]) ? NONNEGATIVE(door.slamPostMeasurementsA) : @""}];
    [json addObject:@{@"name" : @"slam_post_measurements_B", @"value" : (door.centerOpening == 2 && ![door.typeOfSlamPost isEqualToString:@"OTHER"]) ? NONNEGATIVE(door.slamPostMeasurementsB) : @""}];
    [json addObject:@{@"name" : @"slam_post_measurements_C", @"value" : (door.centerOpening == 2 && ![door.typeOfSlamPost isEqualToString:@"OTHER"]) ? NONNEGATIVE(door.slamPostMeasurementsC) : @""}];
    [json addObject:@{@"name" : @"slam_post_measurements_D", @"value" : (door.centerOpening == 2 && ![door.typeOfSlamPost isEqualToString:@"OTHER"] && ![door.typeOfSlamPost isEqualToString:@"C"]) ? NONNEGATIVE(door.slamPostMeasurementsD) : @""}];
    [json addObject:@{@"name" : @"slam_post_measurements_E", @"value" : (door.centerOpening == 2 && ![door.typeOfSlamPost isEqualToString:@"OTHER"] && ![door.typeOfSlamPost isEqualToString:@"C"]) ? NONNEGATIVE(door.slamPostMeasurementsE) : @""}];
    [json addObject:@{@"name" : @"slam_post_measurements_F", @"value" : (door.centerOpening == 2 && ![door.typeOfSlamPost isEqualToString:@"OTHER"] && ![door.typeOfSlamPost isEqualToString:@"C"]) ? NONNEGATIVE(door.slamPostMeasurementsF) : @""}];
    [json addObject:@{@"name" : @"slam_post_measurements_G", @"value" : (door.centerOpening == 2 && ![door.typeOfSlamPost isEqualToString:@"OTHER"]) ? NONNEGATIVE(door.slamPostMeasurementsG) : @""}];
    [json addObject:@{@"name" : @"slam_post_measurements_H", @"value" : (door.centerOpening == 2 && ![door.typeOfSlamPost isEqualToString:@"OTHER"]) ? NONNEGATIVE(door.slamPostMeasurementsH) : @""}];
    [json addObject:@{@"name" : @"type_of_front_return", @"value" : ![door.typeOfFrontReturn isEqualToString:@"OTHER"] ? NONNULL(door.typeOfFrontReturn) : @""}];
    [json addObject:@{@"name" : @"leftside_image", @"value" : ![door.typeOfFrontReturn isEqualToString:@"OTHER"] ? NONNULL(door.typeOfFrontReturn) : @""}];
    [json addObject:@{@"name" : @"left_side_A", @"value" : ![door.typeOfFrontReturn isEqualToString:@"OTHER"] ? NONNEGATIVE(door.leftSideA) : @""}];
    [json addObject:@{@"name" : @"left_side_B", @"value" : ![door.typeOfFrontReturn isEqualToString:@"OTHER"] ? NONNEGATIVE(door.leftSideB) : @""}];
    [json addObject:@{@"name" : @"left_side_C", @"value" : ![door.typeOfFrontReturn isEqualToString:@"OTHER"] ? NONNEGATIVE(door.leftSideC) : @""}];
    [json addObject:@{@"name" : @"left_side_D", @"value" : (![door.typeOfFrontReturn isEqualToString:@"OTHER"] && ![door.typeOfFrontReturn isEqualToString:@"B"]) ? NONNEGATIVE(door.leftSideD) : @""}];
    [json addObject:@{@"name" : @"left_side_E", @"value" : (![door.typeOfFrontReturn isEqualToString:@"OTHER"] && ![door.typeOfFrontReturn isEqualToString:@"B"]) ? NONNEGATIVE(door.leftSideE) : @""}];
    [json addObject:@{@"name" : @"rightside_image", @"value" : (door.centerOpening == 1 && ![door.typeOfFrontReturn isEqualToString:@"OTHER"]) ? NONNULL(door.typeOfFrontReturn) : @""}];
    [json addObject:@{@"name" : @"right_side_A", @"value" : door.centerOpening == 1 ? NONNEGATIVE(door.rightSideA) : @""}];
    [json addObject:@{@"name" : @"right_side_B", @"value" : door.centerOpening == 1 ? NONNEGATIVE(door.rightSideB) : @""}];
    [json addObject:@{@"name" : @"right_side_C", @"value" : door.centerOpening == 1 ? NONNEGATIVE(door.rightSideC) : @""}];
    [json addObject:@{@"name" : @"right_side_D", @"value" : (door.centerOpening == 1 && ![door.typeOfFrontReturn isEqualToString:@"B"]) ? NONNEGATIVE(door.rightSideD) : @""}];
    [json addObject:@{@"name" : @"right_side_E", @"value" : (door.centerOpening == 1 && ![door.typeOfFrontReturn isEqualToString:@"B"]) ? NONNEGATIVE(door.rightSideE) : @""}];
    [json addObject:@{@"name" : @"front_return_measurements_height", @"value" : ![door.typeOfFrontReturn isEqualToString:@"OTHER"] ? NONNEGATIVE(door.frontReturnMeasurementsHeight) : @""}];
    [json addObject:@{@"name" : @"other_front_return_measurements", @"value" : ![door.typeOfFrontReturn isEqualToString:@"OTHER"] ? NONNULL(door.otherFrontReturnMeasurements) : @""}];

    NSString *str = @"";
    if (door.carDoorType == 2) {
        str = @"Single Speed";
    } else if (door.carDoorType == 1) {
        str = @"Two Speed";
    }
    [json addObject:@{@"name" : @"car_door_type", @"value" : str}];

    str = @"";
    if (door.carDoorOpeningDirection == 1)
        str = @"Slides Open To Left";
    else if (door.carDoorOpeningDirection == 2)
        str = @"Slides Open To Right";
    [json addObject:@{@"name" : @"car_door_opening_direction", @"value" : door.centerOpening == 2 ? str : @""}];

    BOOL fivepiece = [door.wallType isEqualToString:FivePiece];

    [json addObject:@{@"name" : @"transom_image", @"value" : !fivepiece ? (door.carDoorType == 2 ? @"1s" : @"2s") : @""}];
    [json addObject:@{@"name" : @"transom_measurements_height", @"value" : !fivepiece ? NONNEGATIVE(door.transomMeasurementsHeight) : @""}];
    [json addObject:@{@"name" : @"transom_measurements_width", @"value" : !fivepiece ? NONNEGATIVE(door.transomMeasurementsWidth) : @""}];
    [json addObject:@{@"name" : @"transom_measurements_left", @"value" : !fivepiece ? NONNEGATIVE(door.transomMeasurementsLeft) : @""}];
    [json addObject:@{@"name" : @"transom_measurements_center_left", @"value" : !fivepiece && door.centerOpening == 1 ? NONNEGATIVE(door.transomMeasurementsCenterLeft) : @""}];
    [json addObject:@{@"name" : @"transom_measurements_center", @"value" : !fivepiece && door.centerOpening == 2 ? NONNEGATIVE(door.transomMeasurementsCenter) : @""}];
    [json addObject:@{@"name" : @"transom_measurements_center_right", @"value" : !fivepiece && door.centerOpening == 1 ? NONNEGATIVE(door.transomMeasurementsCenterRight) : @""}];
    [json addObject:@{@"name" : @"transom_measurements_right", @"value" : !fivepiece ? NONNEGATIVE(door.transomMeasurementsRight) : @""}];
    [json addObject:@{@"name" : @"transom_profile_image", @"value" : !fivepiece ? (door.carDoorType == 2 ? @"1s" : @"2s") : @""}];
    [json addObject:@{@"name" : @"transom_profile_height", @"value" : !fivepiece ? NONNEGATIVE(door.transomProfileHeight) : @""}];
    [json addObject:@{@"name" : @"transom_profile_depth", @"value" : !fivepiece ? NONNEGATIVE(door.transomProfileDepth) : @""}];
    [json addObject:@{@"name" : @"transom_profile_return", @"value" : !fivepiece ? NONNEGATIVE(door.transomProfileReturn) : @""}];
    [json addObject:@{@"name" : @"transom_profile_colonnade", @"value" : !fivepiece ? NONNEGATIVE(door.transomProfileColonnade) : @""}];
    [json addObject:@{@"name" : @"transom_profile_colonnade2", @"value" : !fivepiece && door.carDoorType == 1 ? NONNEGATIVE(door.transomProfileColonnade2) : @""}];
    
    [json addObject:@{@"name" : @"l_transom_width", @"value" : fivepiece ? NONNEGATIVE(door.lTransomWidth) : @""}];
    [json addObject:@{@"name" : @"l_transom_height", @"value" : fivepiece ? NONNEGATIVE(door.lTransomHeight) : @""}];
    [json addObject:@{@"name" : @"return_hoist_way", @"value" : fivepiece ? NONNEGATIVE(door.headerReturnHoistWay) : @""}];
    [json addObject:@{@"name" : @"header_throat", @"value" : fivepiece ? NONNEGATIVE(door.headerThroat) : @""}];
    [json addObject:@{@"name" : @"header_width", @"value" : fivepiece ? NONNEGATIVE(door.headerWidth) : @""}];
    [json addObject:@{@"name" : @"header_height", @"value" : fivepiece ? NONNEGATIVE(door.headerHeight) : @""}];
    [json addObject:@{@"name" : @"header_return_wall", @"value" : fivepiece ? NONNEGATIVE(door.headerReturnWall) : @""}];
    [json addObject:@{@"name" : @"flat_front_left_width", @"value" : fivepiece ? NONNEGATIVE(door.flatFrontLeftWidth) : @""}];
    [json addObject:@{@"name" : @"flat_front_left_height", @"value" : fivepiece ? NONNEGATIVE(door.flatFrontLeftHeight) : @""}];
    [json addObject:@{@"name" : @"flat_front_right_width", @"value" : fivepiece ? NONNEGATIVE(door.flatFrontRightWidth) : @""}];
    [json addObject:@{@"name" : @"flat_front_right_height", @"value" : fivepiece ? NONNEGATIVE(door.flatFrontRightHeight) : @""}];

    [json addObject:@{@"name" : @"is_there_new_cop", @"value" : NONNULL(door.isThereNewCop)}];

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator = NO;
    
    [json addObject:@{@"name" : @"cop_width", @"value" : [door.isThereNewCop isEqualToString:@"YES"] ?
                      [NSString stringWithFormat:@"Main=%@,Aux=%@", door.mainCopWidth < 0 ? @"" : [formatter stringFromNumber:@(door.mainCopWidth)],
                       door.auxCopWidth < 0 ? @"" : [formatter stringFromNumber:@(door.auxCopWidth)]] : @""}];
    [json addObject:@{@"name" : @"cop_height", @"value" : [door.isThereNewCop isEqualToString:@"YES"] ?
                      [NSString stringWithFormat:@"Main=%@,Aux=%@", door.mainCopHeight < 0 ? @"" : [formatter stringFromNumber:@(door.mainCopHeight)],
                       door.auxCopHeight < 0 ? @"" : [formatter stringFromNumber:@(door.auxCopHeight)]] : @""}];
    [json addObject:@{@"name" : @"cop_left", @"value" : [door.isThereNewCop isEqualToString:@"YES"] ?
                      [NSString stringWithFormat:@"Main=%@,Aux=%@", door.mainCopLeft < 0 ? @"" : [formatter stringFromNumber:@(door.mainCopLeft)],
                       door.auxCopLeft < 0 ? @"" : [formatter stringFromNumber:@(door.auxCopLeft)]] : @""}];
    [json addObject:@{@"name" : @"cop_right", @"value" : [door.isThereNewCop isEqualToString:@"YES"] ?
                      [NSString stringWithFormat:@"Main=%@,Aux=%@", door.mainCopRight < 0 ? @"" : [formatter stringFromNumber:@(door.mainCopRight)],
                       door.auxCopRight < 0 ? @"" : [formatter stringFromNumber:@(door.auxCopRight)]] : @""}];
    [json addObject:@{@"name" : @"cop_top", @"value" : [door.isThereNewCop isEqualToString:@"YES"] ?
                      [NSString stringWithFormat:@"Main=%@,Aux=%@", door.mainCopTop < 0 ? @"" : [formatter stringFromNumber:@(door.mainCopTop)],
                       door.auxCopTop < 0 ? @"" : [formatter stringFromNumber:@(door.auxCopTop)]] : @""}];
    [json addObject:@{@"name" : @"cop_bottom", @"value" : [door.isThereNewCop isEqualToString:@"YES"] ?
                      [NSString stringWithFormat:@"Main=%@,Aux=%@", door.mainCopBottom < 0 ? @"" : [formatter stringFromNumber:@(door.mainCopBottom)],
                       door.auxCopBottom < 0 ? @"" : [formatter stringFromNumber:@(door.auxCopBottom)]] : @""}];
    [json addObject:@{@"name" : @"cop_throat", @"value" : [door.isThereNewCop isEqualToString:@"YES"] ?
                      [NSString stringWithFormat:@"Main=%@,Aux=%@", door.mainCopThroat < 0 ? @"" : [formatter stringFromNumber:@(door.mainCopThroat)],
                       door.auxCopThroat < 0 ? @"" : [formatter stringFromNumber:@(door.auxCopThroat)]] : @""}];
    [json addObject:@{@"name" : @"cop_return", @"value" : [door.isThereNewCop isEqualToString:@"YES"] ?
                      [NSString stringWithFormat:@"Main=%@,Aux=%@", door.mainCopReturn < 0 ? @"" : [formatter stringFromNumber:@(door.mainCopReturn)],
                       door.auxCopReturn < 0 ? @"" : [formatter stringFromNumber:@(door.auxCopReturn)]] : @""}];
    
    return json;
}

#pragma mark - Photo

- (NSArray *)getAllPhotosForProject:(Project *)project {
    NSMutableArray *photos = [NSMutableArray array];
    
    [photos addObjectsFromArray:[project.photos array]];
    
    for (Lobby *lobby in project.lobbies) {
        [photos addObjectsFromArray:[lobby.photos array]];
    }
    
    for (Bank *bank in project.banks) {
        [photos addObjectsFromArray:[bank.photos array]];
        
        for (HallStation *hallStation in bank.hallStations) {
            [photos addObjectsFromArray:[hallStation.photos array]];
        }
        
        for (Lantern *lantern in bank.lanterns) {
            [photos addObjectsFromArray:[lantern.photos array]];
        }
        
        for (Car *car in bank.cars) {
            [photos addObjectsFromArray:[car.photos array]];
            [photos addObjectsFromArray:[car.cdiPhotos array]];
            [photos addObjectsFromArray:[car.spiPhotos array]];
            
            for (Cop *cop in car.cops) {
                [photos addObjectsFromArray:[cop.photos array]];
            }
        }

        for (InteriorCar *interiorCar in bank.interiorCars) {
            [photos addObjectsFromArray:[interiorCar.photos array]];
        }
        
        for (HallEntrance *hallEntrance in bank.hallEntrances) {
            [photos addObjectsFromArray:[hallEntrance.photos array]];
        }
    }
    
    return photos;
}

- (Photo *)createNewPhotoWithImage:(UIImage *)image {
    NSString *filename = [NSString stringWithFormat:@"%ld.jpg", (long)time(NULL)];
    NSString *fileURL = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:filename];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSData *thumbData = UIImageJPEGRepresentation(image, 0.1);
    
    [data writeToFile:fileURL atomically:YES];
    [thumbData writeToFile:[fileURL stringByReplacingOccurrencesOfString:@".jpg" withString:@"_thumb.jpg"] atomically:YES];
    
    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
    photo.fileName = filename;
    
    return photo;
}

- (Photo *)updatePhoto:(Photo *)photo withImage:(UIImage *)image {
    NSString *filename = photo.fileName;
    NSString *fileURL = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:filename];
    NSString *thumbURL = [fileURL stringByReplacingOccurrencesOfString:@".jpg" withString:@"_thumb.jpg"];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSData *thumbData = UIImageJPEGRepresentation(image, 0.1);
    
    [[NSFileManager defaultManager] removeItemAtPath:fileURL error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:thumbURL error:nil];
    
    [data writeToFile:fileURL atomically:YES];
    [thumbData writeToFile:thumbURL atomically:YES];
    
    return photo;
}

- (void)deletePhoto:(Photo *)photo {
    NSString *fileURL = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:photo.fileName];
    NSString *thumbURL = [fileURL stringByReplacingOccurrencesOfString:@".jpg" withString:@"_thumb.jpg"];

    [[NSFileManager defaultManager] removeItemAtPath:fileURL error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:thumbURL error:nil];

    NSManagedObjectContext *context = AppDelegate.sharedDeleate.persistentContainer.viewContext;
    
    if (photo.project) {
        [photo.project removePhotosObject:photo];
    }
    if (photo.bank) {
        [photo.bank removePhotosObject:photo];
    }
    if (photo.lobby) {
        [photo.lobby removePhotosObject:photo];
    }
    if (photo.lantern) {
        [photo.lantern removePhotosObject:photo];
    }
    if (photo.car) {
        [photo.car removePhotosObject:photo];
    }
    if (photo.cdiCar) {
        [photo.cdiCar removePhotosObject:photo];
    }
    if (photo.spiCar) {
        [photo.spiCar removePhotosObject:photo];
    }
    if (photo.cop) {
        [photo.cop removePhotosObject:photo];
    }
    if (photo.hallStation) {
        [photo.hallStation removePhotosObject:photo];
    }
    if (photo.hallEntrance) {
        [photo.hallEntrance removePhotosObject:photo];
    }
    if (photo.interiorCar) {
        [photo.interiorCar removePhotosObject:photo];
    }
    
    [context deleteObject:photo];
}

- (NSDictionary *)getPostJSONForPhoto:(Photo *)photo index:(NSInteger)index {
    return @{@"name" : [NSString stringWithFormat:@"image_src%d", (int)index + 1],
             @"value" : photo.fileName};
}

@end
