//
//  SettingsViewController.m
//  iGPS
//
//  Created by Jakub Petrík on 12/30/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsBundleReader.h"
#import "SettingsDetailViewController.h"
#import "Constants.h"
#import <dispatch/dispatch.h>



@implementation SettingsViewController

    //@synthesize tableData;
    //@synthesize rowsForAllSections;
    //@synthesize sections;
@synthesize delegate;
    //@synthesize defaultValues;
    //@synthesize nc;
@synthesize reader;

/*
- (id) initWithCoder: (NSCoder *) coder {
        // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        [self performSelector:@selector(setupData)];
    }
    return self;
}
*/


- (void)awakeFromNib {
    
    if (!self.reader) {
        self.reader = [[SettingsBundleReader alloc] init];
    }
    [self performSelector:@selector(setupData)];
    
}

#pragma mark -
#pragma mark View lifecycle

/*
- (void)setupTableData {
    
        //self.tableData = [[DataHandler sharedDataHandler] rootPlist];
    
    NSString *pathStr = [[NSBundle mainBundle] bundlePath];
    NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    
    self.tableData = [NSArray arrayWithArray:[dict objectForKey:@"PreferenceSpecifiers"]];
        //self.tableData = (NSArray *)[dict objectForKey:@"PreferenceSpecifiers"];
        //NSLog(@"tabledata: %@",[self.tableData description]);
    
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
    
    
        //self.rowsForAllSections = [[DataHandler sharedDataHandler] keyElements];
    
}


- (void)setupSections {
    
    
    NSMutableArray *temp = [NSMutableArray array];
    
    for (NSDictionary *dict in self.tableData) {
        if (![dict objectForKey:@"Key"]) {
            [temp addObject:dict];
                //NSLog(@"dict found");
        }
    }
    
    self.sections = temp;
    
        // self.sections = [[DataHandler sharedDataHandler] groups];
}


- (void)setUpDefaultValues {
    
        //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
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
    
        //    [pool drain];
     
     
        //self.defaultValues = [[DataHandler sharedDataHandler] selectedKeys];
}
*/

- (IBAction)done:(id)sender {
	NSLog(@"done:");
    [self.delegate settingsViewControllerDidFinish];	
}


- (void)viewDidLoad {
        //dispatch_async(processQueue, ^{
        
        //[self setUpDefaultValues];
        //});
        // [NSThread detachNewThreadSelector:@selector(setUpDefaultValues) toTarget:self withObject:nil];
        //[self performSelector:@selector(setupData)];
    
    [super viewDidLoad];
    
}

/*
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
*/
    //   !!!!!PLAYGROUND!!!! 

- (void)setupData {
    
    dispatch_queue_t setupQueue = dispatch_queue_create("iGPS.SettingsViewController.setupQueue", NULL);
    dispatch_async(setupQueue, ^{
        /*
        [self setupTableData];
        [self setupSections];
        [self setupRowsForAllSections];
        */
        
        [self.reader setup];
    });
    dispatch_release(setupQueue);
        
    
}
    
- (void)refreshTable {
    
    dispatch_queue_t refreshQueue = dispatch_queue_create("iGPS.SettingsViewController.refreshQueue", NULL);
    dispatch_async(refreshQueue, ^{
        
        @synchronized(self) {
        
                //[self setUpDefaultValues];
            [self.reader loadDefaultValues];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
    });
    dispatch_release(refreshQueue);
    
}

- (NSDictionary *)rowForIndexPath:(NSIndexPath *)indexPath {
    
    return [[self.reader.rows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
}


    // !!!!!PLAYGROUND!!!! END!!!!

- (void)viewWillAppear:(BOOL)animated {
    
        self.title = NSLocalizedString(@"Settings",nil);
        //self.nc.title = NSLocalizedString(@"Settings",nil);
        // [self setupData];
        //[self.tableView reloadData];
    
    [self refreshTable];
    NSLog(@"viewWillAppear");
        //[self.navigationController setToolbarHidden:NO animated:YES];
    [super viewWillAppear:animated];
    
        
}


- (void)viewWillDisappear:(BOOL)animated {
        // self.title = NSLocalizedString(@"Back",nil);
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source


 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {

    return [self.reader.sections count]; 
    
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    
    return [[self.reader.rows objectAtIndex:section] count];
       
}


- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section {
    
    return NSLocalizedString([[self.reader.sections objectAtIndex:section] objectForKey:@"Title"],nil);
}


- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    NSDictionary *row = [self rowForIndexPath:indexPath];
    NSString *textLabel = NSLocalizedString([row objectForKey:@"Title"],nil);
    NSString *detailLabel = [[self.reader.defaultValues objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSLog(@"detailText:%@",detailLabel);
    
    cell.textLabel.text = textLabel;

    if ([[row objectForKey:@"Type"] isEqualToString:@"PSMultiValueSpecifier"]) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = detailLabel;
            
    } 
    
    return cell;
    
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *row = [[self.reader.rows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];   
    
             
    if ([[row objectForKey:@"Type"] isEqual:[NSString stringWithString:@"PSMultiValueSpecifier"]]) {
        
        SettingsDetailViewController *dvc = [[SettingsDetailViewController alloc] 
                                             initWithNibName:@"SettingsViewController"
                                             bundle:nil];
        dvc.data = row;
        NSLog(@"row %@",[row description]);
        
        [dvc setTitle:NSLocalizedString([row objectForKey:@"Title"],nil)];
        [self.navigationController pushViewController:dvc animated:YES];
        [dvc release];
        NSLog(@"TRUE");
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
    
        //self.defaultValues = nil;
        //self.sections = nil;
        //self.rowsForAllSections = nil;
        //self.tableData = nil;

}


- (void)dealloc {
    [reader release];
        // [nc release];
        //[defaultValues release];
        //[sections release];
        //[rowsForAllSections release];
        //[tableData release];
    [super dealloc];
}

@end

