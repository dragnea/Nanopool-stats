//
//  NSManagedObject+Additions.h
//  Nanopool
//
//  Created by Mihai Dragnea on 9/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (NSManagedObject_Additions)

+ (NSString *)entityName;

// entity creation
+ (instancetype)newEntityInContext:(NSManagedObjectContext *)context name:(NSString *)name;
+ (instancetype)entityInContext:(NSManagedObjectContext *)context name:(NSString *)name key:(NSString *)key value:(id)value shouldCreate:(BOOL)shouldCreate;
+ (instancetype)temporaryEntityInContext:(NSManagedObjectContext *)context;

// entities fetch
+ (NSArray *)entitiesInContext:(NSManagedObjectContext *)context;
+ (NSArray *)entitiesInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate;
+ (NSArray *)entitiesInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate sortDescriptors:(NSArray <NSSortDescriptor *> *)sortDescriptors;
+ (NSArray *)entitiesInContext:(NSManagedObjectContext *)context
                     predicate:(NSPredicate *)predicate
               sortDescriptors:(NSArray <NSSortDescriptor *> *)sortDescriptors
                         count:(NSInteger)count;

// entities count
+ (NSUInteger)countEntitiesInContext:(NSManagedObjectContext *)context;
+ (NSUInteger)countEntitiesInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate;

// instance handlers
- (void)remove;
- (NSError *)save;

- (BOOL)setValue:(id)value forAttribute:(NSString *)attribute dateFormatter:(NSDateFormatter *)dateFormatter;
- (void)updateWithDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter;

- (void)addEntity:(id)entity forRelationship:(NSString *)relationship;
- (void)removeEntities:(NSSet *)entities forRelationship:(NSString *)relationship;

- (BOOL)isEqualWithObject:(id)object;

@end
