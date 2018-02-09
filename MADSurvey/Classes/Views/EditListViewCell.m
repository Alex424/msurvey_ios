//
//  EditListViewCell.m
//  MADSurvey
//
//  Created by seniorcoder on 11/5/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "EditListViewCell.h"
#import "Constants.h"

@implementation EditListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    titleLabel.textColor = [UIColor whiteColor];
    
    deleteButton.layer.cornerRadius = 5;
    deleteButton.clipsToBounds = YES;
    
    [deleteButton addTarget:self action:@selector(onDelete:) forControlEvents:UIControlEventTouchUpInside];

    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectedBackgroundView.backgroundColor =     UIListSelectionColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setTitle:(NSString *)title {
    titleLabel.text = title;
}

- (void)onDelete:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteItem:)]) {
        [self.delegate deleteItem:self];
    }
}

@end
