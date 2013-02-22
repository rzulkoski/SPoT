//
//  FlickrRecentImages.m
//  SPoT
//
//  Created by Ryan Zulkoski on 2/20/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "FlickrRecentImages.h"
#import "FlickrFetcher.h"
#import "RZTools.h"

#define RECENT_IMAGES_KEY @"Recent_Images"
#define FLICKR_LAST_VIEWED_KEY @"Last_Viewed"

@implementation FlickrRecentImages

// Retrieves the list of recent images from NSUserDefaults. If the list already contains the image,
// it will remove its old reference in the list. If it cannot find itself in the list, it will remove
// the oldest object on the list. At this point the image will now add itself to the most recent
// position in the list since room has been made for it.
+ (void)addImage:(NSDictionary *)image
{
    NSMutableDictionary *mutableImage = [image mutableCopy];
    NSMutableArray *recentImages = [[self getImages] mutableCopy];
    BOOL foundImageInRecentImages = NO;
    
    mutableImage[FLICKR_LAST_VIEWED_KEY] = [NSDate date];
    for (NSDictionary *recentImage in recentImages) {
        if ([recentImage[FLICKR_PHOTO_ID] isEqualToString:mutableImage[FLICKR_PHOTO_ID]]) {
            foundImageInRecentImages = YES;
            [recentImages removeObject:recentImage];
            break;
        }
    }
    if (!foundImageInRecentImages) {
        if ([recentImages count] > MAX_RECENT_IMAGES - 1) {
            [recentImages removeLastObject];
        }
    }
    
    [recentImages insertObject:[mutableImage copy] atIndex:0];

    [[NSUserDefaults standardUserDefaults] setObject:recentImages forKey:RECENT_IMAGES_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Retrieves the list of images from NSUserDefaults and sorts it from most recent to oldest. If the
// list is longer than the maximum number of recent images to be stored, it will then prune it down
// by removing the last object in the list until it is at the maximum number of images. It will then
// return the list of sorted recent images.
+ (NSArray *)getImages
{
    NSArray *recentImages = [[NSUserDefaults standardUserDefaults] arrayForKey:RECENT_IMAGES_KEY];
    if (recentImages) {
        NSMutableArray *sortedRecentImages = [[RZTools sortArrayOfDictionaries:recentImages usingKey:FLICKR_LAST_VIEWED_KEY ascending:NO] mutableCopy];
        
        while ([sortedRecentImages count] > MAX_RECENT_IMAGES) {
            [sortedRecentImages removeLastObject];
        }

        return [sortedRecentImages copy];
    } else {
       return [[NSArray alloc] init]; 
    }
}

@end
