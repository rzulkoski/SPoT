//
//  FeaturedFlickerTagTVC.m
//  SPoT
//
//  Created by Ryan Zulkoski on 2/20/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "FeaturedFlickerTagTVC.h"
#import "FlickrFetcher.h"

#define TAG_DESCRIPTION @"Tag_Desc"
#define TAG_INDEXES_OF_PHOTOS @"Tag_Indexes_Of_Photos"

#define IGNORED_TAGS @[@"cs193pspot",@"portrait",@"landscape"]

@interface FeaturedFlickerTagTVC ()
@property (strong, nonatomic) NSArray *photos; // Array of NSDictionaries
@property (strong, nonatomic) NSArray *tags;   // Array of NSDictionaries
@end

@implementation FeaturedFlickerTagTVC

- (NSArray *)photos
{
    if (!_photos) {
        _photos = [FlickrFetcher stanfordPhotos];
        self.tags = nil;
    }
    return _photos;
}

- (NSArray *)tags
{
    if (!_tags) _tags = [self parseTags];
    return _tags;
}

- (NSArray *)parseTags
{
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    // Look at each photo
    for (NSDictionary *photo in self.photos) {
        // Look at each tag on each photo
        for (NSString *tag in [photo[FLICKR_TAGS] componentsSeparatedByString:@" "]) {
            // Only proceed if the tag isn't a tag we're ignoring
            if (![IGNORED_TAGS containsObject:tag]) {
                BOOL existingTagFound = NO;
                // Check if the current tag already exists in our list of tags
                for (NSMutableDictionary *existingTag in tags) {
                    if ([tag isEqualToString:existingTag[TAG_DESCRIPTION]]) { // If tag already exists, add index of photo to existing array of photo indexes
                        existingTagFound = YES;
                        [existingTag[TAG_INDEXES_OF_PHOTOS] addObject:@([self.photos indexOfObject:photo])];
                        break;
                    }
                }
                if (!existingTagFound) { // If tag was not found in existing tags, add new tag and create mutable array containing index of photo as NSNumber
                    NSMutableArray *indexesOfPhotosWithTag = [[NSMutableArray alloc] initWithArray:@[@([self.photos indexOfObject:photo])]];
                    [tags addObject:[@{ TAG_DESCRIPTION : tag, TAG_INDEXES_OF_PHOTOS : indexesOfPhotosWithTag } mutableCopy]];
                }

            }
        }
    }
    // Sort the tags array by the description of the tag and return a copy of the resulting array
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:TAG_DESCRIPTION ascending:YES];
    return [[tags sortedArrayUsingDescriptors:@[sortDescriptor]] copy];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.tags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Tag" forIndexPath:indexPath];
    int tagCount = [self.tags[indexPath.row][TAG_INDEXES_OF_PHOTOS] count];

    cell.textLabel.text = [self.tags[indexPath.row][TAG_DESCRIPTION] capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photo%@", tagCount, (tagCount == 1) ? @"" : @"s"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
