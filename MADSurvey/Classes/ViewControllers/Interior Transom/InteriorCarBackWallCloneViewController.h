//
//  InteriorCarBackWallCloneViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/8/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface InteriorCarBackWallCloneViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * comboImageViews;
    
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
}
-(IBAction)comboAction:(id)sender;


@end
