//
//  CarCopAppliedMeasurementsViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface CarCopAppliedMeasurementsViewController : MADMotherViewController
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
    IBOutlet UITextField * returnWidthField;
    IBOutlet UITextField * returnHeightField;
    IBOutlet UITextField * copWidthField;
    IBOutlet UITextField * copHeightField;
    IBOutlet UITextField * coverToOpeningField;
    IBOutlet UITextField * affField;
}

@end
