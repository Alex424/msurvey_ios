//
//  InteriorCarTypeViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface InteriorCarTypeViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * comboImageViews;

}
-(IBAction)comboAction:(id)sender;

@end
