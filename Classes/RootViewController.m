//
//  RootViewController.m
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import "RootViewController.h"
#import "Constants.h"
#import <dispatch/dispatch.h>
/*
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
*/

@implementation RootViewController

    //@synthesize latitudeSelector;
    //@synthesize longitudeSelector;
@synthesize locationProvider;
@synthesize names;
@synthesize values;
    //@synthesize speedUnitsSelector;
    //@synthesize altitudeUnitsSelelector; 
    //@synthesize headingSelector;
    //@synthesize courseSelector;
    //@synthesize hAccuracySelector;
    //@synthesize vAccuracySelector;


#pragma mark -
#pragma mark View lifecycle

/*
- (void)setupKeyValueObserving {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupHeadingSelectorByDefaults)
                                                 name:kNorthKey
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupCoordinatesSelector)
                                                 name:kCoordsKey
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupAccuracySelectors)
                                                 name:kAccUnitsKey
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupAltitudeUnitsSelelectorByDefaults)
                                                 name:kAltitudeKey
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupSpeedUnitsSelectorByDefaults)
                                                 name:kSpeedKey
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupCourseSelectorByDefaults)
                                                 name:kCourseKey
                                               object:nil];
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"iGPS"];
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    if (!self.locationProvider) {
        self.locationProvider = [[LocationProvider alloc] init];
        
    }
    [self.locationProvider setDelegate:self];

        //[self setupKeyValueObserving];
        //[self performSelector:@selector(setupAllSelectors)];
    
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
        //[self.tableView reloadData];
    [self.navigationController loadView];
        //    [self.navigationController setToolbarHidden:YES animated:YES];
        //    [self.navigationController setToolbarHidden:NO animated:YES];         
       
    
}

- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller {
        //[self.tableView reloadData];
    [self dismissModalViewControllerAnimated:YES];
}

/*
- (int)defaultsValueForKey:(NSString *)aKey {
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:aKey];
    return [number intValue];
}

*/

/*
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
    

        //NSNumber *speedUnits = [[NSUserDefaults standardUserDefaults] objectForKey:kSpeedKey];
        //NSLog(@"setupSpeedUnitsSelectorByDefaults %i",[speedUnits intValue]);
    switch ([self defaultsValueForKey:kSpeedKey]) {
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
*/
- (void)locationProviderDidUpdateLocation {
    
    NSLog(@"locationProviderDidUpdateLocation");    
}

- (void)updateCellForIndexPath:(NSIndexPath *)indexPath withSelector:(SEL)aSelector {
    
    iGPSCustomTableViewCell *cell = (iGPSCustomTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *label = [self.locationProvider performSelector:aSelector];

    dispatch_async(dispatch_get_main_queue(), ^{
        [cell setMainTextLabel:label];
    });
    
    NSLog(@"label: %@, index: %d",label,indexPath.row);
    [self setStringValue:label atIndex:indexPath];
}


- (void)locationProviderDidUpdateHeading {    
    
    dispatch_queue_t headingQueue = dispatch_queue_create("iGPS.HeadingQueue", NULL);
    dispatch_async(headingQueue, ^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Heading",nil)] 
                                                    inSection:0];
        
        [self updateCellForIndexPath:indexPath withSelector:@selector(headingByUserDefaults)];
    });
    
    dispatch_release(headingQueue);
    
    
}

- (void)locationProviderDidUpdateLatitude {
    
        dispatch_queue_t latitudeQueue = dispatch_queue_create("iGPS.LatitudeQueue", NULL);
        dispatch_async(latitudeQueue, ^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Latitude",nil)] inSection:0];
        
        [self updateCellForIndexPath:indexPath withSelector:@selector(latitudeByUserDefaults)];
        
        });
    dispatch_release(latitudeQueue);
    
    
}


- (void)locationProviderDidUpdateLongitude {
    
        dispatch_queue_t longitudeQueue = dispatch_queue_create("iGPS.LongitudeQueue", NULL);
        dispatch_async(longitudeQueue, ^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Longitude",nil)] inSection:0];    
        
        [self updateCellForIndexPath:indexPath withSelector:@selector(longitudeByUserDefaults)];
        
        
        });
    dispatch_release(longitudeQueue);

        
}


- (void)locationProviderDidUpdateAltitude {
    

    dispatch_queue_t altitudeQueue = dispatch_queue_create("sk.jakubpetrik.iGPS.LatitudeQueue", NULL);
        dispatch_async(altitudeQueue, ^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Altitude",nil)] inSection:0];
        
        [self updateCellForIndexPath:indexPath withSelector:@selector(altitudeByUserDefaults)];
        
        
        });
    dispatch_release(altitudeQueue);
        
    
}


- (void)locationProviderDidUpdateSpeed {
    
        dispatch_queue_t speedQueue = dispatch_queue_create("iGPS.SpeedQueue", NULL);
        dispatch_async(speedQueue, ^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Speed",nil)] inSection:0];
        
        [self updateCellForIndexPath:indexPath withSelector:@selector(speedByUserDefaults)];
        
        
        });
       dispatch_release(speedQueue); 
}


- (void)locationProviderDidUpdateCourse {
        
        dispatch_queue_t courseQueue = dispatch_queue_create("iGPS.CourseQueue", NULL);
        dispatch_async(courseQueue, ^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Course",nil)] inSection:0];
        
        [self updateCellForIndexPath:indexPath withSelector:@selector(courseByUserDefaults)];
        
        });
    
    dispatch_release(courseQueue);
    
}


- (void)locationProviderDidUpdateVerticalAccuracy {
    
        dispatch_queue_t verticalAccQueue = dispatch_queue_create("iGPS.VerticalAccQueue", NULL);
        dispatch_async(verticalAccQueue, ^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Vertical accuracy",nil)] inSection:0];
        
        [self updateCellForIndexPath:indexPath withSelector:@selector(veritcalAccuracyByUserDefaults)];
        
        
        });

       dispatch_release(verticalAccQueue); 
}


- (void)locationProviderDidUpdateHorizontalAccuracy {
    
        dispatch_queue_t horizontalAccQueue = dispatch_queue_create("iGPS.HorizontalAccQueue", NULL);
        dispatch_async(horizontalAccQueue, ^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Horizontal accuracy",nil)] inSection:0];
        
        [self updateCellForIndexPath:indexPath withSelector:@selector(horizontalAccuracyByUserDefaults)];
        
        
        });
        dispatch_release(horizontalAccQueue); 
}

- (void)setStringValue:(NSString *)value atIndex:(NSIndexPath *)index {
    
    NSLog(@"Index Value: %i",index.row);
    if ([self.values count] > index.row) {
        [self.values replaceObjectAtIndex:index.row withObject:value];
    }
    
    
}

- (void)setupValues {
    
    NSString *vAccuracy = [NSString stringWithString:
                           [self.locationProvider veritcalAccuracyByUserDefaults]];
    
    NSString *hAccuracy = [NSString stringWithString:
                           [self.locationProvider horizontalAccuracyByUserDefaults]];
    
    NSString *latitude  = [NSString stringWithString:
                           [self.locationProvider latitudeByUserDefaults]];
    
    NSString *longitude = [NSString stringWithString:
                           [self.locationProvider longitudeByUserDefaults]];
    
    NSString *altitude  = [NSString stringWithString:
                           [self.locationProvider altitudeByUserDefaults]];
    
    NSString *speed     = [NSString stringWithString:
                           [self.locationProvider speedByUserDefaults]];
    
    NSString *heading   = [NSString stringWithString:
                           [self.locationProvider headingByUserDefaults]];
    
    NSString *course    = [NSString stringWithString:
                           [self.locationProvider courseByUserDefaults]];
    
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
    [svc setTitle:NSLocalizedString(@"Settings",nil)]; 
    
    
        
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:svc];
    [svc release]; 
    
    [nc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentModalViewController:nc animated:YES];
        //[self.navigationController pushViewController:svc animated:YES];
        //[svc release];
    [nc release];
    
    
	  
    
}

- (void)doSetup {

    [self loadData];
    [self.tableView reloadData];  
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"RVC viewWillAppear:" );
    [super viewWillAppear:animated];
    [self.locationProvider startUpdatingLocationAndHeading];
    
        //[NSThread detachNewThreadSelector:@selector(setupAllSelectors) toTarget:self withObject:nil];    
        //[NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];    
    [self doSetup];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    [self.locationProvider stopUpdatingLocationAndHeading];
}


- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"viewDidDisappear");
    
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
    
    static NSString *CustomCell = @"iGPSCustomTableViewCell";
    
    iGPSCustomTableViewCell *cell = (iGPSCustomTableViewCell *)[table dequeueReusableCellWithIdentifier:CustomCell];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TableCellView" owner:nil options:nil];
        for (id element in topLevelObjects) {
            if ([element isKindOfClass:[UITableViewCell class]]) {
                cell = (iGPSCustomTableViewCell *)element;
            }
        }
    }
    
    
    
    [cell setMainTextLabel:[self.values objectAtIndex:indexPath.row]];
    [cell setDetailTextLabel:[self.names objectAtIndex:indexPath.row]];	

    return cell;
}

- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section {
    
    return NSLocalizedString(@"My location",nil);
    
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [table deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {  
    self.names = nil;
    self.values = nil;
    self.locationProvider = nil;
}


- (void)dealloc {
    [names release];
    [values release];
    [locationProvider release];
    [super dealloc];
}


@end

