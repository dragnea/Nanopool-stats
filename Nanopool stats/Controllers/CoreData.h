//
//  CoreData.h
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreData : NSObject

+ (CoreData *)sharedInstance;
+ (NSManagedObjectContext *)mainContext;
+ (NSManagedObjectContext *)workerContext;

@end
