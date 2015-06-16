//
//  ViewController.m
//  iScream
//
//  Created by Thomas Crawford on 6/7/15.
//  Copyright (c) 2015 VizNetwork. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Flavors.h"
#import "InventoryItems.h"
#import "flavorViewController.h"

@interface ViewController ()

@property (nonatomic, strong) AppDelegate            *appDelegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray                *flavorsArray;
@property (nonatomic, strong) IBOutlet UITableView *flavorTableView;

@end

@implementation ViewController


#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _flavorsArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {//else if you dont have one to reuse lets make a new one
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.textLabel.textColor = [UIColor purpleColor];
        //cell.detailTextLabel.textColor = [UIColor purpleColor];
        //cell.textLabel.font = [UIFont fontWithName:@"papyrus" size:14];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    Flavors *currentFlavor = [_flavorsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [currentFlavor flavorName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%g many gallons left", [self totalInventoryForFlavor:currentFlavor]];
    cell.imageView.image = [UIImage imageNamed:[currentFlavor flavorImage]];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select");
    [self performSegueWithIdentifier:@"displayFlavorSegue" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    flavorViewController *destController = [segue destinationViewController];
    NSIndexPath *indexPath = [_flavorTableView indexPathForSelectedRow];
    Flavors *flavorToDisplay = [_flavorsArray objectAtIndex:indexPath.row];
    destController.flavorNameString = [flavorToDisplay flavorName];
}

#pragma mark - Core Methods

- (NSArray *)fetchFlavors {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Flavors" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"flavorName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *fetchResults = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Fetched %lu Flavors",(unsigned long)[fetchResults count]);

    return [NSMutableArray arrayWithArray:fetchResults];
}

- (float)totalInventoryForFlavor:(Flavors *)flavor {
    float totalInGallons = 0.0;
    NSArray *flavorInventoryArray = [[flavor relationshipFlavorInventoryItems] allObjects];
    for (InventoryItems *inventoryItem in flavorInventoryArray) {
        totalInGallons = totalInGallons + [[inventoryItem sizeInGallons] floatValue];
    }
    return totalInGallons;
}

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _managedObjectContext = _appDelegate.managedObjectContext;
    _flavorsArray = [self fetchFlavors];
    for (Flavors *flavor in _flavorsArray) {
        NSLog(@"Flavor: %@ Gallons: %.2f",[flavor flavorName],[self totalInventoryForFlavor:flavor]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
