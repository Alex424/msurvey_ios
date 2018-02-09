//
//  LanternNumberViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface LanternNumberViewController : MADMotherViewController <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * floorLabel;
    IBOutlet UITextField * numberField;
}
@end
