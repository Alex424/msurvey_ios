//
//  LanternMountingViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface LanternMountingViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * comboImageViews;
    
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * floorLabel;
    IBOutlet UILabel * lanternLabel;
}

-(IBAction)comboAction:(id)sender;

@end
