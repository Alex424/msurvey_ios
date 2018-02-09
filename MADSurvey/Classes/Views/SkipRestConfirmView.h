//
//  ExistingSurveyDeleteConfirmView.h
//  MADSurvey
//
//  Created by seniorcoder on 6/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^skip_rest_yes_block)(void);
typedef void (^skip_rest_no_block)(void);

@interface SkipRestConfirmView : UIView
{
    IBOutlet UIView * confirmView;
}

@property (nonatomic) skip_rest_yes_block yesBlock;
@property (nonatomic) skip_rest_no_block noBlock;

- (IBAction)close:(id)sender;

- (IBAction)yes:(id)sender;
- (IBAction)no:(id)sender;

+ (SkipRestConfirmView *) showOnView:(UIView*) view;

@end
