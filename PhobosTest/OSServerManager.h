//
//  OSServerManager.h
//  PhobosTest
//
//  Created by user on 11.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSServerManager : NSObject

+(OSServerManager*) sharedManager;

-(void) getTransactionList: (void(^)(NSArray*, NSInteger)) success
                   onError: (void(^)(void)) failure;

-(void) getTransactionListFromServer: (void (^)(id JSON))complete
                             onError: (void(^)(void)) failure;

-(void) getRefreshedTransactionList: (void(^)(NSArray*, NSInteger)) success
                            onError: (void(^)(void)) failure;

@end
