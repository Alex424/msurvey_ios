//
//  Lobby+CoreDataProperties.m
//  MADSurvey
//
//  Created by seniorcoder on 7/22/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "Lobby+CoreDataProperties.h"

@implementation Lobby (CoreDataProperties)

+ (NSFetchRequest<Lobby *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Lobby"];
}

@dynamic lobbyNum;
@dynamic location;
@dynamic notes;
@dynamic panelHeight;
@dynamic panelWidth;
@dynamic screwCenterHeight;
@dynamic screwCenterWidth;
@dynamic specialCommunicationOption;
@dynamic specialFeature;
@dynamic visibility;
@dynamic photos;
@dynamic project;

@end
