//
//  DBController.m
//  Ethermine
//
//  Created by Mihai Dragnea on 3/2/18.
//  Copyright © 2018 Dragnea Mihai. All rights reserved.
//

#import "DBController.h"

static DBController *manager;

@interface DBController()
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *mainContext;
@property (nonatomic, strong) NSManagedObjectContext *workerContext;
@end

@implementation DBController

+ (void)setupWithName:(NSString *)name {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBController alloc] initWithDatabaseName:name];
    });
}

+ (NSManagedObjectContext *)mainContext {
    return manager.mainContext;
}

+ (NSManagedObjectContext *)workerContext {
    return manager.workerContext;
}

+ (NSManagedObjectContext *)createConcurentContext {
    return [manager createConcurentContext];
}

+ (NSManagedObjectContext *)createMainContext {
    return [manager createMainContext];
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    return manager.persistentStoreCoordinator;
}

- (id)initWithDatabaseName:(NSString *)DBName {
    if (self = [super init]) {
        
        NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:DBName ofType:@"momd"]];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSDictionary *psOptions = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *psURL = [documentsURL URLByAppendingPathComponent:[DBName stringByAppendingPathExtension:@"sqlite"]];
        
        // copy prepopulated sql if needed
        if (![[NSFileManager defaultManager] fileExistsAtPath:psURL.path]) {
            
            NSString *shmExtension = @"sqlite-shm";
            NSString *walExtension = @"sqlite-wal";
            
            NSString *sqliteSource = [[NSBundle mainBundle] pathForResource:DBName ofType:@"sqlite"];
            NSString *shmSource = [[NSBundle mainBundle] pathForResource:DBName ofType:shmExtension];
            NSString *walSource = [[NSBundle mainBundle] pathForResource:DBName ofType:walExtension];
            
            NSString *sqliteDestination = psURL.path;
            NSString *shmDestination = [documentsURL URLByAppendingPathComponent:[DBName stringByAppendingPathExtension:shmExtension]].path;
            NSString *walDestination = [documentsURL URLByAppendingPathComponent:[DBName stringByAppendingPathExtension:walExtension]].path;
            
            NSError *error = nil;
            if (!sqliteSource || ![[NSFileManager defaultManager] copyItemAtPath:sqliteSource toPath:sqliteDestination error:&error]) {
                NSLog(@"DBManager: Eror copying sqlite file: %@", error.localizedDescription);
            }
            if (!shmSource || ![[NSFileManager defaultManager] copyItemAtPath:shmSource toPath:shmDestination error:&error]) {
                NSLog(@"DBManager: Eror copying sqlite-shm file: %@", error.localizedDescription);
            }
            if (!walSource || ![[NSFileManager defaultManager] copyItemAtPath:walSource toPath:walDestination error:&error]) {
                NSLog(@"DBManager: Eror copying sqlite-wal file: %@", error.localizedDescription);
            }
        }
        
        NSError *error = nil;
        NSPersistentStore *ps = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:psURL options:psOptions error:&error];
        if (!ps) {
            NSLog(@"DBManager: Error adding  persistent store. Error %@", error.localizedDescription);
            NSError *deleteError = nil;
            if (![[NSFileManager defaultManager] removeItemAtURL:psURL error:&deleteError]) {
                error = nil;
                ps = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:psURL options:psOptions error:&error];
            }
            
            if (!ps) {
                NSLog(@"DBManager: Failed to create persistent store. Error %@. Delete error %@", error.localizedDescription, deleteError.localizedDescription);
                // TODO: send DB issue to UI
            }
        }
        
        if (ps != nil) {
            _mainContext = [self createMainContext];
            _workerContext = [self createConcurentContext];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
            //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextWillSaveNotification:) name:NSManagedObjectContextWillSaveNotification object:nil];
            
        }
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
}

- (void)contextDidSaveNotification:(NSNotification *)note {
    NSManagedObjectContext *context = note.object;
    if (context.persistentStoreCoordinator == self.persistentStoreCoordinator && self.mainContext != context) {
        void (^mergeChanges)(void) = ^(void) {
            [self.mainContext mergeChangesFromContextDidSaveNotification:note];
            if (!context.hasChanges) {
                [context performBlock:^{
                    [context reset];
                }];
            }
        };
        if (context.concurrencyType == NSMainQueueConcurrencyType) {
            mergeChanges();
        } else {
            [self.mainContext performBlock:^{
                mergeChanges();
            }];
        }
    }
}

- (NSManagedObjectContext *)createConcurentContext {
    return [self createContextWithConcurencyType:NSPrivateQueueConcurrencyType];
}

- (NSManagedObjectContext *)createMainContext {
    return [self createContextWithConcurencyType:NSMainQueueConcurrencyType];
}

- (NSManagedObjectContext *)createContextWithConcurencyType:(NSManagedObjectContextConcurrencyType)concurencyType {
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (!coordinator) {
        return nil;
    }
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurencyType];
    context.persistentStoreCoordinator = coordinator;
    context.mergePolicy = [[NSMergePolicy alloc] initWithMergeType:NSMergeByPropertyObjectTrumpMergePolicyType];
    context.undoManager = nil;
    return context;
}

@end
