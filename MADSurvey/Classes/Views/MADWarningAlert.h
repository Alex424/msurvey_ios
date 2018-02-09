//
//  MADInfoAlert.h
//  MADSurvey
//
//  Created by seniorcoder on 6/2/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MADWarningAlert : UIView {
    IBOutlet UIView * alertView;
}

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;

+ (MADWarningAlert*) showOnView:(UIView*) view withTitle:(NSString*) title;

@end
