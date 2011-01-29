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
#import "Constants.h"
#import "iGPSTimer.h"
#import <dispatch/dispatch.h>


//  Sukromne atributy a metody.
@interface RootViewController ()

//  Casovac.
@property (nonatomic, retain) iGPSTimer *timer;

//  Aktualizuje pole values.
- (void)setStringValue:(NSString *)value atIndex:(NSIndexPath *)index;

//  Nastavy nadpis ramca SettingsView v jeho navigation controllery.
- (void)makeSVCTitle;

@end


//  Implementacia triedy
@implementation RootViewController

//  Automaticky generovane metody accessorov
@synthesize locationProvider;
@synthesize names;
@synthesize values;
@synthesize timer;

#pragma mark -
#pragma mark View lifecycle

//  Nastavi KVO.
- (void)setupKeyValueObserving {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateElapsedTimeSinceLastLocationUpdate:)
                                                 name:kElapsedTimeKey
                                               object:nil];
    
}

//  Vytvori tlacidlo pre zmenu jazyka a naviaze nan prislusnu akciu.
- (void)setupNavigationItems {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Slovensky",nil)
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(changeLanguage:)];  
    self.navigationItem.leftBarButtonItem = item;  
    
    [item release];  
    
}

//  Metóda volaná po načítaní rámca triedy do pamäte. Používaná na ďalšiu inicializáciu.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupKeyValueObserving];
    
    NSLog(@"ViewDidLoad");
    
    //  Inicializacia locationProvidera
    if (!self.locationProvider) {
        self.locationProvider = [[LocationProvider alloc] init];
    }
    [self.locationProvider setDelegate:self];
    [self.locationProvider startUpdatingLocationAndHeading];
    
    //  Inicializacia casovaca timer
    if (!self.timer) {
        self.timer = [[iGPSTimer alloc] init];
    }
    [self.timer start];
    
    [self setTitle:@"iGPS"];
    [self makeSVCTitle];
    [self setupNavigationItems];
    
}

//  Nastavy nadpis ramca SettingsView v jeho navigation controllery.
- (void)makeSVCTitle {
    
    NSArray *array = self.tabBarController.viewControllers;
    
    UINavigationController *nc = [array objectAtIndex:1];
    
    if ([nc isKindOfClass:[UINavigationController class]]) {
        nc.title = NSLocalizedString(@"Settings",nil); 
    }
    
}

//  Metóda zmení nultý prvok v poli “AppleLanguages”, následne znovu načíta všetky viditeľné reťazce.
- (IBAction)changeLanguage:(id)sender {
    
    NSMutableArray *languages = [[[NSUserDefaults standardUserDefaults] objectForKey:kAppleLanguages] mutableCopy];
    
    id element = [languages objectAtIndex:0];
    
    
    if ([element isKindOfClass:[NSString class]]) {
        NSString *lang = (NSString *)element;
        
        lang = ([lang isEqual:@"en"]) ? @"sk" : @"en";
        
        [languages replaceObjectAtIndex:0 withObject:lang];
        [[NSUserDefaults standardUserDefaults] setObject:languages forKey:kAppleLanguages];
        
        [self makeSVCTitle];
        [self setupNavigationItems];
        [self viewWillAppear:NO];
    }
    
    [languages release];
    
}

//  Metóda prostredníctvom správy štart poslanej atribútu timer typu iGPSTimer 
//  zabezpečí poslanie notifikácie o uplynulom časovom intervale medzi jednotlivými 
//  aktualizáciami polohy.
- (void)locationProviderDidUpdateLocation {
    
    [self.timer start];
     
}


//  Metóda je vždy volaná z vedľajšieho vlákna. Získa pointer bunky tabuľky 
//  prostredníctvom predaného objektu triedy NSIndexPath, novú hodnotu hlavného
//  reťazca bunky vykonaním selektora predaného ako posledný argument a v hlavnom
//  vlákne ju nastavý ako hodntou hlavného reťazca bunky. Následne znova vo
//  vedľajšom vlákne úpravy hodnotu prvku atributu values podľa predného objektu indexPath.

- (void)updateCellForIndexPath:(NSIndexPath *)indexPath withSelector:(SEL)aSelector {
    
    iGPSCustomTableViewCell *cell = (iGPSCustomTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *label = [self.locationProvider performSelector:aSelector];

    dispatch_async(dispatch_get_main_queue(), ^{
        [cell setMainTextLabel:label];
    });
    
    [self setStringValue:label atIndex:indexPath];
}

//  Metóda ako všetky nepovinné metódy protokolu LocationProviderDelegate získa 
//  v hlavnom vlákne objekt indexPath pomocou správy indexPathForRow: inSection: 
//  a vo vedľajšom vlákne pomocou predchádzajúcej metódy nastaví konkrétnu bunku tabuľky rámca.
- (void)locationProviderDidUpdateHeading {    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Heading",nil)] 
                                                inSection:0];

    dispatch_queue_t headingQueue = dispatch_queue_create("iGPS.HeadingQueue", NULL);
    dispatch_async(headingQueue, ^{
        
        [self updateCellForIndexPath:indexPath withSelector:@selector(headingByUserDefaults)];
    });
    
    dispatch_release(headingQueue);
    
    
}

//  ako locationProviderDidUpdateHeading
- (void)locationProviderDidUpdateLatitude {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Latitude",nil)]
                                                inSection:0];
    
    dispatch_queue_t latitudeQueue = dispatch_queue_create("iGPS.LatitudeQueue", NULL);
    dispatch_async(latitudeQueue, ^{
        
        [self updateCellForIndexPath:indexPath withSelector:@selector(latitudeByUserDefaults)];
        
    });
    dispatch_release(latitudeQueue);
    
    
}

//  ako locationProviderDidUpdateHeading
- (void)locationProviderDidUpdateLongitude {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Longitude",nil)]
                                                inSection:0]; 
    
    dispatch_queue_t longitudeQueue = dispatch_queue_create("iGPS.LongitudeQueue", NULL);
    dispatch_async(longitudeQueue, ^{
        
        [self updateCellForIndexPath:indexPath withSelector:@selector(longitudeByUserDefaults)];
        
    });
    dispatch_release(longitudeQueue);

        
}

//  ako locationProviderDidUpdateHeading
- (void)locationProviderDidUpdateAltitude {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Altitude",nil)]
                                                inSection:0];
    
    dispatch_queue_t altitudeQueue = dispatch_queue_create("iGPS.LatitudeQueue", NULL);
    dispatch_async(altitudeQueue, ^{
        
        [self updateCellForIndexPath:indexPath withSelector:@selector(altitudeByUserDefaults)];
        
    });
    dispatch_release(altitudeQueue);
    
    
}

//  ako locationProviderDidUpdateHeading
- (void)locationProviderDidUpdateSpeed {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Speed",nil)]
                                                inSection:0];

    
    dispatch_queue_t speedQueue = dispatch_queue_create("iGPS.SpeedQueue", NULL);
    dispatch_async(speedQueue, ^{
        
        [self updateCellForIndexPath:indexPath withSelector:@selector(speedByUserDefaults)];
        
    });
    dispatch_release(speedQueue); 
}

//  ako locationProviderDidUpdateHeading
- (void)locationProviderDidUpdateCourse {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Course",nil)]
                                                inSection:0];
    
    dispatch_queue_t courseQueue = dispatch_queue_create("iGPS.CourseQueue", NULL);
    dispatch_async(courseQueue, ^{
        
        [self updateCellForIndexPath:indexPath withSelector:@selector(courseByUserDefaults)];
        
    });
    
    dispatch_release(courseQueue);
    
}

//  ako locationProviderDidUpdateHeading
- (void)locationProviderDidUpdateVerticalAccuracy {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Vertical accuracy",nil)] 
                                                inSection:0];
    
    dispatch_queue_t verticalAccQueue = dispatch_queue_create("iGPS.VerticalAccQueue", NULL);
    dispatch_async(verticalAccQueue, ^{
        
        [self updateCellForIndexPath:indexPath withSelector:@selector(veritcalAccuracyByUserDefaults)];
    
    });
    
    dispatch_release(verticalAccQueue); 
}

//  ako locationProviderDidUpdateHeading
- (void)locationProviderDidUpdateHorizontalAccuracy {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Horizontal accuracy",nil)] 
                                                inSection:0];
    
    dispatch_queue_t horizontalAccQueue = dispatch_queue_create("iGPS.HorizontalAccQueue", NULL);
    dispatch_async(horizontalAccQueue, ^{
        
        [self updateCellForIndexPath:indexPath withSelector:@selector(horizontalAccuracyByUserDefaults)];
        
    });
    dispatch_release(horizontalAccQueue); 
}

//  Metóda príjma správy o uplynutí časového intervalu medzi jednotlivými 
//  aktualizáciami polohy, následne tento nový údaj nastavý zodpovedajúcemu riadku tabuľky.
- (void)updateElapsedTimeSinceLastLocationUpdate:(NSNotification *)aNotification {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.names indexOfObjectIdenticalTo:NSLocalizedString(@"Last update",nil)]
                                                inSection:0];
    
    iGPSCustomTableViewCell *cell = (iGPSCustomTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSNumber *elapsedTime = (NSNumber *)[aNotification object];
    int seconds = [elapsedTime intValue];
    
    NSString *label;
    
    if (seconds == 1) {
        label = [NSString stringWithFormat:@"%d %@",seconds,NSLocalizedString(@"second ago",nil)];
    } else if (seconds > 1 && seconds <= 4) {
        label = [NSString stringWithFormat:@"%d %@",seconds,NSLocalizedString(@"sekundy dozadu",nil)];
    } else {
        label = [NSString stringWithFormat:@"%d %@",seconds,NSLocalizedString(@"seconds ago",nil)];
    }

    
    
    [cell setMainTextLabel:label];    
    [self setStringValue:label atIndex:indexPath];
    
    
}

//  Aktualizuje pole values.
- (void)setStringValue:(NSString *)value atIndex:(NSIndexPath *)index {
    
    if ([self.values count] > index.row) {
        [self.values replaceObjectAtIndex:index.row withObject:value];
    }
    
}

// inicializuje pole values na vychodzie hodnoty
- (void)setupValues {
    
    NSString *lastUpdate;
    
    if (self.values) {
        lastUpdate = [self.values objectAtIndex:0];
    } else {
        lastUpdate = [NSString stringWithFormat:@"0 %@",NSLocalizedString(@"seconds ago",nil)];
    }
    
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
    
    
   
        
    NSMutableArray *array = [NSMutableArray arrayWithObjects:
                             lastUpdate,
                             vAccuracy,
                             hAccuracy,
                             latitude,
                             longitude,
                             heading,
                             altitude,
                             speed,
                             course,nil];
    self.values = array;
   
    
}

//  Inicializuje pole names na vychodzie hodnoty.
- (void)setupNames {
    
    self.names = [NSArray arrayWithObjects:
                  NSLocalizedString(@"Last update",nil),
                  NSLocalizedString(@"Vertical accuracy",nil),
                  NSLocalizedString(@"Horizontal accuracy",nil),
                  NSLocalizedString(@"Latitude",nil),
                  NSLocalizedString(@"Longitude",nil),
                  NSLocalizedString(@"Heading",nil),
                  NSLocalizedString(@"Altitude",nil),
                  NSLocalizedString(@"Speed",nil),
                  NSLocalizedString(@"Course",nil),nil];
    
}

//  nastavy polia values a names znovunacita data do tabulky
- (void)loadData {
    
    [self setupValues];
    [self setupNames];
    
    [self.tableView reloadData]; 
    
}

//  nastavi polia values a names a data tabulky
- (void)viewWillAppear:(BOOL)animated {

    
    [self loadData];
    [super viewWillAppear:animated];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
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


//  Pomocna metoda na uvolnovanie zdrojov.
- (void)releaseOutlets {
    
    self.names = nil;
    self.values = nil;
    self.timer = nil;
    self.locationProvider = nil;
    
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

//  Metoda volana ked sa ramec uvolni z pamate
- (void)viewDidUnload {  
    [self.locationProvider stopUpdatingLocationAndHeading];
    [self releaseOutlets];
}

//  Destruktor.
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self releaseOutlets];
    [super dealloc];
}


@end

