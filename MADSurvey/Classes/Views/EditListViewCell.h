//
//  EditListViewCell.h
//  MADSurvey
//
//  Created by seniorcoder on 11/5/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditListViewCellDelegate <NSObject>

- (void)deleteItem:(UITableViewCell *)cell;

@end

@interface EditListViewCell : UITableViewCell {
    IBOutlet UIButton *deleteButton;
    
    IBOutlet UILabel *titleLabel;
}

@property (nonatomic, weak) id<EditListViewCellDelegate> delegate;

- (void)setTitle:(NSString *)title;

@end
