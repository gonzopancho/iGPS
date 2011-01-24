//
//  RootViewController.m
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import "RootViewController.h"
#import "iGPSCustomTableViewCell.h"
#import "SettingsViewController.h"
#import "LocationProvider.h"
#import "Constants.h"
#import <dispatch/dispatch.h>

@interface RootViewController ()

- (void)setStringValue:(NSString *)value atIndex:(NSIndexPath *)index;
- (void)makeTitles;

@end



@implementation RootViewController

@synthesize locationProvider;
@synthesize names;
@synthesize values;

#pragma mark -
#pragma mark View lifecycle

- (void)setupNavigationItems {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Slovensky",nil)
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(changeLanguage:)];  
    self.navigationItem.leftBarButtonItem = item;  
    
    [item release];  
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
            
    if (!self.locationProvider) {
        self.locationProvider = [[LocationProvider alloc] init];
    }
    [self.locationProvider setDelegate:self];
    
    [self setTitle:@"iGPS"];
    [self makeTitles];
    [self setupNavigationItems];

}

- (void)makeTitles {
    
    NSArray *array = self.tabBarController.viewControllers;
    
    UINavigationController *nc = [array objectAtIndex:1];
    
    if ([nc isKindOfClass:[UINavigationController class]]) {
        nc.title = NSLocalizedString(@"Settings",nil); 
    }
    
}


- (IBAction)changeLanguage:(id)sender {
    
    NSMutableArray *languages = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] mutableCopy];
    
    NSString *lang = [languages objectAtIndex:0];
    
    
    if ([lang isEqualToString:@"en"]) {
        lang = @"sk";
    } else lang = @"en";
    
    [languages replaceObjectAtIndex:0 withObject:lang];
    [[NSUserDefaults standardUserDefaults] setObject:languages forKey:@"AppleLanguages"];
    [languages release];
    
    [self makeTitles];
    [self setupNavigationItems];
    [self viewWillAppear:NO];
    
}

- (void)settingsViewControllerDidFinish {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)locationProviderDidUpdateLocation {
     
}

- (void)updateCellForIndexPath:(NSIndexPath *)indexPath withSelector:(SEL)aSelector {
    
    iGPSCustomTableViewCell *cell = (iGPSCustomTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *label = [self.locationProvider performSelector:aSelector];

    dispatch_async(dispatch_get_main_queue(), ^{
        [cell setMainTextLabel:label];
    });
    
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
    

    dispatch_queue_t altitudeQueue = dispatch_queue_create("iGPS.LatitudeQueue", NULL);
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
    
    dispatch_queue_t load = dispatch_queue_create("iGPS.RootViewController.loadQueue", NULL);
    dispatch_async(load, ^{
        
        [self setupValues];
        [self setupNames];
        
            //mutex
        @synchronized(self){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData]; //kriticka sekcia
            });
        }
    });
    dispatch_release(load);
    
}



- (void)doSetup {

    [self loadData];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [self.locationProvider startUpdatingLocationAndHeading];
    [self doSetup];
    [super viewWillAppear:animated];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [self.locationProvider stopUpdatingLocationAndHeading];
    [super viewWillDisappear:animated];
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

- (void)releaseOutlets {
    
    self.names = nil;
    self.values = nil;
    self.locationProvider = nil;
    
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {  
    [self releaseOutlets];
}


- (void)dealloc {
    [self releaseOutlets];
    [super dealloc];
}


@end

