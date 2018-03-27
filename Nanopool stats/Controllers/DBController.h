//
//  DBController.h
//  Ethermine
//
//  Created by Mihai Dragnea on 3/2/18.
//  Copyright © 2018 Dragnea Mihai. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DBController : NSObject

+ (void)setupWithName:(NSString *)name;
+ (NSManagedObjectContext *)mainContext;
+ (NSManagedObjectContext *)workerContext;
+ (NSManagedObjectContext *)createConcurentContext;
+ (NSManagedObjectContext *)createMainContext;
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

@end
