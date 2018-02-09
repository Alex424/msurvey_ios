//
//  CarDoorMeasurementsViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface CarDoorMeasurementsViewController : MADMotherViewController
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
    IBOutlet UITextField * openingHeightFrontField;
    IBOutlet UITextField * openingHeightBackField;
    IBOutlet UITextField * returnWidthFrontField;
    IBOutlet UITextField * returnWidthBackField;
    IBOutlet UITextField * strikeWidthFrontField;
    IBOutlet UITextField * strikeWidthBackField;
    IBOutlet UIButton * copyButton;
    IBOutlet UILabel *backDoorLabel;
}

- (IBAction)copyFromFront:(id)sender;

@end
