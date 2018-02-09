//
//  HallStationWallMaterialViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

typedef NS_ENUM(NSUInteger, UICellMaterial) {
    UICellDrywall,
    UICellPlaster,
    UICellConcrete,
    UICellBrick,
    UICellMarble,
    UICellGranit,
    UICellGlass,
    UICellTile,
    UICellMetal,
    UICellWood,
    UICellOther,
    UICellNoSelected
};

@interface HallStationWallMaterialViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * checkImageViews;

    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * floorLabel;
    IBOutlet UILabel * hallStationLabel;
}

-(IBAction)checkAction:(id)sender;

@end
