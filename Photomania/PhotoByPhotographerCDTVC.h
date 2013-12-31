//
//  PhotoByPhotographerCDTVC.h
//  Photomania
//
//  Created by Jan Timar on 10/9/13.
//  Copyright (c) 2013 Jan Timar. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Photographer.h"

@interface PhotoByPhotographerCDTVC : CoreDataTableViewController

@property (nonatomic,strong) Photographer *photographer;

@end
