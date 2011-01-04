//
//  SettingsDetailViewController.m
//  iGPS
//
//  Created by Jakub Petrík on 12/31/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import "SettingsDetailViewController.h"


@implementation SettingsDetailViewController

@synthesize data;
@synthesize keyForData;
@synthesize selectedRow;


#pragma mark -
#pragma mark Initialization


- (NSDictionary *)data {
    
    if (!data) {
        self.data = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
    }    
    return data;
}


- (NSString *)keyForData {
    
    self.keyForData = [[[NSString alloc] initWithString:[self.data objectForKey:@"Key"]] autorelease];
    return keyForData;
}

- (int)selectedRow {
    
    NSNumber *temp = [[NSUserDefaults standardUserDefaults] objectForKey:self.keyForData];
    self.selectedRow = [temp intValue];
    return selectedRow;
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self.data objectForKey:@"Titles"] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
        
    NSArray *labels = [self.data objectForKey:@"Titles"];
    
    cell.textLabel.text = [labels objectAtIndex:indexPath.row];
    
    if (indexPath.row == self.selectedRow) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
         
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:indexPath.row] forKey:self.keyForData];
    
    [self.tableView reloadData];
    
        //spinavy a hnusny trik za ktory zhorim v pekle... :)
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [keyForData release];
    [data release];
    [super dealloc];
}


@end

