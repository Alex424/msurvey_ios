//
//  FloorDescriptionViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/4/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface FloorDescriptionViewController : MADMotherViewController <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * floorRecordLabel;
    IBOutlet UITextField * descriptionField;
}

@property (nonatomic, assign) BOOL fromBank;

@end
