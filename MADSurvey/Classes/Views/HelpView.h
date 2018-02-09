//
//  HelpView.h
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpView : UIView <UIWebViewDelegate>
{
    IBOutlet UIView * formView;
    IBOutlet UIScrollView * helpScrollView;
    IBOutlet UILabel * tipLabel;
}

@property (nonatomic, weak) IBOutlet UIView * guideView;
@property (nonatomic, weak) IBOutlet UILabel * titleLabel;

+ (HelpView*) showOnView:(UIView*) view withTitle:(NSString*) title withImageName:(NSString *)imageName;
- (IBAction)close:(id)sender;
- (IBAction)guideTapped:(id)sender;

@end
