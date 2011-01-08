//
//  SettingsViewController.m
//  iGPS
//
//  Created by Jakub Petrík on 12/30/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsDetailViewController.h"
#import "GPSDataFormatter.h"
#import <dispatch/dispatch.h>



@implementation SettingsViewController

@synthesize tableData;
@synthesize rowsForAllSections;
@synthesize sections;
@synthesize delegate;

#pragma mark -
#pragma mark View lifecycle



- (NSArray *)tableData {
    
    if (tableData == nil) {
        
            //dispatch_queue_t dataQueue = dispatch_queue_create("sk.jakubpetrik.iGPS.tableDataAssigmentQueue", NULL);
            //dispatch_async(dataQueue, ^{
            
            NSString *pathStr = [[NSBundle mainBundle] bundlePath];
            NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
            NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
            
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
            
            self.tableData = [NSArray arrayWithArray:[dict objectForKey:@"PreferenceSpecifiers"]];
            //});
        
            //dispatch_release(dataQueue);
    }
    
    return tableData;
}

- (IBAction)done:(id)sender {
	NSLog(@"done:");
    [self.delegate settingsViewControllerDidFinish:self];	
}



- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSArray *)toolbarItems {
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *buttons = [NSArray arrayWithObjects:flexibleSpace,doneButton,nil];
    
    [doneButton release];
    [flexibleSpace release];

    return buttons;
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
        //[self.tableView performSelectorOnMainThread:@selector(reloadData) 
        //                           withObject:nil 
        //                        waitUntilDone:YES];
    [self.tableView reloadData];
    [self.navigationController setToolbarHidden:NO animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSArray *)rowsForAllSections {
    
    if (rowsForAllSections == nil) {
        
            //dispatch_queue_t rowQueue = dispatch_queue_create("sk.jakubpetrik.iGPS.rowQueue", NULL);
            //dispatch_async(rowQueue, ^{
            
            NSMutableArray *subArray = [NSMutableArray array];
            NSMutableArray *mainArray = [NSMutableArray array];
            
            for (NSDictionary *dict in self.tableData) {
                
                if (![[dict objectForKey:@"Type"] isEqual:@"PSGroupSpecifier"]) {
                    [subArray addObject:dict];
                } else if ([subArray count] > 0) {
                    
                    [mainArray addObject:[NSArray arrayWithArray:subArray]];
                    [subArray removeAllObjects];
                }
            }
            
            if ([subArray count] > 0) [mainArray addObject:[NSArray arrayWithArray:subArray]];
            
            self.rowsForAllSections = mainArray;
            
            
            //});
            //dispatch_release(rowQueue);
    }
    return rowsForAllSections;
    
}


- (NSArray *)sections {
    
    if (sections == nil) {
        
            //dispatch_queue_t sectionsQueue = dispatch_queue_create("sk.jakubpetrik.iGPS.sectionsQueue", NULL);
            //dispatch_async(sectionsQueue, ^{
            
            NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
            
            for (NSDictionary *dict in self.tableData) {
                if ([[dict objectForKey:@"Type"] isEqual:@"PSGroupSpecifier"]) {
                    [temp addObject:dict];
                    NSLog(@"dict found");
                }
            }
            
            self.sections = temp;
            //});
            //dispatch_release(sectionsQueue);
        
    }
       
    
    return sections;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self.sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.rowsForAllSections objectAtIndex:section] count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[self.sections objectAtIndex:section] objectForKey:@"Title"];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    NSDictionary *row = [[self.rowsForAllSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [row objectForKey:@"Title"];
    
    if ([[row objectForKey:@"Type"] isEqual:@"PSMultiValueSpecifier"]) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = [GPSDataFormatter textValueFromDictionary:row];
        
    } else if ([[row objectForKey:@"Type"] isEqual:@"PSSliderSpecifier"]) {
        
        cell.accessoryView = [GPSDataFormatter sliderFromDictionary:row];
    }
    
    return cell;
    
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *row = [[self.rowsForAllSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];   
    
    dispatch_queue_t defaultsQueue = dispatch_queue_create("sk.jakubpetrik.iGPS.defaultsQueue", NULL);
    dispatch_async(defaultsQueue, ^{
        
        [[NSUserDefaults standardUserDefaults] setObject:row forKey:@"data"];
    });
    dispatch_release(defaultsQueue);
     
    if ([[row objectForKey:@"Type"] isEqual:[NSString stringWithString:@"PSMultiValueSpecifier"]]) {
        NSLog(@"TRUE");
        SettingsDetailViewController *dvc = [[SettingsDetailViewController alloc] 
                                             initWithNibName:@"SettingsViewController"
                                             bundle:nil];
        
        [dvc setTitle:[row objectForKey:@"Title"]];
        [self.navigationController pushViewController:dvc animated:YES];
        [dvc release];
    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


- (void)deselect {
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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
    [sections release];
    [rowsForAllSections release];
    [tableData release];
    [super dealloc];
}


@end

