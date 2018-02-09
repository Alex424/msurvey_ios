//
//  HallStationMeasurementViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface HallStationMeasurementViewController : MADMotherViewController
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * floorLabel;
    IBOutlet UILabel * hallStationLabel;
    IBOutlet UITextField * coverWidthField;
    IBOutlet UITextField * coverHeightField;
    IBOutlet UITextField * depthField;
    IBOutlet UITextField * screwWidthField;
    IBOutlet UITextField * screwHeightField;
    IBOutlet UITextField * affField;
}
@end
