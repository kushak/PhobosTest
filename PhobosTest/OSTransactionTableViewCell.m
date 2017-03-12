//
//  OSTransactionTableViewCell.m
//  PhobosTest
//
//  Created by user on 11.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import "OSTransactionTableViewCell.h"
#import "OSTransaction.h"
#import <UIKit/UIKit.h>

@implementation OSTransactionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.categoryLogo layoutIfNeeded];
//    self.categoryLogo.layer.masksToBounds = YES;
//    self.categoryLogo.layer.cornerRadius = self.categoryLogo.frame.size.width / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)fillCellWithModel:(OSTransaction *) model {
    
    self.amount.text = [NSString stringWithFormat:@"%li ₽", (long)model.amount];
    self.details.text = model.details;
    UIImage* logo;
    switch (model.categoryID) {
        case 5001:
            logo = [UIImage imageNamed:@"cosmo"];
            break;
        case 5002:
            logo = [UIImage imageNamed:@"magic"];
            break;
        case 5003:
            logo = [UIImage imageNamed:@"gameof"];
            break;
        case 5004:
            logo = [UIImage imageNamed:@"suits"];
            break;
        case 5005:
            logo = [UIImage imageNamed:@"breakingbad"];
            break;
        case 5006:
            logo = [UIImage imageNamed:@"lordof"];
            break;
        default:
            break;
    }
    
    [self.categoryLogo layoutIfNeeded];
    self.categoryLogo.layer.masksToBounds = YES;
    self.categoryLogo.layer.cornerRadius = self.categoryLogo.frame.size.width / 2;
    self.categoryLogo.image = logo;
    
}

@end
