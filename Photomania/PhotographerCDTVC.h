//
//  PhotographerCDTVC.h
//  Photomania
//
//  Created by Jan Timar on 10/9/13.
//  Copyright (c) 2013 Jan Timar. All rights reserved.
//
// Can do "setPhotographer:" segue and will call method in destination VC

#import "CoreDataTableViewController.h"

@interface PhotographerCDTVC : CoreDataTableViewController

@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@end
