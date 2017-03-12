//
//  OSTransaction.m
//  PhobosTest
//
//  Created by user on 11.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import "OSTransaction.h"

@implementation OSTransaction

- (id) initWithServerResponse:(NSDictionary*) responseObject {
    self = [super init];
    if (self) {
        self.details = [responseObject objectForKey:@"details"];
        self.categoryID = [[[responseObject objectForKey:@"category"] objectForKey:@"id"] integerValue];
        self.amount = [[[responseObject objectForKey:@"money"] objectForKey:@"amount"] integerValue];
    }
    return self;
}

@end
