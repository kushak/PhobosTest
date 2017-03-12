//
//  OSTransaction.h
//  PhobosTest
//
//  Created by user on 11.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CategoryCosmo = 5001,
    CategoryMagic = 5002,
    CategoryGameof = 5003,
    CategorySuits = 5004,
    CategoryBreakingbad = 5005,
    CategoryLordof = 5006
} Category;

@interface OSTransaction : NSObject

@property (nonatomic, strong) NSString* date;
@property (nonatomic, strong) NSString* details;
@property (nonatomic, assign) NSInteger categoryID;
@property (nonatomic, assign) NSInteger amount;

- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
