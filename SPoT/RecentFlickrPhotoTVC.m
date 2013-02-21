//
//  RecentFlickrPhotoTVC.m
//  SPoT
//
//  Created by Ryan Zulkoski on 2/20/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "RecentFlickrPhotoTVC.h"
#import "FlickrRecentImages.h"

@interface RecentFlickrPhotoTVC ()

@end

@implementation RecentFlickrPhotoTVC

- (void)viewWillAppear:(BOOL)animated
{
    // Make sure list is up to date when recent images list is coming on screen
    self.photos = [FlickrRecentImages getImages];
}

@end
