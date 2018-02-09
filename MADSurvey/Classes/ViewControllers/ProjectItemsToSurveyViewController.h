//
//  ProjectItemsToSurveyViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/2/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

typedef NS_ENUM(NSUInteger, UICellCheck) {
    UICellAll,
    UICellAllFixtures,
    UICellLobbyPanels,
    UICellHallStations,
    UICellHallLanterns,
    UICellCops,
    UICellCabInteriors,
    UICellHallEntrance,
    UICellNoSelected
    
};

@interface ProjectItemsToSurveyViewController : MADMotherViewController
{
    IBOutletCollection(UIButton) NSArray<UIButton *> * checkButtons;
    IBOutletCollection(UIImageView) NSArray<UIImageView *> * checkImageViews;
}

-(IBAction)checkAction:(id)sender;

@end
