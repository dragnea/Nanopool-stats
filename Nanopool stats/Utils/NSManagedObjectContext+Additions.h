//
//  NSManagedObjectContext+Additions.h
//  Nanopool
//
//  Created by Mihai Dragnea on 9/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (NSManagedObjectContext_Additions)

- (NSArray *)entitesWithName:(NSString *)entityName;
- (NSArray *)entitesWithName:(NSString *)entityName predicate:(NSPredicate *)predicate;
- (NSArray *)entitesWithName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray <NSSortDescriptor *> *)sortDecriptors;
- (NSUInteger)countWithName:(NSString *)entityName;
- (NSUInteger)countWithName:(NSString *)entityName predicate:(NSPredicate *)predicate;

@end
