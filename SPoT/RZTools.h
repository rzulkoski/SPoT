//
//  RZGamerSort.h
//  SPoT
//
//  Created by Ryan Zulkoski on 2/20/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//
//  Helper functions created by Ryan Zulkoski

#import <Foundation/Foundation.h>

@interface RZTools : NSObject

+ (NSArray *)sortArrayOfDictionaries:(NSArray *)array // Takes an NSArray of NSDictionaries and sorts it by
                            usingKey:(NSString *)key  // a key into the dictionaries in the order specified.
                           ascending:(BOOL)ascending; // It will then return the sorted array of dictionaries.

+ (void)enableNetworkActivityIndicator;
+ (void)disableNetworkActivityIndicator;

@end
