//
//  HelpView.h
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MADWaitingView : UIView {
    IBOutlet UILabel * titleLabel;
    IBOutlet UIView * coverView;
}

+ (MADWaitingView *)showOnView:(UIView *)view withTitle:(NSString *)title;
- (void)dismiss;

@end
