//
//  Photo+Flickr.m
//  Photomania
//
//  Created by Jan Timar on 10/9/13.
//  Copyright (c) 2013 Jan Timar. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Photographer+Create.h"

@implementation Photo (Flickr)

+(Photo *)photoWithFlickerInfo:(NSDictionary *)photoDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@",[photoDictionary[FLICKR_PHOTO_ID] description]];
    
    NSError *error = nil;
    
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || matches.count > 1){
        NSLog(@"Error %@",[error localizedDescription]);
        
    } else if (matches.count == 0){
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique = [photoDictionary[FLICKR_PHOTO_ID] description];
        photo.title = [photoDictionary[FLICKR_PHOTO_TITLE] description];
        photo.subtitle = [[photoDictionary valueForKey:FLICKR_PHOTO_DESCRIPTION] description];
        photo.imageURL = [[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
        
        photo.longitude = [NSNumber numberWithDouble:[photoDictionary[FLICKR_LONGITUDE] doubleValue]];
        photo.latitude = [NSNumber numberWithDouble:[photoDictionary[FLICKR_LATITUDE] doubleValue]];
        photo.thumbnailURLString = [[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatSquare] absoluteString];
        
        NSString *photographerName = [photoDictionary[FLICKR_PHOTO_OWNER] description];
        Photographer  *photographer = [Photographer photographerWithName:photographerName inManagedObjectContext:context];
        photo.whoTook = photographer;
        
    } else {
        photo = [matches lastObject];
    }
    
    return photo;
}

@end
