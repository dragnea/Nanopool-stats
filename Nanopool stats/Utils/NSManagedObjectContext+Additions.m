//
//  NSManagedObjectContext+Additions.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "NSManagedObjectContext+Additions.h"

@implementation NSManagedObjectContext(NSManagedObjectContext_Additions)

- (NSFetchRequest *)requestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = sortDescriptors;
    return fetchRequest;
}

- (NSArray *)entitesWithName:(NSString *)entityName {
    NSFetchRequest *request = [self requestWithEntityName:entityName predicate:nil sortDescriptors:nil];
    NSError *error = nil;
    NSArray *entities = [self executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"CoreDataController: Fetch error for entity: %@", entityName);
    }
    return entities;
}

- (NSArray *)entitesWithName:(NSString *)entityName predicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [self requestWithEntityName:entityName predicate:predicate sortDescriptors:nil];
    NSError *error = nil;
    NSArray *entities = [self executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"CoreDataController: Fetch error for entity=%@; predicate=%@", entityName, predicate);
    }
    return entities;
}

- (NSArray *)entitesWithName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray <NSSortDescriptor *> *)sortDecriptors {
    NSFetchRequest *request = [self requestWithEntityName:entityName predicate:predicate sortDescriptors:nil];
    NSError *error = nil;
    NSArray *entities = [self executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"CoreDataController: Fetch error for entity=%@; predicate=%@; sortDescriptors=%@", entityName, predicate, sortDecriptors);
    }
    return entities;
}

- (NSUInteger)countWithName:(NSString *)entityName {
    NSFetchRequest *request = [self requestWithEntityName:entityName predicate:nil sortDescriptors:nil];
    NSError *error = nil;
    NSUInteger count = [self countForFetchRequest:request error:&error];
    if (error) {
        NSLog(@"CoreDataController: Fetch error for entity=%@", entityName);
    }
    return count;
}

- (NSUInteger)countWithName:(NSString *)entityName predicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [self requestWithEntityName:entityName predicate:predicate sortDescriptors:nil];
    NSError *error = nil;
    NSUInteger count = [self countForFetchRequest:request error:&error];
    if (error) {
        NSLog(@"CoreDataController: Fetch error for entity=%@; predicate=%@", entityName, predicate);
    }
    return count;
}

@end
