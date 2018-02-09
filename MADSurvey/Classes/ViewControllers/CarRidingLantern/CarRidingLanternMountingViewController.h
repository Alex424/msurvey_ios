//
//  CarRidingLanternMountingViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface CarRidingLanternMountingViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * comboImageViews;
    
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
}

-(IBAction)comboAction:(id)sender;

@end
