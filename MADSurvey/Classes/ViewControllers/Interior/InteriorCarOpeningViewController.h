//
//  InteriorCarOpeningViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface InteriorCarOpeningViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * comboImageViews;
    
}
-(IBAction)comboAction:(id)sender;


@end
