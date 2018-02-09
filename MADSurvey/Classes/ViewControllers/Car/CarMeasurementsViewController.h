//
//  CarMeasurementsViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface CarMeasurementsViewController : MADMotherViewController  <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
    IBOutlet UITextField * heightFromFloorField;
    IBOutlet UITextField * distFromWallField;
    IBOutlet UITextField * distFromReturnField;
}

@end
