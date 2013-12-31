//
//  DemoPhotographerMapViewController.m
//  Photomania
//
//  Created by Jan Timar on 10/10/13.
//  Copyright (c) 2013 Jan Timar. All rights reserved.
//

#import "DemoPhotographerMapViewController.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"

@interface DemoPhotographerMapViewController ()

@end

@implementation DemoPhotographerMapViewController

-(IBAction)refresh
{
    dispatch_queue_t fetchQueue = dispatch_queue_create("Flickr Fetcher", NULL);
    dispatch_async(fetchQueue, ^{
        [self.managedObjectContext performBlock:^{
            NSArray *photos = [FlickrFetcher latestGeoreferencedPhotos];
            NSLog(@"New photos %d",[photos count]);
            for(NSDictionary *photo in photos){
                [Photo photoWithFlickerInfo:photo inManagedObjectContext:self.managedObjectContext];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reload];
            });
        }];
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!self.managedObjectContext) [self useDemoDocument];
}

-(void)useDemoDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"DemoDocument13.sqlit"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
        // vytvorit ho
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if(success){
                NSLog(@"Uspesne sa vytvoril");
                self.managedObjectContext = document.managedObjectContext;
                [self refresh]; // ntihane nove fotky a ulozi ich do databazy
            }
        }];
        NSLog(@"Vytvoril sa");
    } else if (document.documentState == UIDocumentStateClosed) {
        // otvorit ho
        [document openWithCompletionHandler:^(BOOL success) {
            if(success){
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
        NSLog(@"Otvoril sa");
    } else {
        // da sa pouzivat rovno
        self.managedObjectContext = document.managedObjectContext;
        NSLog(@"Da sa rovno pouzit");
    }
}


@end
