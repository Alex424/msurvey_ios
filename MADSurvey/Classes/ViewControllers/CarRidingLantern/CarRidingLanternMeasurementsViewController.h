//
//  CarRidingLanternMeasurementsViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface CarRidingLanternMeasurementsViewController : MADMotherViewController
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
    IBOutlet UITextField * quantityField;
    IBOutlet UITextField * coverWidthField;
    IBOutlet UITextField * coverHeightField;
    IBOutlet UITextField * coverDepthField;
    IBOutlet UITextField * coverScrewWidthField;
    IBOutlet UITextField * coverScrewHeightField;
}

@end
