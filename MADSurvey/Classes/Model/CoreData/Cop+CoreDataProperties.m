//
//  Cop+CoreDataProperties.m
//  MADSurvey
//
//  Created by seniorcoder on 7/22/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "Cop+CoreDataProperties.h"

@implementation Cop (CoreDataProperties)

+ (NSFetchRequest<Cop *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Cop"];
}

@dynamic carNum;
@dynamic copName;
@dynamic copNum;
@dynamic coverAff;
@dynamic coverHeight;
@dynamic coverToOpening;
@dynamic coverWidth;
@dynamic notes;
@dynamic options;
@dynamic returnHinging;
@dynamic returnPanelHeight;
@dynamic returnPanelWidth;
@dynamic swingPanelHeight;
@dynamic swingPanelWidth;
@dynamic uuid;
@dynamic car;
@dynamic photos;

@end
