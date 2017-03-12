//
//  OSDate.h
//  PhobosTest
//
//  Created by user on 11.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OSTransaction;

@interface OSDate : NSObject

@property (nonatomic, strong) NSMutableArray<OSTransaction *>* transactions;
@property (nonatomic, strong) NSString* date;

- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
