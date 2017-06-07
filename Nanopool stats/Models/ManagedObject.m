//
//  ManagedObject.m
//  Nanopool stats
//
//  Created by Dragnea Mihai on 5/30/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "ManagedObject.h"

@implementation ManagedObject

+ (NSString *)entityName {
    return NSStringFromClass([self class]);
}

+ (instancetype)newEntityInContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
}

+ (instancetype)entityInContext:(NSManagedObjectContext *)context key:(NSString *)key value:(id)value shouldCreate:(BOOL)shouldCreate {
    NSPredicate *entityPredicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
    NSArray *entitiesFound = [context entitesWithName:[self entityName] predicate:entityPredicate];
    if (entitiesFound.count == 0 && shouldCreate) {
        id entity = [self newEntityInContext:context];
        [entity setValue:value forKey:key];
        return entity;
    } else {
        return entitiesFound.firstObject;
    }
}

// entities fetch
+ (NSArray *)entitiesInContext:(NSManagedObjectContext *)context {
    return [context entitesWithName:[self entityName]];
}

+ (NSArray *)entitiesInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate {
    return [context entitesWithName:[self entityName] predicate:predicate];
}

+ (NSArray *)entitiesInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate sortDescriptors:(NSArray <NSSortDescriptor *> *)sortDescriptors {
    return [context entitesWithName:[self entityName] predicate:predicate sortDescriptors:sortDescriptors];
}

// entities count
+ (NSUInteger)countEntitiesInContext:(NSManagedObjectContext *)context {
    return [context countWithName:[self entityName]];
}

+ (NSUInteger)countEntitiesInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate {
    return [context countWithName:[self entityName] predicate:predicate];
}

// instance handlers
- (void)remove {
    [self.managedObjectContext deleteObject:self];
}

- (BOOL)setValue:(id)value forAttribute:(NSString *)attribute {
    
    if (attribute.length == 0) {
        
        return NO;
        
    } else {
        
        NSAttributeDescription *attributeDescription = self.entity.attributesByName[attribute];
        
        if (!attributeDescription) {
            
            return NO;
            
        } else if (value == nil ||
                   [value isKindOfClass:[NSNull class]]) {
            
            [self setValue:nil forKey:attribute];
            return YES;
            
        } else {
            
            id formattedValue = nil;
            
            switch (attributeDescription.attributeType) {
                case NSStringAttributeType:
                    if ([value isKindOfClass:[NSString class]]) {
                        formattedValue = value;
                    } else {
                        formattedValue = nil;
                    }
                    break;
                    
                case NSDateAttributeType:
                    if ([value isKindOfClass:[NSString class]]) {
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                        formattedValue = [dateFormatter dateFromString:value];
                    } else if ([value isKindOfClass:[NSNumber class]]) {
                        formattedValue = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
                    } else {
                        formattedValue = nil;
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

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        
        for (NSString *attribute in dictionary.allKeys) {
            
            if (![self.entity.attributesByName.allKeys containsObject:attribute]) {
                
                continue;
                
            } else if ([dictionary[attribute] isKindOfClass:[NSNull class]]) {
                
                [self setValue:nil forKey:attribute];
                
            } else {
                
                [self setValue:dictionary[attribute] forAttribute:attribute];
                
            }
        }
        
    }
}

@end
