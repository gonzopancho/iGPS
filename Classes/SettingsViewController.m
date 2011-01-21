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
#import "Constants.h"



@implementation SettingsViewController

@synthesize tableData;
@synthesize rowsForAllSections;
@synthesize sections;
@synthesize delegate;
@synthesize defaultValues;

#pragma mark -
#pragma mark View lifecycle



- (void)setupTableData {
        
    NSString *pathStr = [[NSBundle mainBundle] bundlePath];
    NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    
    self.tableData = [NSArray arrayWithArray:[dict objectForKey:@"PreferenceSpecifiers"]];
    
    NSLog(@"tabledata: %@",[self.tableData description]);
}


    //returns array of rows for all sections

- (void)setupRowsForAllSections {
    
    
    NSMutableArray *subArray = [NSMutableArray array];
    NSMutableArray *mainArray = [NSMutableArray array];
    
        //filters out groups from tableData
    
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
    
    
}


- (void)setupSections {
    
    NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSDictionary *dict in self.tableData) {
        if ([[dict objectForKey:@"Type"] isEqual:@"PSGroupSpecifier"]) {
            [temp addObject:dict];
            NSLog(@"dict found");
        }
    }
    
    self.sections = temp;
    
}


- (void)setUpDefaultValues {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableArray *temp = [NSMutableArray array];
    NSMutableArray *storage = [NSMutableArray array];
    
    for (int i = 0; i < [self.rowsForAllSections count]; i++) {
        NSArray *array = [self.rowsForAllSections objectAtIndex:i];
        
        for (NSDictionary *element in array) {
            
            NSArray *values = [element objectForKey:@"Titles"];
            
            NSNumber *defaultValue = [[NSUserDefaults standardUserDefaults] objectForKey:[element objectForKey:@"Key"]];
            
            [temp addObject:NSLocalizedString([values objectAtIndex:[defaultValue intValue]],nil)];
        }
        [storage addObject:temp];
        temp = [NSMutableArray array];
    }
    
    self.defaultValues = storage;
    
    [pool drain];
}


- (IBAction)done:(id)sender {
	NSLog(@"done:");
    [self.delegate settingsViewControllerDidFinish:self];	
}


- (void)viewDidLoad {
    [NSThread detachNewThreadSelector:@selector(setUpDefaultValues) toTarget:self withObject:nil];
    [super viewDidLoad];
    
}


- (NSArray *)toolbarItems {
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done",nil)
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(done:)];
    
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *buttons = [NSArray arrayWithObjects:flexibleSpace,doneButton,nil];
    
    [doneButton release];
    [flexibleSpace release];

    return buttons;
    
    
}

    //   !!!!!PLAYGROUND!!!! 

    
- (void)setupAndLoadTable {
    
    [self setupTableData];
    [self setupSections];
    [self setupRowsForAllSections];
    [self setUpDefaultValues];
    [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                     withObject:nil
                                  waitUntilDone:YES];
    
}


    // !!!!!PLAYGROUND!!!! END!!!!

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    NSOperationQueue *myQueue = [[[NSOperationQueue alloc] init] autorelease];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self 
                                                                            selector:@selector(setupAndLoadTable)
                                                                              object:nil];
    [myQueue addOperation:operation];
    [operation release];
   
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source


 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self.sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.rowsForAllSections objectAtIndex:section] count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return NSLocalizedString([[self.sections objectAtIndex:section] objectForKey:@"Title"],nil);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    NSDictionary *row = [[self.rowsForAllSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = NSLocalizedString([row objectForKey:@"Title"],nil);
    
    if ([[row objectForKey:@"Type"] isEqual:@"PSMultiValueSpecifier"]) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
            //sets default value
            //cell.detailTextLabel.text = NSLocalizedString([GPSDataFormatter textValueFromDictionary:row],nil);
        cell.detailTextLabel.text = [[self.defaultValues objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
    } 
    
    return cell;
    
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *row = [[self.rowsForAllSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];   
    
             
    if ([[row objectForKey:@"Type"] isEqual:[NSString stringWithString:@"PSMultiValueSpecifier"]]) {
        NSLog(@"TRUE");
        SettingsDetailViewController *dvc = [[SettingsDetailViewController alloc] 
                                             initWithNibName:@"SettingsViewController"
                                             bundle:nil];
        dvc.data = row;
        
        [dvc setTitle:NSLocalizedString([row objectForKey:@"Title"],nil)];
        [self.navigationController pushViewController:dvc animated:YES];
        [dvc release];
    }
    
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
    self.defaultValues = nil;
    self.sections = nil;
    self.rowsForAllSections = nil;
    self.tableData = nil;
    self.tableView = nil;
}


- (void)dealloc {
    [defaultValues release];
    [sections release];
    [rowsForAllSections release];
    [tableData release];
    [super dealloc];
}


@end

