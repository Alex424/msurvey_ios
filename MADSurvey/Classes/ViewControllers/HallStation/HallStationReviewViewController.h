//
//  HallStationReviewViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/4/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface HallStationReviewViewController : MADMotherViewController <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * floorLabel;
    IBOutlet UILabel * hallStationLabel;
    IBOutlet UITextField * descField;
    IBOutlet UITextField * mountingField;
    IBOutlet UITextField * wallMaterialField;
    IBOutlet UITextField * coverWidthField;
    IBOutlet UITextField * coverHeightField;
    IBOutlet UITextField * screwWidthField;
    IBOutlet UITextField * screwHeightField;
    IBOutlet UITextField * affField;
}
@end
