//
//  RZGamerSort.m
//  SPoT
//
//  Created by Ryan Zulkoski on 2/20/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "RZTools.h"

uint networkReferenceCount = 0;

@implementation RZTools

// Takes an NSArray of NSDictionaries and sorts it by
// a key into the dictionaries in the order specified.
// It will then return the sorted array of dictionaries.
+ (NSArray *)sortArrayOfDictionaries:(NSArray *)array
                            usingKey:(NSString *)key
                           ascending:(BOOL)ascending
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    return [array sortedArrayUsingDescriptors:@[sortDescriptor]];
}

+ (void)enableNetworkActivityIndicator {
    networkReferenceCount++;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

+ (void)disableNetworkActivityIndicator {
    if (networkReferenceCount > 0) {
        networkReferenceCount--;
    }
    if (networkReferenceCount == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

@end
