//
//  NanopoolController.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "NanopoolController.h"
#import "CoreData.h"
#import "AFNetworking.h"

typedef void(^APICompletionHandler)(NSDictionary *responseObject, NSString *error);

@interface NanopoolController ()
@property (nonatomic, strong) AFHTTPSessionManager *apiManager;
@property (nonatomic, strong) NSString *apiURLString;
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
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.apiManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
        self.apiManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.apiManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        self.apiManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.apiURLString = @"https://api.nanopool.org/v1";
        
    }
    return self;
}

- (void)getWithAccountType:(AccountType)accountType endpoint:(NSString *)endpoint address:(NSString *)address completion:(APICompletionHandler)completion {
    
    NSString *poolType;
    switch (accountType) {
        case AccountTypeEthereum:
            poolType = @"eth";
            break;
            
        default:
            poolType = @"";
            break;
    }
    
    NSString *stringURL = [[[self.apiURLString stringByAppendingPathComponent:poolType] stringByAppendingPathComponent:endpoint] stringByAppendingPathComponent:address];
    [self.apiManager GET:stringURL parameters:nil progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if (completion) {
                         id response;
                         NSString *error;
                         if (![responseObject[@"status"] boolValue]) {
                             response = nil;
                             error = responseObject[@"error"];
                         } else {
                             response = responseObject;
                             error = nil;
                         }
                         completion(response, error);
                     }
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (completion) {
                         completion(nil, error.localizedDescription);
                     }
                 }
     ];
}

- (void)addAccountWithType:(AccountType)accountType name:(NSString *)name address:(NSString *)address completion:(completionBlock)completion {
    // check miner account
    
    [self getWithAccountType:accountType endpoint:@"accountexist" address:address completion:^(NSDictionary *responseObject, NSString *error) {
        if (!error) {
            NSManagedObjectContext *workerContext = [CoreData workerContext];
            [workerContext performBlock:^{
                Account *account = [Account entityInContext:workerContext key:@"address" value:address shouldCreate:YES];
                account.name = name;
                account.type = accountType;
                NSError *saveError = nil;
                if (![workerContext save:&saveError]) {
                    completion(saveError.localizedDescription);
                } else {
                    completion(nil);
                }
            }];
        } else {
            completion(error);
        }
    }];
    
}

@end
