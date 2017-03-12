//
//  OSServerManager.m
//  PhobosTest
//
//  Created by user on 11.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import "OSServerManager.h"
#import "AFNetworking.h"
#import "OSDate.h"
#import "OSTransaction.h"
#import "MGCacheManager.h"

@interface OSServerManager()

@property(strong,nonatomic)AFHTTPSessionManager *manager;

@end

@implementation OSServerManager

static NSString* path = @"transactionList";

+(OSServerManager*) sharedManager {
    static OSServerManager* manager=nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[OSServerManager alloc]init];
    });
    
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        NSURL* url = [NSURL URLWithString:@"http://mobile165.hr.phobos.work/"];
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}

-(void) getTransactionList: (void(^)(NSArray*, NSInteger)) success
                   onError: (void(^)(void)) failure {
    [self getTransactionListFromServer:^(id JSON) {
        NSInteger balance = [[[JSON objectForKey:@"user"]
                              objectForKey:@"balance"]
                             integerValue];
        NSDictionary* feed = [JSON objectForKey:@"feed"];
        NSArray* datesKeys = [[feed allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj2 compare:obj1];
        }];
        NSMutableArray<OSDate*>* dates = [NSMutableArray array];
        
        for (NSInteger i = 0; i < datesKeys.count; i++) {
            OSDate* date = [[OSDate alloc]
                            initWithServerResponse: [feed objectForKey: datesKeys[i]]];
            date.date = datesKeys[i];
            [dates addObject:date];
        }
        if(success) {
            success(dates, balance);
        }
    } onError:^{
        failure();
    }];
}

-(void) getTransactionListFromServer: (void (^)(id JSON))complete
                             onError: (void(^)(void)) failure {
    
    BOOL cachableButFileNotFound = NO;
    if ([MGCacheManager endPointsContainsEndPoint:path]) {
        NSLog(@"YES Contains path");
        if ([MGCacheManager validateEndPointCacheFileExistanceForEndPoint:path]) {
            NSLog(@"YES Fild Found");
            complete([MGCacheManager loadDataFromCacheForEndPoint:path]);
            return;
        } else {
            cachableButFileNotFound = YES;
        }
    }
    [self.manager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    [self.manager GET: @"list"
           parameters: nil progress:nil
              success: ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSLog(@"%@", responseObject);
                  if(complete != nil) {
                      if (cachableButFileNotFound) {
                          if(complete != nil) complete([MGCacheManager saveAndReturnEndPointResponse:responseObject endPoint:path]);
                      } else {
                          if(complete != nil) complete(responseObject);
                      }
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"Eror");
                  failure();
              }];
}

-(void) getRefreshedTransactionList: (void(^)(NSArray*, NSInteger)) success
                            onError: (void(^)(void)) failure {
    
    [self.manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [self.manager GET: @"list"
           parameters: nil progress:nil
              success: ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSLog(@"%@", responseObject);
                  [MGCacheManager saveAndReturnEndPointResponse:responseObject endPoint:path];

                  [self getTransactionList:^(NSArray * dates, NSInteger balance) {
                      success(dates, balance);
                  } onError:^{
                      failure();
                  }];
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
              }];
}
@end
