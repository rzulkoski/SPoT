//
//  SPoTViewController.m
//  SPoT
//
//  Created by Ryan Zulkoski on 2/20/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "SPoTViewController.h"

@interface SPoTViewController ()

@end

@implementation SPoTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Display the contents of the array returned from calling stanfordPhotos
	NSLog(@"Array from calling stanfordPhotos");
    NSLog(@"=================================");
    NSLog(@"%@", [FlickrFetcher stanfordPhotos]);
}

@end
