//
//  NSManagedObject+Additions.m
//  Nanopool
//
//  Created by Mihai Dragnea on 9/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "NSManagedObject+Additions.h"

@implementation NSManagedObject (NSManagedObjectAdditions)

+ (NSString *)entityName {
    return NSStringFromClass([self class]);
}

+ (instancetype)newEntityInContext:(NSManagedObjectContext *)context name:(NSString *)name {
    NSString *entityName;
    if (!name) {
        entityName = [self entityName];
    } else {
        entityName = name;
    }
    if (!context || !entityName) {
        return nil;
    } else {
        return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    }
}

+ (instancetype)entityInContext:(NSManagedObjectContext *)context name:(NSString *)name key:(NSString *)key value:(id)value shouldCreate:(BOOL)shouldCreate {
    if (!value || [value isKindOfClass:[NSNull class]] || !key.length) {
        return nil;
    }
    NSString *entityName;
    if (!name.length) {
        entityName = [self entityName];
    } else {
        entityName = name;
    }
    NSPredicate *entityPredicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
    NSArray *entitiesFound = [context entitesWithName:entityName predicate:entityPredicate];
    if (entitiesFound.count == 0 && shouldCreate) {
        id entity = [self newEntityInContext:context name:entityName];
        [entity setValue:value forKey:key];
        return entity;
    } else {
        return entitiesFound.firstObject;
    }
}

+ (instancetype)temporaryEntityInContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    return [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
}

// entities fetch
+ (NSArray *)entitiesInContext:(NSManagedObjectContext *)context {
    NSString *entityName = [self entityName];
    if (!context || !entityName) {
        return nil;
    } else {
        return [context entitesWithName:entityName];
    }
}

+ (NSArray *)entitiesInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate {
    NSString *entityName = [self entityName];
    if (!context || !entityName) {
        return nil;
    } else {
        return [context entitesWithName:entityName predicate:predicate];
    }
}

+ (NSArray *)entitiesInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate sortDescriptors:(NSArray <NSSortDescriptor *> *)sortDescriptors {
    NSString *entityName = [self entityName];
    if (!context || !entityName) {
        return nil;
    } else {
        return [context entitesWithName:entityName predicate:predicate sortDescriptors:sortDescriptors];
    }
}

+ (NSArray *)entitiesInContext:(NSManagedObjectContext *)context
                     predicate:(NSPredicate *)predicate
               sortDescriptors:(NSArray <NSSortDescriptor *> *)sortDescriptors
                         count:(NSInteger)count {
    NSString *entityName = [self entityName];
    if (!context || !entityName) {
        return nil;
    } else {
        return [context entitesWithName:entityName predicate:predicate sortDescriptors:sortDescriptors];
    }
}

// entities count
+ (NSUInteger)countEntitiesInContext:(NSManagedObjectContext *)context {
    NSString *entityName = [self entityName];
    if (!context || !entityName) {
        return 0;
    } else {
        return [context countWithName:entityName];
    }
}

+ (NSUInteger)countEntitiesInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate {
    NSString *entityName = [self entityName];
    if (!context || !entityName) {
        return 0;
    } else {
        return [context countWithName:entityName predicate:predicate];
    }
}

// instance handlers
- (void)remove {
    [self.managedObjectContext deleteObject:self];
}

- (NSError *)save {
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@ - Error saving. Details: %@", NSStringFromClass([self class]), error.localizedDescription);
    }
    return error;
}

- (BOOL)setValue:(id)value forAttribute:(NSString *)attribute dateFormatter:(NSDateFormatter *)dateFormatter {
    
    if (attribute.length == 0) {
        
        return NO;
        
    } else {
        
        NSAttributeDescription *attributeDescription = self.entity.attributesByName[attribute];
        
        if (!attributeDescription) {
            
            return NO;
            
        } else if (value == nil || value == [NSNull class]) {
            
            [self setValue:nil forKey:attribute];
            return YES;
            
        } else {
            
            id formattedValue = nil;
            
            switch (attributeDescription.attributeType) {
                case NSStringAttributeType:
                    if ([value isKindOfClass:[NSString class]]) {
                        formattedValue = value;
                    }
                    break;
                    
                case NSDateAttributeType:
                    if (!dateFormatter) {
                        if ([value isKindOfClass:[NSNumber class]]) {
                            if ([attributeDescription.attributeValueClassName isEqualToString:@"NSDate"]) {
                                formattedValue = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
                            } else if ([attributeDescription.attributeValueClassName isEqualToString:@"NSNumber"]) {
                                formattedValue = value;
                            } else {
                                formattedValue = nil;
                            }
                        } else if ([value isKindOfClass:[NSString class]]) {
                            if ([attributeDescription.attributeValueClassName isEqualToString:@"NSString"]) {
                                formattedValue = value;
                            } else {
                                formattedValue = nil;
                            }
                        } else {
                            formattedValue = nil;
                        }
                    } else {
                        if ([value isKindOfClass:[NSNumber class]]) {
                            if ([attributeDescription.attributeValueClassName isEqualToString:@"NSDate"]) {
                                formattedValue = [NSDate dateWithTimeIntervalSinceNow:[value doubleValue]];
                            } else if ([attributeDescription.attributeValueClassName isEqualToString:@"NSNumber"]) {
                                formattedValue = value;
                            } else {
                                formattedValue = nil;
                            }
                        } else if ([value isKindOfClass:[NSString class]]) {
                            if ([attributeDescription.attributeValueClassName isEqualToString:@"NSDate"]) {
                                formattedValue = [dateFormatter dateFromString:value];
                            } else if ([attributeDescription.attributeValueClassName isEqualToString:@"NSNumber"]) {
                                formattedValue = @([[dateFormatter dateFromString:value] timeIntervalSince1970]);
                            } else {
                                formattedValue = nil;
                            }
                        } else {
                            formattedValue = nil;
                        }
                    }
                    break;
                    
                case NSInteger16AttributeType:
                case NSInteger32AttributeType:
                case NSInteger64AttributeType:
                    formattedValue = @([value integerValue]);
                    break;
                    
                case NSDecimalAttributeType:
                    formattedValue = [NSDecimalNumber decimalNumberWithDecimal:[value decimalValue]];
                    break;
                    
                case NSBooleanAttributeType:
                    formattedValue = @([value boolValue]);
                    break;
                    
                case NSDoubleAttributeType:
                    formattedValue = @([value doubleValue]);
                    break;
                    
                case NSFloatAttributeType:
                    formattedValue = @([value floatValue]);
                    break;
                    
                case NSTransformableAttributeType:
                    formattedValue = value;
                    break;
                    
                default:
                    formattedValue = nil;
                    break;
            }
            
            [self setValue:formattedValue forKey:attribute];
            
            return YES;
            
        }
        
    }
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"Undefined key '%@' with value '%@'", key, value);
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter {
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        for (NSString *attribute in dictionary.allKeys) {
            if (![self.entity.attributesByName.allKeys containsObject:attribute]) {
                continue;
            } else if ([dictionary[attribute] isKindOfClass:[NSNull class]]) {
                [self setValue:nil forKey:attribute];
            } else {
                [self setValue:dictionary[attribute] forAttribute:attribute dateFormatter:dateFormatter];
            }
        }
    }
}

- (void)addEntity:(id)entity forRelationship:(NSString *)relationship {
    NSSet *changedObjects = [NSSet setWithObject:entity];
    [self willChangeValueForKey:relationship withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:relationship] addObject:entity];
    [self didChangeValueForKey:relationship withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
}

- (void)removeEntities:(NSSet *)entities forRelationship:(NSString *)relationship {
    [self willChangeValueForKey:relationship withSetMutation:NSKeyValueMinusSetMutation usingObjects:entities];
    [[self primitiveValueForKey:relationship] minusSet:entities];
    [self didChangeValueForKey:relationship withSetMutation:NSKeyValueMinusSetMutation usingObjects:entities];
}

- (BOOL)isEqualWithObject:(id)object {
    BOOL result = YES;
    NSEntityDescription *entityDescription = [self entity];
    for (NSString *attributeName in entityDescription.attributesByName) {
        NSAttributeDescription *attributeDescription = entityDescription.attributesByName[attributeName];
        id value = [self valueForKey:attributeName];
        id objectValue = [object valueForKey:attributeName];
        switch (attributeDescription.attributeType) {
            case NSStringAttributeType:
                if ([value length] != [objectValue length] &&
                    ![value isEqualToString:objectValue]) {
                    result = NO;
                    break;
                }
                break;
            case NSDateAttributeType:
                if (![value isEqualToDate:objectValue]) {
                    result = NO;
                    break;
                }
            default:
                if (((value == nil && objectValue != nil) ||
                    (value != nil && objectValue == nil)) &&
                    ![value isEqual:objectValue]) {
                    result = NO;
                    break;
                }
        }
    }
    for (NSString *relationshipName in entityDescription.relationshipsByName) {
        if ([self.changedValues.allKeys containsObject:relationshipName]) {
            result = NO;
            break;
        }
    }
    
    return result;
}

@end
