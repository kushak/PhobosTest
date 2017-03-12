//
//  OSDate.m
//  PhobosTest
//
//  Created by user on 11.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import "OSDate.h"
#import "OSTransaction.h"

@implementation OSDate

- (id) initWithServerResponse:(NSArray*) responseObject {
    self = [super init];
    if (self) {
        self.transactions = [NSMutableArray array];
        for (NSDictionary* transactionDic in responseObject) {
            OSTransaction* transaction = [[OSTransaction alloc] initWithServerResponse: transactionDic];
            transaction.date = self.date;
            [self.transactions addObject: transaction];
        }
    }
    return self;
}

@end
