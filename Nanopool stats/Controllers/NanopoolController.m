//
//  NanopoolController.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "NanopoolController.h"
#import "DBController.h"
#import "Worker.h"
#import "Payment.h"
#import "Share.h"
#import "AccountChartData.h"
#import "AFNetworking.h"

typedef void(^APICompletionHandler)(id responseObject, NSString *error);

@interface NanopoolController ()
@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;
@property (nonatomic, strong) NSString *apiStringURL;
@end

@implementation NanopoolController

- (instancetype)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.dragneamihai.api"];
        self.httpSessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
        self.httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.httpSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        self.httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.httpSessionManager.securityPolicy.allowInvalidCertificates = YES;
        self.apiStringURL = @"https://api.nanopool.org/v1";
    }
    return self;
}

#pragma mark - public methods

+ (NanopoolController *)sharedInstance {
    static NanopoolController *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[NanopoolController alloc] init];
    });
    return staticInstance;
}

- (NSURLSessionDataTask *)getWithType:(AccountType)type endpoint:(NSString *)endpoint address:(NSString *)address completion:(APICompletionHandler)completion {
    NSString *typeString = [Account apiForType:type];
    NSString *get = [[[self.apiStringURL stringByAppendingPathComponent:typeString] stringByAppendingPathComponent:endpoint] stringByAppendingPathComponent:address];
    return [self.httpSessionManager GET:get parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil, error.localizedDescription);
        }
    }];
    /* :TODO implement this function
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];
     if ([userDefaults doubleForKey:@"last_update"] < currentTimestamp - 60.0f) {
     
     [userDefaults setDouble:currentTimestamp forKey:@"last_update"];
     [userDefaults synchronize];
     
     
     
     } else {
     
     return nil;
     
     }
     */
}

- (Account *)accountWithAddress:(NSString *)address type:(AccountType)type context:(NSManagedObjectContext *)context shouldCreate:(BOOL)shouldCreate {
    NSPredicate *accountPredicate = [NSPredicate predicateWithFormat:@"address = %@ AND type = %d", address, type];
    Account *account = [context entitesWithName:@"Account" predicate:accountPredicate].firstObject;
    if (!account && shouldCreate) {
        account = [Account newEntityInContext:context name:@"Account"];
        account.address = address;
        account.type = type;
    }
    return account;
}

- (void)updateAccount:(Account *)account {
    AccountType type = account.type;
    NSString *address = account.address;
    __weak __typeof(self) weakSelf = self;
    [self getWithType:type endpoint:@"user" address:address completion:^(id responseObject, NSString *error) {
        NSManagedObjectContext *context = [DBController workerContext];
        [context performBlock:^{
            Account *account = [weakSelf accountWithAddress:address type:type context:context shouldCreate:YES];
            account.balance = [responseObject[@"data"][@"balance"] doubleValue];
            account.hashrate = [responseObject[@"data"][@"hashrate"] doubleValue];
            account.avgHashrate = responseObject[@"data"][@"avghashrate"];
            account.lastUpdate = [NSDate date];
            for (NSDictionary *workerDictionary in responseObject[@"workers"]) {
                Worker *worker = [Worker entityInContext:context name:@"Worker" key:@"id" value:workerDictionary[@"id"] shouldCreate:YES];
                [worker updateWithDictionary:workerDictionary dateFormatter:nil];
                worker.account = account;
            }
            NSError *error = nil;
            if (![context save:&error]){
                NSLog(@"error saving user info... %@", error.localizedDescription);
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:NanopoolControllerDidUpdateAccountNotification object:account.objectID];
                });
            }
        }];
    }];
}

- (void)updateChartDataWithAccount:(Account *)account {
    AccountType type = account.type;
    NSString *address = account.address;
    __weak __typeof(self) weakSelf = self;
    [self getWithType:type endpoint:@"hashratechart" address:address completion:^(id responseObject, NSString *error) {
        NSManagedObjectContext *context = [DBController workerContext];
        [context performBlock:^{
            Account *account = [weakSelf accountWithAddress:address type:type context:context shouldCreate:YES];
            NSError *error = nil;
            if (account.chartData.count) {
                NSArray *chartIDsToRemove = [[account valueForKeyPath:@"chartData.objectID"] allObjects];
                NSBatchDeleteRequest *chartRemoveRequest = [[NSBatchDeleteRequest alloc] initWithObjectIDs:chartIDsToRemove];
                [context executeRequest:chartRemoveRequest error:&error];
            }
            for (NSDictionary *chartDataDict in responseObject[@"data"]) {
                AccountChartData *chartData = [AccountChartData newEntityInContext:context name:@"AccountChartData"];
                chartData.account = account;
                [chartData updateWithDictionary:chartDataDict dateFormatter:nil];
            }
            if (![context save:&error]){
                NSLog(@"error saving chart data info... %@", error.localizedDescription);
            } else {
                
            }
        }];
    }];
}

- (void)updatePaymentsWithAccount:(Account *)account {
    AccountType type = account.type;
    NSString *address = account.address;
    [self getWithType:type endpoint:@"payments" address:address completion:^(id responseObject, NSString *error) {
        NSManagedObjectContext *context = [DBController workerContext];
        [context performBlock:^{
            Account *account = [Account entityInContext:context name:@"Account" key:@"address" value:address shouldCreate:YES];
            for (NSDictionary *paymentDict in responseObject[@"data"]) {
                Payment *payment = [Payment entityInContext:context name:@"Payment" key:@"txHash" value:paymentDict[@"txHash"] shouldCreate:YES];
                [payment updateWithDictionary:paymentDict dateFormatter:nil];
                payment.account = account;
            }
            NSError *error = nil;
            if (![context save:&error]){
                NSLog(@"error saving payments info... %@", error.localizedDescription);
            } else {
                
            }
        }];
    }];
}

- (void)verifyAccountType:(AccountType)accountType address:(NSString *)address completion:(NanopoolControllerBlock)completion {
    NSPredicate *accountPredicate = [NSPredicate predicateWithFormat:@"address = %@ AND type = %d", address, accountType];
    if (![Account countEntitiesInContext:[DBController mainContext] predicate:accountPredicate]) {
        [self getWithType:accountType endpoint:@"accountexist" address:address completion:^(id responseObject, NSString *error) {
            if (completion) {
                completion(error);
            }
        }];
    } else {
        if (completion) {
            completion(@"The wallet address already exists");
        }
    }
}

- (void)addAccount:(AccountType)accountType address:(NSString *)address name:(NSString *)name {
    NSManagedObjectContext *context = [DBController mainContext];
    NSBatchUpdateRequest *batchUpdateRequest = [[NSBatchUpdateRequest alloc] initWithEntityName:@"Account"];
    batchUpdateRequest.predicate = [NSPredicate predicateWithFormat:@"isCurrent = YES"];
    batchUpdateRequest.propertiesToUpdate = @{@"isCurrent": @NO};
    NSError *error = nil;
    [context executeRequest:batchUpdateRequest error:&error];
    if (error) {
        // TODO: handle batch update error
        return;
    }
    Account *account = [Account entityInContext:[DBController mainContext] name:@"Account" key:@"address" value:address shouldCreate:YES];
    account.name = name;
    account.type = accountType;
    account.isCurrent = YES;
    if (![context save:&error]) {
        // TODO: handle save error
        NSLog(@"error saving payments info... %@", error.localizedDescription);
    } else {
        [self updateAccount:account];
        [self updateChartDataWithAccount:account];
    }
}

@end
