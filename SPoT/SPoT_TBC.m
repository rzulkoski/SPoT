//
//  SPoT_TBC.m
//  SPoT
//
//  Created by Ryan Zulkoski on 2/22/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "SPoT_TBC.h"
#include "ImageViewController.h"

@interface SPoT_TBC () //<UISplitViewControllerDelegate>
@end

@implementation SPoT_TBC

/*- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    NSLog(@"Master hidden");
    barButtonItem.title = @"Pick Image";
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    if ([detailViewController isKindOfClass:[ImageViewController class]]) {
        ImageViewController *ivc = (ImageViewController *)detailViewController;
        [ivc setSplitViewBarButtonItem:barButtonItem];
    }
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // remove the bar button from its toolbar
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    if ([detailViewController isKindOfClass:[ImageViewController class]]) {
        ImageViewController *ivc = (ImageViewController *)detailViewController;
        [ivc setSplitViewBarButtonItem:nil];
    }
}*/

@end
