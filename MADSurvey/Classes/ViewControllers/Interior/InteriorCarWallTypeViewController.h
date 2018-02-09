//
//  InteriorCarWallTypeViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 11/26/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface InteriorCarWallTypeViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * comboImageViews;
    
}
-(IBAction)comboAction:(id)sender;

@end
