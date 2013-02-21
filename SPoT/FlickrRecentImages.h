//
//  FlickrRecentImages.h
//  SPoT
//
//  Created by Ryan Zulkoski on 2/20/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_RECENT_IMAGES 20

@interface FlickrRecentImages : NSObject

+ (void)addImage:(NSDictionary *)image; // Adds Flickr image dictionary to array of recent images and stores it in NSUserDefaults
+ (NSArray *)getImages; // Retreives array of recent images sorted by most recent images first, up to a maximum of MAX_RECENT_IMAGES.

@end
