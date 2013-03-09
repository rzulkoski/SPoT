//
//  FlickrPhotoCache.h
//  SPoT
//
//  Created by Ryan Zulkoski on 3/6/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPhotoCache : NSObject

+ (UIImage *)fetchImageForPhoto:(NSDictionary *)photo;

@end
