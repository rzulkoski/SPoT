//
//  FeaturedFlickerTagTVC.m
//  SPoT
//
//  Created by Ryan Zulkoski on 2/20/13.
//  Copyright (c) 2013 RZGamer. All rights reserved.
//

#import "FeaturedFlickerTagTVC.h"
#import "FlickrFetcher.h"
#import "RZTools.h"

#define TAG_DESCRIPTION @"Tag_Desc"
#define TAG_INDEXES_OF_PHOTOS @"Tag_Indexes_Of_Photos"

#define IGNORED_TAGS @[@"cs193pspot",@"portrait",@"landscape"]

@interface FeaturedFlickerTagTVC ()
@property (strong, nonatomic) NSArray *photos; // Array of NSDictionaries
@property (strong, nonatomic) NSArray *tags;   // Array of NSDictionaries
@end

@implementation FeaturedFlickerTagTVC

- (void)viewDidLoad
{
    // a UIRefreshControl inherits from UIControl, so we can use normal target/action // this is the first time you’ve seen this done without ctrl-dragging in Xcode
    [self loadFeaturedPhotosFromFlickr];
    [self.refreshControl addTarget:self
                            action:@selector(loadFeaturedPhotosFromFlickr)
                  forControlEvents:UIControlEventValueChanged];
}

// If photos hasn't been set yet, fetch Stanford photos from Flickr using Professor Hagerty's Flickr Helper code.
- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    self.tags = nil;
    [self.tableView reloadData];
}

- (IBAction)loadFeaturedPhotosFromFlickr
{
    // show the spinner if it's not already showing
    [self.refreshControl beginRefreshing];
    dispatch_queue_t loaderQ = dispatch_queue_create("flickr featured loader", NULL); dispatch_async(loaderQ, ^{
        NSArray *fetchedPhotos = [FlickrFetcher stanfordPhotos];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = fetchedPhotos;
            [self.refreshControl endRefreshing];
        });
    });
}

// If tags hasn't been set yet, set them to be the parsed tags. (which will use the photos to do so)
- (NSArray *)tags
{
    if (!_tags) _tags = [self parseTags];
    return _tags;
}

// Looks at every tag for each photo in photos (if the tag isn't to be ignored) and compares it with an array of tag dictionaries that it is building as it goes.
// If a tag has not been seen before, create a new dictionary storing the tag description and an array of indexes into the photos array that denotes each photo
// where this tag appears. If the tag is already in the array, add the index of the photo within the photos array to the tag dictionary's array of photo indexes
// that use the tag. After the array of tag dictionaries is assembled, sort it alphabetically by tag description and return the sorted array.
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

    // Sort the array of tags by tag description and return it
    return [RZTools sortArrayOfDictionaries:tags usingKey:TAG_DESCRIPTION ascending:YES];
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

    cell.textLabel.text = [self titleForRow:indexPath.row]; // Make title be the description of the tag.
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photo%@", tagCount, (tagCount == 1) ? @"" : @"s"]; // Make subtitle be the number of photos that use the tag.
    
    return cell;
}

- (NSString *)titleForRow:(NSUInteger)row
{
    return [self.tags[row][TAG_DESCRIPTION] capitalizedString];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Photos For Tag"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setPhotos:)]) {
                    NSArray *photos = [self arrayOfPhotosWithTag:[[self titleForRow:indexPath.row] lowercaseString]];
                    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:photos];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}

// Assemble an array of photos that include the specified tag by using the tag's dictionary to retrieve the array of indexes of photos that use the tag.
- (NSArray *)arrayOfPhotosWithTag:(NSString *)tag
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    int indexOfTag = -1;
    
    // Find the index of the dictionary in our tags array for our given tag
    for (int i = 0; i < [self.tags count]; i++) {
        if ([self.tags[i][TAG_DESCRIPTION] isEqualToString:tag]) {
            indexOfTag = i;
        }
    }
    
    if (indexOfTag >= 0) { // If we found the index for the dictionary, create the array of photos using our given tag
        for (NSNumber *indexOfPhoto in self.tags[indexOfTag][TAG_INDEXES_OF_PHOTOS]) {
            [photos addObject:self.photos[[indexOfPhoto intValue]]];
        }
    }
    
    // Sort the array of photos by their titles and return it
    return [RZTools sortArrayOfDictionaries:photos usingKey:FLICKR_PHOTO_TITLE ascending:YES];
}

@end
