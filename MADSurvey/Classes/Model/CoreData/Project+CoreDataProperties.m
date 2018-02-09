//
//  Project+CoreDataProperties.m
//  MADSurvey
//
//  Created by seniorcoder on 7/24/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "Project+CoreDataProperties.h"

@implementation Project (CoreDataProperties)

+ (NSFetchRequest<Project *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Project"];
}

@dynamic cabInteriors;
@dynamic companyContact;
@dynamic companyName;
@dynamic cops;
@dynamic hallEntrances;
@dynamic hallLanterns;
@dynamic hallStations;
@dynamic id;
@dynamic jobType;
@dynamic lobbyPanels;
@dynamic name;
@dynamic no;
@dynamic notes;
@dynamic numBanks;
@dynamic numFloors;
@dynamic numLobbyPanels;
@dynamic scaleUnit;
@dynamic status;
@dynamic surveyDate;
@dynamic uuid;
@dynamic submitTime;
@dynamic banks;
@dynamic lobbies;
@dynamic photos;

@end
