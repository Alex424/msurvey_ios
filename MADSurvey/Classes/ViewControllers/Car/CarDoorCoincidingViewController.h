//
//  CarDoorCoincidingViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface CarDoorCoincidingViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * comboImageViews;
    
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
}

-(IBAction)comboAction:(id)sender;

@end
