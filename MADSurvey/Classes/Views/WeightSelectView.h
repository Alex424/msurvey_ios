//
//  WeightSelectView.h
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^proj_photo_kg_block)(void);
typedef void (^proj_photo_lbs_block)(void);


@interface WeightSelectView : UIView
{
    IBOutlet UIView * selectView;
}

@property (nonatomic) proj_photo_kg_block kgBlock;
@property (nonatomic) proj_photo_lbs_block lbsBlock;

- (IBAction)close:(id)sender;

- (IBAction)kg:(id)sender;
- (IBAction)lbs:(id)sender;

+ (WeightSelectView*) showOnView:(UIView*) view;

@end
