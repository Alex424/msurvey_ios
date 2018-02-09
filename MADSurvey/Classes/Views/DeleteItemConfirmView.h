//
//  ExistingSurveyDeleteConfirmView.h
//  MADSurvey
//
//  Created by seniorcoder on 6/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^delete_item_yes_block)(void);

@interface DeleteItemConfirmView : UIView
{
    IBOutlet UIView * confirmView;
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *subtitleLabel;
    IBOutlet UILabel *descriptionLabel;
}

@property (nonatomic) delete_item_yes_block yesBlock;

- (IBAction)close:(id)sender;

- (IBAction)yes:(id)sender;
- (IBAction)no:(id)sender;

+ (DeleteItemConfirmView*) showOnView:(UIView*) view title:(NSString *)title subtitle:(NSString *)subtitle description:(NSString *)description;

@end
