//
//  HallStationMountingViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

typedef NS_ENUM(NSUInteger, UICellCombo) {
    UICellFlash,
    UICellSurface,
};

@interface HallStationMountingViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * comboImageViews;
    
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * floorLabel;
    IBOutlet UILabel * hallStationLabel;
}

-(IBAction)comboAction:(id)sender;

@end
