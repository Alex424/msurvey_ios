//
//  InteriorCarBackDoorViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/5/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"
typedef NS_ENUM(NSUInteger, UICellCombo) {
    UICellYes,
    UICellNo,
    UICellNoSelected
    
};
@interface InteriorCarBackDoorViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * comboImageViews;

    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
}
-(IBAction)comboAction:(id)sender;

@end
