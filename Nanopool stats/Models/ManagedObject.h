//
//  ManagedObject.h
//  Nanopool stats
//
//  Created by Dragnea Mihai on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ManagedObject : NSManagedObject

+ (NSString *)entityName;

// entity creation
+ (instancetype)newEntityInContext:(NSManagedObjectContext *)context;
+ (instancetype)entityInContext:(NSManagedObjectContext *)context key:(NSString *)key value:(id)value shouldCreate:(BOOL)shouldCreate;

// entities fetch
+ (NSArray *)entitiesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)entitiesInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate;
+ (NSArray *)entitiesInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate sortDescriptors:(NSArray <NSSortDescriptor *> *)sortDescriptors;

// entities count
+ (NSUInteger)countEntitiesInContext:(NSManagedObjectContext *)context;
+ (NSUInteger)countEntitiesInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate;

// instance handlers
- (void)remove;

- (BOOL)setValue:(id)value forAttribute:(NSString *)attribute;
- (void)updateWithDictionary:(NSDictionary *)dictionary;

@end
