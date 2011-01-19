//
//  RootViewController.m
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import "RootViewController.h"
#import "Constants.h"

@interface RootViewController ()

@property (nonatomic, assign) SEL latitudeSelector;
@property (nonatomic, assign) SEL longitudeSelector;
@property (nonatomic, assign) SEL altitudeUnitsSelelector;
@property (nonatomic, assign) SEL speedUnitsSelector;
@property (nonatomic, assign) SEL headingSelector;
@property (nonatomic, assign) SEL courseSelector;
@property (nonatomic, assign) SEL hAccuracySelector;
@property (nonatomic, assign) SEL vAccuracySelector;

- (void)setupAccuracySelectors;
- (void)setupCoordinatesSelector;

@end


@implementation RootViewController

@synthesize latitudeSelector;
@synthesize longitudeSelector;
@synthesize locationProvider;
@synthesize names;
@synthesize values;
@synthesize speedUnitsSelector;
@synthesize altitudeUnitsSelelector; 
@synthesize headingSelector;
@synthesize courseSelector;
@synthesize hAccuracySelector;
@synthesize vAccuracySelector;



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
    UIBarButtonItem *languageButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Slovensky",nil)
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(changeLanguage:)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                                                   target:nil action:nil];
    
    NSArray *buttons = [NSArray arrayWithObjects:languageButton,flexibleSpace,settingsButton,nil];
    
    [languageButton release];
    [settingsButton release];
    [flexibleSpace release];
    
    return buttons;
}



- (IBAction)changeLanguage:(id)sender {
    
    NSMutableArray *languages = [NSMutableArray arrayWithArray:
                                 [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]];
    
    NSString *lang = [languages objectAtIndex:0];
    
    
    if ([lang isEqualToString:@"en"]) {
        lang = @"sk";
    } else lang = @"en";
    
    [languages replaceObjectAtIndex:0 withObject:lang];
    [[NSUserDefaults standardUserDefaults] setObject:languages forKey:@"AppleLanguages"];     
    
    [self viewWillAppear:NO];
    [self.navigationController loadView];
        //    [self.navigationController setToolbarHidden:YES animated:YES];
        //    [self.navigationController setToolbarHidden:NO animated:YES];
    
    
}

- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller {
    
    [self.tableView reloadData];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)setupAllSelectors {
    
    NSLog(@"setupAllSelectors");
    [self setupCoordinatesSelector];
    [self setupHeadingSelectorByDefaults];
    [self setupAltitudeUnitsSelelectorByDefaults];
    [self setupSpeedUnitsSelectorByDefaults];
    [self setupCourseSelectorByDefaults];
    [self setupAccuracySelectors];
   
    
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

- (void)setupCourseSelectorByDefaults {
    
    NSNumber *course = [[NSUserDefaults standardUserDefaults] objectForKey:kCourseKey];
    NSLog(@"setupCourseSelectorByDefaults %i",[course intValue]);
    switch ([course intValue]) {
        case 1:
            self.courseSelector = @selector(courseInDegrees);
            break;
        default:
            self.courseSelector = @selector(courseMixed);
            break;
    }
    
    
}

- (int)defaultsValueForKey:(NSString *)accuracyUnitsKey {
    NSNumber *accuracyUnits = [[NSUserDefaults standardUserDefaults] objectForKey:accuracyUnitsKey];
    return [accuracyUnits intValue];
}

- (void)setupHorizontalAccuracySelectorByValue:(int)aValue {
    
    switch (aValue) {
        case 1:
            self.hAccuracySelector = @selector(horizontalAccuracyInKilometres);
            break;
        case 2:
            self.hAccuracySelector = @selector(horizontalAccuracyInFeet);
            break;
        case 3:
            self.hAccuracySelector = @selector(horizontalAccuracyInMiles);
            break;
        default:
            self.hAccuracySelector = @selector(horizontalAccuracyInMeters);
            break;
    }
    
    
}

- (void)setupVerticalAccuracySelectorByValue:(int)aValue {
    
    switch (aValue) {
        case 1:
            self.vAccuracySelector = @selector(verticalAccuracyInKilometres);
            break;
        case 2:
            self.vAccuracySelector = @selector(verticalAccuracyInFeet);
            break;
        case 3:
            self.vAccuracySelector = @selector(verticalAccuracyInMiles);
            break;
        default:
            self.vAccuracySelector = @selector(verticalAccuracyInMeters);
            break;
    }
    
    
}

- (void)setupAccuracySelectors {
    
    int value = [self defaultsValueForKey:kAccUnitsKey];
    [self setupHorizontalAccuracySelectorByValue:value];
    [self setupVerticalAccuracySelectorByValue:value];
}


- (void)setupLatitudeSelectorByValue:(int)aValue {
    
    switch (aValue) {
        case 1:
            self.latitudeSelector = @selector(latitudeInDegDec);
            break;
        default:
            self.latitudeSelector = @selector(latitudeInDMS);
            break;
    }
    
}


- (void)setupLongitudeSelectorByValue:(int)aValue {
    
    switch (aValue) {
        case 1:
            self.longitudeSelector = @selector(longitudeInDegDec);
            break;
        default:
            self.longitudeSelector = @selector(longitudeInDMS);
            break;
    }
    
}

- (void)setupCoordinatesSelector {
    
    int value = [self defaultsValueForKey:kCoordsKey];
    [self setupLatitudeSelectorByValue:value];
    [self setupLongitudeSelectorByValue:value];
    
}

- (void)locationProviderDidUpdateLocation {
    
    NSLog(@"locationProviderDidUpdateLocation");    
}

- (void)updateCellForIndexPath:(NSIndexPath *)indexPath withSelector:(SEL)aSelector {
    
    iGPSCustomTableViewCell *cell = (iGPSCustomTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *label = [self.locationProvider performSelector:aSelector];
    [cell setMainTextLabel:label];
    NSLog(@"label: %@, index: %d",label,indexPath.row);
    [self setStringValue:label atIndex:indexPath];
}

- (void)locationProviderDidUpdateHeading {
        //NSLog(@"locationProviderDidUpdateHeading");
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Heading",nil)] inSection:0];
    
    [self updateCellForIndexPath:indexPath withSelector:self.headingSelector];
    
    
}

- (void)locationProviderDidUpdateLatitude {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Latitude",nil)] inSection:0];
    
    [self updateCellForIndexPath:indexPath withSelector:self.latitudeSelector];
    
}


- (void)locationProviderDidUpdateLongitude {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Longitude",nil)] inSection:0];    
    
    [self updateCellForIndexPath:indexPath withSelector:self.longitudeSelector];
    
}


- (void)locationProviderDidUpdateAltitude {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Altitude",nil)] inSection:0];
    
    [self updateCellForIndexPath:indexPath withSelector:self.altitudeUnitsSelelector];
    
    
}


- (void)locationProviderDidUpdateSpeed {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Speed",nil)] inSection:0];
    
    [self updateCellForIndexPath:indexPath withSelector:self.speedUnitsSelector];
    
}


- (void)locationProviderDidUpdateCourse {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Course",nil)] inSection:0];
    
    [self updateCellForIndexPath:indexPath withSelector:self.courseSelector];
    
    
}


- (void)locationProviderDidUpdateVerticalAccuracy {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Vertical accuracy",nil)] inSection:0];
    
    [self updateCellForIndexPath:indexPath withSelector:self.vAccuracySelector];
    
}


- (void)locationProviderDidUpdateHorizontalAccuracy {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Horizontal accuracy",nil)] inSection:0];
    
    [self updateCellForIndexPath:indexPath withSelector:self.hAccuracySelector];
    
}

- (void)setStringValue:(NSString *)value atIndex:(NSIndexPath *)index {
    
    NSLog(@"Index Value: %i",index.row);
    if ([self.values count] > index.row) {
        [self.values replaceObjectAtIndex:index.row withObject:value];
    }
    
    
}

- (void)setupValues {
    
    NSString *vAccuracy = [NSString stringWithString:
                           [self.locationProvider performSelector:self.vAccuracySelector]];
    
    NSString *hAccuracy = [NSString stringWithString:
                           [self.locationProvider performSelector:self.hAccuracySelector]];
    
    NSString *latitude  = [NSString stringWithString:
                           [self.locationProvider performSelector:self.latitudeSelector]];
    
    NSString *longitude = [NSString stringWithString:
                           [self.locationProvider performSelector:self.longitudeSelector]];
    
    NSString *altitude  = [NSString stringWithString:
                           [self.locationProvider performSelector:self.altitudeUnitsSelelector]];
    
    NSString *speed     = [NSString stringWithString:
                           [self.locationProvider performSelector:self.speedUnitsSelector]];
    
    NSString *heading   = [NSString stringWithString:
                           [self.locationProvider performSelector:self.headingSelector]];
    
    NSString *course    = [NSString stringWithString:
                           [self.locationProvider performSelector:self.courseSelector]];
    
    self.values = [NSMutableArray arrayWithObjects:vAccuracy,hAccuracy,latitude,longitude,heading,altitude,speed,course,nil];
    
}

- (void)setupNames {
    
    self.names = [NSArray arrayWithObjects:
                  NSLocalizedString(@"Vertical accuracy",nil),
                  NSLocalizedString(@"Horizontal accuracy",nil),
                  NSLocalizedString(@"Latitude",nil),
                  NSLocalizedString(@"Longitude",nil),
                  NSLocalizedString(@"Heading",nil),
                  NSLocalizedString(@"Altitude",nil),
                  NSLocalizedString(@"Speed",nil),
                  NSLocalizedString(@"Course",nil),nil];
    
}

- (void)loadData {
    
    [self setupValues];
    [self setupNames];

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
    return [self.names count];
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
    
    
    
    [cell setMainTextLabel:[self.values objectAtIndex:indexPath.row]];
    [cell setDetailTextLabel:[self.names objectAtIndex:indexPath.row]];	

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
    [names release];
    [values release];
    [locationProvider release];
    [super dealloc];
}


@end

