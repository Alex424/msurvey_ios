//
//  LanternReviewViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface LanternReviewViewController : MADMotherViewController
<UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * floorLabel;
    IBOutlet UILabel * hallStationLabel;
    IBOutlet UITextField * descField;
    IBOutlet UITextField * mountingField;
    IBOutlet UITextField * wallMaterialField;
    IBOutlet UITextField * coverWidthField;
    IBOutlet UITextField * coverHeightField;
    IBOutlet UITextField * coverDepthField;
    IBOutlet UITextField * screwWidthField;
    IBOutlet UITextField * screwHeightField;
    IBOutlet UITextField * spaceWidthField;
    IBOutlet UITextField * spaceHeightField;
}

@end
