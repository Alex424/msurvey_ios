//
//  HallEntranceSkipRestViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 11/26/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface HallEntranceSkipRestViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * comboImageViews;
    
    IBOutlet UILabel *bankLabel;
    IBOutlet UILabel *floorLabel;
    IBOutlet UILabel *carNumberLabel;
}

- (IBAction)comboAction:(id)sender;

@end
