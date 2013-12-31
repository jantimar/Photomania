//
//  Photo+Flickr.h
//  Photomania
//
//  Created by Jan Timar on 10/9/13.
//  Copyright (c) 2013 Jan Timar. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+(Photo *)photoWithFlickerInfo:(NSDictionary *)info inManagedObjectContext:(NSManagedObjectContext *)context;

@end
