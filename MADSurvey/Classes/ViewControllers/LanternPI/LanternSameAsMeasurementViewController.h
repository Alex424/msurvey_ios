//
//  LanternSameAsMeasurementViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface LanternSameAsMeasurementViewController : MADMotherViewController <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * floorLabel;
    IBOutlet UILabel * lanternLabel;
    IBOutlet UITextField * widthField;
    IBOutlet UITextField * heightField;
}

@end
