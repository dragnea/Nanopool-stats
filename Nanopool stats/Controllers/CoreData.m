//
//  CoreData.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "CoreData.h"

@interface CoreData ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *workerManagedObjectContext;
@end

@implementation CoreData

- (id)initWithDatabaseName:(NSString *)DBName {
    if (self = [super init]) {
        
        NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:DBName ofType:@"momd"]];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        NSPersistentStoreCoordinator *psCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSDictionary *psOptions = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *psURL = [documentsURL URLByAppendingPathComponent:[DBName stringByAppendingPathExtension:@"sqlite"]];
        NSError *error = nil;
        NSPersistentStore *ps = [psCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:psURL options:psOptions error:&error];
        if (!ps) {
            NSLog(@"CoreDataController: Error adding  persistent store. Error %@", error.localizedDescription);
            NSError *deleteError = nil;
            if (![[NSFileManager defaultManager] removeItemAtURL:psURL error:&deleteError]) {
                error = nil;
                ps = [psCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:psURL options:psOptions error:&error];
            }
            
            if (!ps) {
                NSLog(@"CoreDataController: Failed to create persistent store. Error %@. Delete error %@", error.localizedDescription, deleteError.localizedDescription);
                // TODO: send DB issue to UI
            }
        }
        
        if (ps != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            _managedObjectContext.persistentStoreCoordinator = psCoordinator;
            _managedObjectContext.mergePolicy = [[NSMergePolicy alloc] initWithMergeType:NSMergeByPropertyObjectTrumpMergePolicyType];
            
            _workerManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            _workerManagedObjectContext.persistentStoreCoordinator = psCoordinator;
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
        }
        
    }
    return self;
}

+ (CoreData *)sharedInstance {
    static CoreData *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[CoreData alloc] initWithDatabaseName:@"Database"];
    });
    return staticInstance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)contextDidSaveNotification:(NSNotification *)note {
    if (note.object == self.workerManagedObjectContext) {
        
        NSSet *updatedObjestID = [note.userInfo[NSUpdatedObjectsKey] valueForKeyPath:@"objectID"];
        
        __weak __typeof(self) weakSelf = self;
        [self.managedObjectContext performBlock:^{
            for (NSManagedObjectID *objectID in updatedObjestID) {
                [[weakSelf.managedObjectContext objectWithID:objectID] willAccessValueForKey:nil];
            }
            [weakSelf.managedObjectContext mergeChangesFromContextDidSaveNotification:note];
        }];
        if (!self.workerManagedObjectContext.hasChanges) {
            [self.workerManagedObjectContext reset];
        }
    }
}

+ (NSManagedObjectContext *)mainContext {
    return [CoreData sharedInstance].managedObjectContext;
}

+ (NSManagedObjectContext *)workerContext {
    return [CoreData sharedInstance].workerManagedObjectContext;
}

@end
