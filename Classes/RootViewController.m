//
//  RootViewController.m
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import "RootViewController.h"
#import "Constants.h"

@implementation RootViewController


@synthesize locationProvider;
@synthesize data;
@synthesize speedUnitsSelector;
@synthesize altitudeUnitsSelelector; 
@synthesize headingSelector;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"iGPS";
    
}


- (NSArray *)toolbarItems {
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings",nil)
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(showSettings:)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                                                   target:nil action:nil];
    
    NSArray *buttons = [NSArray arrayWithObjects:flexibleSpace,settingsButton,nil];
    
    [settingsButton release];
    [flexibleSpace release];
    
    return buttons;
}

- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller {
    
    [self.tableView reloadData];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)setupAllSelectors {
    
    NSLog(@"setupAllSelectors");
        [self setupHeadingSelectorByDefaults];
        [self setupAltitudeUnitsSelelectorByDefaults];
        [self setupSpeedUnitsSelectorByDefaults];
   
    
}

- (void)setupSpeedUnitsSelectorByDefaults {
    

    NSNumber *speedUnits = [[NSUserDefaults standardUserDefaults] objectForKey:kSpeedKey];
        NSLog(@"setupSpeedUnitsSelectorByDefaults %i",[speedUnits intValue]);
    switch ([speedUnits intValue]) {
        case 1:
            self.speedUnitsSelector = @selector(speedInMetresPerSecond);
            break;
        case 2:
            self.speedUnitsSelector = @selector(speedInMilesPerHour);
            break;
        case 3:
            self.speedUnitsSelector = @selector(speedInKnots);
            break;
        case 4:
            self.speedUnitsSelector = @selector(speedInFeetPerSecond);
            break;
        default:
            self.speedUnitsSelector = @selector(speedInKilometersPerHour);
            break;
    }
    
}

- (void)setupAltitudeUnitsSelelectorByDefaults {
    
    NSNumber *altitudeUnits = [[NSUserDefaults standardUserDefaults] objectForKey:kAltitudeKey];
    NSLog(@"setupAltitudeUnitsSelelectorByDefaults %i",[altitudeUnits intValue]);
    switch ([altitudeUnits intValue]) {
        case 1:
            self.altitudeUnitsSelelector = @selector(altitudeInKilometres);
            break;
        case 2:
            self.altitudeUnitsSelelector = @selector(altitudeInFeet);
            break;
        case 3:
            self.altitudeUnitsSelelector = @selector(altitudeInMiles);
            break;
        default:
            self.altitudeUnitsSelelector = @selector(altitudeInMetres);
            break;
    }
}

- (void)setupHeadingSelectorByDefaults {
    
    NSNumber *north = [[NSUserDefaults standardUserDefaults] objectForKey:kNorthKey];
    NSLog(@"setupHeadingSelectorByDefaults %i",[north intValue]);
    switch ([north intValue]) {
        case 1:
            self.headingSelector = @selector(magneticHeading);
            break;
        default:
            self.headingSelector = @selector(trueHeading);
            break;
    }
}

- (void)locationProviderDidUpdateLocation {
    
    NSLog(@"locationProviderDidUpdateLocation");    
}

- (void)locationProviderDidUpdateHeading {
    NSLog(@"locationProviderDidUpdateHeading");
    
    iGPSCustomTableViewCell *cell =  (iGPSCustomTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[self.data allKeys] indexOfObjectIdenticalTo:[NSString stringWithString:@"Heading"]] inSection:0]];
    [cell setMainTextLabel:[self.locationProvider performSelector:headingSelector]];

    
    
}

- (void)locationProviderDidUpdateLatitude {
    
    iGPSCustomTableViewCell *cell = (iGPSCustomTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[self.data allKeys] indexOfObjectIdenticalTo:[NSString stringWithString:@"Latitude"]] inSection:0]];
    [cell setMainTextLabel:[self.locationProvider latitudeInDMS]];
    
}


- (void)locationProviderDidUpdateLongitude {
    
    iGPSCustomTableViewCell *cell = (iGPSCustomTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[self.data allKeys] indexOfObjectIdenticalTo:[NSString stringWithString:@"Longitude"]] inSection:0]];
    [cell setMainTextLabel:[self.locationProvider longitudeInDMS]];
}


- (void)locationProviderDidUpdateAltitude {
    
    iGPSCustomTableViewCell *cell = (iGPSCustomTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[self.data allKeys] indexOfObjectIdenticalTo:[NSString stringWithString:@"Altitude"]] inSection:0]];
    [cell setMainTextLabel:[self.locationProvider performSelector:altitudeUnitsSelelector]];

    
}


- (void)locationProviderDidUpdateSpeed {
    
    iGPSCustomTableViewCell *cell = (iGPSCustomTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[self.data allKeys] indexOfObjectIdenticalTo:[NSString stringWithString:@"Speed"]] inSection:0]];
    [cell setMainTextLabel:[self.locationProvider performSelector:speedUnitsSelector]];

    
}


- (void)locationProviderDidUpdateCourse {
    
}

- (void)loadData {
    

        NSString *latitude  = [NSString stringWithString:
                               [self.locationProvider latitudeInDMS]];
        NSString *longitude = [NSString stringWithString:
                               [self.locationProvider longitudeInDMS]];
    
        NSString *altitude  = [NSString stringWithString:
                               [self.locationProvider performSelector:self.altitudeUnitsSelelector]];
    
        NSString *speed     = [NSString stringWithString:
                               [self.locationProvider performSelector:self.speedUnitsSelector]];
        
        NSString *heading   = [NSString stringWithString:
                               [self.locationProvider performSelector:self.headingSelector]];
                
        
        NSArray *objects = [NSArray arrayWithObjects:latitude,longitude,heading,altitude,speed,nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         NSLocalizedString(@"Latitude",nil),
                         NSLocalizedString(@"Longitude",nil),
                         NSLocalizedString(@"Heading",nil),
                         NSLocalizedString(@"Altitude",nil),
                         NSLocalizedString(@"Speed",nil),nil];
        
        self.data = [NSDictionary dictionaryWithObjects:objects forKeys:keys]; 
}



- (IBAction)showSettings:(id)sender {
    
    
    SettingsViewController *svc = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];

    [svc setDelegate:self];
    [svc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [svc setTitle:NSLocalizedString(@"Settings",nil)];    
        
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:svc];
    [svc release]; 
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [self presentModalViewController:nc animated:YES];
    [nc release];
    
	  
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    if (!self.locationProvider) {
        self.locationProvider = [[LocationProvider alloc] initAndStartMonitoringLocation];
        [self.locationProvider setDelegate:self];
    }
    
    [self.locationProvider startUpdatingLocationAndHeading];
    
    
    [self setupAllSelectors];
    [self loadData];
    
     [self.tableView reloadData];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}



#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        //static NSString *CellIdentifier = @"Cell";
    static NSString *CustomCell = @"iGPSCustomTableViewCell";
    
        // UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    iGPSCustomTableViewCell *cell = (iGPSCustomTableViewCell *)[table dequeueReusableCellWithIdentifier:CustomCell];
    if (cell == nil) {
            //        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        [[NSBundle mainBundle] loadNibNamed:@"TableCellView" owner:self options:nil];
        cell = tableCell;
    }
    
    
    NSArray *keys = [self.data allKeys];
    NSString *rowKey = [keys objectAtIndex:indexPath.row];
    
    [cell setMainTextLabel:[self.data objectForKey:rowKey]];
    [cell setDetailTextLabel:[keys objectAtIndex:indexPath.row]];	

    return cell;
}

- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section {
    
    return NSLocalizedString(@"My location",nil);
    
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {    
}


- (void)dealloc {
    [data release];
    [locationProvider release];
    [super dealloc];
}


@end

