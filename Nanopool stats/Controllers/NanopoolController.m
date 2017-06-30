//
//  NanopoolController.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "NanopoolController.h"
#import "CoreData.h"
#import "Worker.h"
#import "Payment.h"
#import "Share.h"

typedef void(^APICompletionHandler)(NSDictionary *responseObject, NSString *error);

@interface NanopoolController ()
@property (nonatomic, strong) NSString *apiURLString;
@property (nonatomic, strong) NSOperationQueue *apiQueue;
@end

@implementation NanopoolController

+ (NanopoolController *)sharedInstance {
    static NanopoolController *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[NanopoolController alloc] init];
    });
    return staticInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        
        self.apiURLString = @"https://api.nanopool.org/v1";
        self.apiQueue = [[NSOperationQueue alloc] init];
        
    }
    return self;
}

- (id)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(__autoreleasing NSURLResponse **)responsePtr error:(__autoreleasing NSError **)errorPtr {
    dispatch_semaphore_t sem;
    __block NSData *resultedData;
    
    resultedData = nil;
    
    sem = dispatch_semaphore_create(0);
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (errorPtr != NULL) {
            *errorPtr = error;
        }
        if (responsePtr != NULL) {
            *responsePtr = response;
        }
        if (error == nil) {
            resultedData = data;
        }
        dispatch_semaphore_signal(sem);
    }] resume];
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    return [NSJSONSerialization JSONObjectWithData:resultedData options:NSJSONReadingAllowFragments error:errorPtr];
}

- (id)getPoolType:(NSString *)poolType endpoint:(NSString *)endpoint address:(NSString *)address {
    NSString *stringURL = [[[self.apiURLString stringByAppendingPathComponent:poolType] stringByAppendingPathComponent:endpoint] stringByAppendingPathComponent:address];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:stringURL]];
    return [self sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
}

- (void)updateAccount:(Account *)account inContext:(NSManagedObjectContext *)context {
    NSString *poolType = [Account apiForType:account.type];
    
    // update account info
    NSDictionary *accountInfoDictionary = [self getPoolType:poolType endpoint:@"user" address:account.address][@"data"];
    [account updateWithDictionary:accountInfoDictionary];
    account.lastUpdate = [NSDate date];
    for (NSDictionary *workerDictionary in accountInfoDictionary[@"workers"]) {
        Worker *worker = [Worker entityInContext:context key:@"id" value:workerDictionary[@"id"] shouldCreate:YES];
        [worker updateWithDictionary:workerDictionary];
        worker.account = account;
    }
    
    // update hashrates history
    account.hashrateHistory = [self getPoolType:poolType endpoint:@"history" address:account.address][@"data"];
    
    // update payments
    NSArray *paymentsArray = [self getPoolType:poolType endpoint:@"payments" address:account.address][@"data"];
    for (NSDictionary *paymentDict in paymentsArray) {
        Payment *payment = [Payment entityInContext:context key:@"txHash" value:paymentDict[@"txHash"] shouldCreate:YES];
        [payment updateWithDictionary:paymentDict];
        payment.account = account;
    }
    
    // update shares
    NSArray *sharesArray = [self getPoolType:poolType endpoint:@"shareratehistory" address:account.address][@"data"];
    for (NSDictionary *shareDict in sharesArray) {
        Share *share = [Share entityInContext:context key:@"date" value:shareDict[@"date"] shouldCreate:YES];
        share.shares = [shareDict[@"shares"] integerValue];
        share.account = account;
    }
}

#pragma mark - public methods

- (void)updateAccounts:(completionBlock)completion {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];
    if ([userDefaults doubleForKey:@"last_update"] < currentTimestamp - 60.0f) {
        
        [userDefaults setDouble:currentTimestamp forKey:@"last_update"];
        [userDefaults synchronize];
        
        NSManagedObjectContext *workerContext = [CoreData workerContext];
        [workerContext performBlock:^{
            
            NSArray *accounts = [Account entitiesInContext:workerContext];
            for (Account *account in accounts) {
                [self updateAccount:account inContext:workerContext];
            }
            NSError *saveError = nil;
            if (![workerContext save:&saveError]) {
                // TODO: handle error
            } else {
                // success
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    if (!accounts.count) {
                        completion(UIBackgroundFetchResultNoData);
                    } else if (!saveError) {
                        completion(UIBackgroundFetchResultNewData);
                    } else {
                        completion(UIBackgroundFetchResultFailed);
                    }
                }
            });
            
        }];
    }
}

- (void)addAccountWithType:(AccountType)accountType name:(NSString *)name address:(NSString *)address completion:(completionBlock)completion {
    // check miner account
    NSManagedObjectContext *workerContext = [CoreData workerContext];
    [workerContext performBlock:^{
        
        BOOL exists = [self getPoolType:[Account apiForType:accountType] endpoint:@"accountexist" address:address];
        if (exists) {
            
            Account *account = [Account entityInContext:workerContext key:@"address" value:address shouldCreate:YES];
            account.name = name;
            account.type = accountType;
            [self updateAccount:account inContext:workerContext];
            NSError *saveError = nil;
            if (![workerContext save:&saveError]) {
                // TODO: handle error
            } else {
                // success
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    if (!saveError) {
                        completion(UIBackgroundFetchResultNewData);
                    } else {
                        completion(UIBackgroundFetchResultFailed);
                    }
                }
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(UIBackgroundFetchResultNoData);
                }
            });
        }
        
    }];
}

- (void)estimatedEarningsForAddress:(NSString *)address completion:(completionResultBlock)completion {
    Account *account = [Account entityInContext:[CoreData mainContext] key:@"address" value:address shouldCreate:NO];
    NSString *poolType = [Account apiForType:account.type];
    NSString *endpoint = @"approximated_earnings";
    NSString *hashrate = [NSString stringWithFormat:@"%f", account.hashrate];
    NSString *stringURL = [[[self.apiURLString stringByAppendingPathComponent:poolType] stringByAppendingPathComponent:endpoint] stringByAppendingPathComponent:hashrate];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:stringURL]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *result = [self sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (completion) {
                completion(result);
            }
            
        });
        
    });
}

@end
