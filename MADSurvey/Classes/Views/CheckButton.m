//
//  CheckButton.m
//  MADSurvey
//
//  Created by seniorcoder on 6/2/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CheckButton.h"

@implementation CheckButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.adjustsImageWhenHighlighted = NO;
    
//    [self setImage:[UIImage imageNamed:@"ic_checkbox_normal"] forState:UIControlStateNormal];
    
    [self setBackgroundImage:[UIImage imageNamed:@"redBack"] forState:UIControlStateHighlighted];
    
}

@end
