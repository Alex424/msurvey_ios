//
//  HallEntranceViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 11/27/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

typedef NS_ENUM(NSUInteger, UICellCombo) {
    UICellUnique,
    UICellSameAsLast,
    UICellSameAs
};

@interface HallEntranceViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * comboImageViews;
    
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel *floorLabel;
    IBOutlet UILabel *carNumberLabel;
}

-(IBAction)comboAction:(id)sender;

@end
