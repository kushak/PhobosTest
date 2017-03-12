//
//  OSTransactionTableViewCell.h
//  PhobosTest
//
//  Created by user on 11.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSTransaction;

@interface OSTransactionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *categoryLogo;
@property (weak, nonatomic) IBOutlet UILabel *details;
@property (weak, nonatomic) IBOutlet UILabel *amount;

- (void)fillCellWithModel:(OSTransaction *)model;

@end
