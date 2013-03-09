//
//  FlickrPhotoCache.m
//  SPoT
//
//  Created by Ryan Zulkoski on 3/6/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "FlickrPhotoCache.h"
#import "FlickrFetcher.h"
#import "RZTools.h"

@implementation FlickrPhotoCache

+ (UIImage *)fetchImageForPhoto:(NSDictionary *)photo
{
    UIImage *image = [[UIImage alloc] initWithData:[self retrieveImageDataForPhoto:photo]];
    NSLog(@"Existing Image%@Found!", image ? @" " : @" NOT ");
        
    if (!image) {
        NSURL *imageURL = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
        
        [RZTools enableNetworkActivityIndicator];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
        [RZTools disableNetworkActivityIndicator];
        
        [self storeImageData:imageData forPhoto:photo];
        image = [[UIImage alloc] initWithData:imageData];
    }
    
    return image;
}

+ (NSData *)retrieveImageDataForPhoto:(NSDictionary *)photo
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *urls = [fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL *imageFileURL = [urls[0] URLByAppendingPathComponent:[NSString stringWithFormat:@"Photos/%@",[self imageFilenameForPhoto:photo]]];
    NSString *cachePath = [urls[0] path];
    NSString *photosPath = [cachePath stringByAppendingPathComponent:@"Photos"];

    [fileManager createDirectoryAtPath:photosPath withIntermediateDirectories:NO attributes:nil error:nil];
    NSLog(@"Contents of Dir \"%@\": %@", cachePath, [fileManager contentsOfDirectoryAtPath:cachePath error:nil]);
    NSLog(@"Contents of Dir \"%@\": %@", photosPath, [fileManager contentsOfDirectoryAtPath:photosPath error:nil]);
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileURL];
    
    return imageData;
}

+ (void)storeImageData:(NSData *)imageData forPhoto:(NSDictionary *)photo
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *urls = [fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL *imageFileURL = [urls[0] URLByAppendingPathComponent:[NSString stringWithFormat:@"Photos/%@",[self imageFilenameForPhoto:photo]]];
    
    NSLog(@"Image File URL = %@", imageFileURL);
    
    [imageData writeToURL:imageFileURL atomically:YES];
}

+ (NSString *)imageFilenameForPhoto:(NSDictionary *)photo
{
    NSString *photoID = [photo objectForKey:@"id"];
    NSString *photoFormatExt = [photo objectForKey:@"originalformat"];
    
    return [NSString stringWithFormat:@"%@.%@", photoID, photoFormatExt];
}

@end
