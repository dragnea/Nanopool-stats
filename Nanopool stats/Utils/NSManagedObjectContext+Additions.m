//
//  NSManagedObjectContext+Additions.m
//  Nanopool
//
//  Created by Mihai Dragnea on 9/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "NSManagedObjectContext+Additions.h"

@implementation NSManagedObjectContext (NSManagedObjectContext_Additions)

- (NSFetchRequest *)requestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors count:(NSInteger)count {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = sortDescriptors;
    fetchRequest.fetchLimit = count;
    return fetchRequest;
}

- (NSArray *)entitesWithName:(NSString *)entityName {
    NSFetchRequest *request = [self requestWithEntityName:entityName predicate:nil sortDescriptors:nil count:0];
    NSError *error = nil;
    NSArray *entities = [self executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"CoreDataController: Fetch error for entity: %@", entityName);
    }
    return entities;
}

- (NSArray *)entitesWithName:(NSString *)entityName predicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [self requestWithEntityName:entityName predicate:predicate sortDescriptors:nil count:0];
    NSError *error = nil;
    NSArray *entities = [self executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"CoreDataController: Fetch error for entity=%@; predicate=%@", entityName, predicate);
    }
    return entities;
}

- (NSArray *)entitesWithName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray <NSSortDescriptor *> *)sortDecriptors {
    NSFetchRequest *request = [self requestWithEntityName:entityName predicate:predicate sortDescriptors:sortDecriptors count:0];
    NSError *error = nil;
    NSArray *entities = [self executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"CoreDataController: Fetch error for entity=%@; predicate=%@; sortDescriptors=%@", entityName, predicate, sortDecriptors);
    }
    return entities;
}

- (NSArray *)entitesWithName:(NSString *)entityName
                   predicate:(NSPredicate *)predicate
             sortDescriptors:(NSArray <NSSortDescriptor *> *)sortDecriptors
                       count:(NSInteger)count {
    NSFetchRequest *request = [self requestWithEntityName:entityName predicate:predicate sortDescriptors:sortDecriptors count:count];
    NSError *error = nil;
    NSArray *entities = [self executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"CoreDataController: Fetch error for entity=%@; predicate=%@; sortDescriptors=%@", entityName, predicate, sortDecriptors);
    }
    return entities;
}

- (NSUInteger)countWithName:(NSString *)entityName {
    NSFetchRequest *request = [self requestWithEntityName:entityName predicate:nil sortDescriptors:nil count:0];
    NSError *error = nil;
    NSUInteger count = [self countForFetchRequest:request error:&error];
    if (error) {
        NSLog(@"CoreDataController: Fetch error for entity=%@", entityName);
    }
    return count;
}

- (NSUInteger)countWithName:(NSString *)entityName predicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [self requestWithEntityName:entityName predicate:predicate sortDescriptors:nil count:0];
    request.includesPropertyValues = NO;
    request.includesSubentities = NO;
    request.resultType = NSCountResultType;
    NSError *error = nil;
    NSUInteger count = [self countForFetchRequest:request error:&error];
    if (count == NSNotFound) {
        NSLog(@"CoreDataController: Fetching count error for entity=%@; predicate=%@. Error: %@", entityName, predicate, error.localizedDescription);
    }
    return count;
}

@end
