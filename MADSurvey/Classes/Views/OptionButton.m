//
//  OptionButton.m
//  MADSurvey
//
//  Created by seniorcoder on 6/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "OptionButton.h"

@implementation OptionButton

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
    
    [self setImage:[UIImage imageNamed:@"ic_checkbox_normal"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"ic_checkbox_checked"] forState:UIControlStateSelected];
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
}

- (void)setImageSelected:(UIImage *)imageSelected {
    _imageSelected = imageSelected;
    
    [self setImage:imageSelected forState:UIControlStateSelected];
}

@end
