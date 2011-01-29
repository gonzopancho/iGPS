//
//  SettingsDetailViewController.m
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import "SettingsDetailViewController.h"
#import "SettingsViewController.h"
#import "SettingsBundleReader.h"
#import "Constants.h"

//  Implementacia triedy
@implementation SettingsDetailViewController

//  Automaticky generovane metody accessorov
@synthesize data;
@synthesize keyForData;
@synthesize selectedRow;


#pragma mark -
#pragma mark Initialization


//  Nastavi nadpisi.
- (void)makeTitles {
    
    self.title = NSLocalizedString([self.data objectForKey:iGPSTitleKey],nil);
    self.navigationController.navigationBar.backItem.title = NSLocalizedString(@"Settings",nil);
    
}

//  Metóda v prípade, že sa líši práve vybraný riadok tabuľky od hodnoty pre kľúč atribútu
//  keyForData slovníkového kontajnera prijatej notifikácie, uskutoční zmenu vybraného 
//  riadku tabuľky rámca.
- (void)reloadData:(NSNotification *)aNotification {
    
    NSNumber *number = [[[aNotification object] dictionaryRepresentation] objectForKey:self.keyForData];
    
    if (![number isEqualToNumber:self.selectedRow]) {
        self.selectedRow = number;
        [self.tableView reloadData];
    }
    
}

- (NSString *)keyForData {
    
    if (!keyForData) {
        self.keyForData = [NSString stringWithString:[self.data objectForKey:iGPSKey]];
    }
    
    return keyForData;
}

- (NSNumber *)selectedRow {
    
    if (!selectedRow) {
        NSNumber *temp = [[NSUserDefaults standardUserDefaults] objectForKey:self.keyForData];
        self.selectedRow = temp;
    }
    
    return selectedRow;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    
    NSLog(@"viewDidLoad");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    
    @try {
        
        NSString *keyPath = [self.data objectForKey:iGPSTitleKey];
        if ([keyPath isKindOfClass:[NSString class]]) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                   forKeyPath:keyPath
                                                      options:NSKeyValueObservingOptionNew
                                                      context:nil];
        }
    }
    @catch (NSException * e) {
        NSLog(@"%@",[e description]);
    }    
    

    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self makeTitles];
    [self.tableView reloadData];
}

//  Metóda pošle správu s menom hodnoty atribútu keyForData a atribútu
//  selectedRow ako objekt správy. Tiež zapíše do pamäte aktuálne zmenené nastavenia.
- (void)sendNotification {
    NSLog(@"sendNotification for row %d",[self.selectedRow intValue]);
    [[NSUserDefaults standardUserDefaults] setObject:self.selectedRow forKey:self.keyForData];
    [[NSNotificationCenter defaultCenter] postNotificationName:self.keyForData object:self.selectedRow];

}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self.data objectForKey:iGPSTitlesKey] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
        
    NSArray *labels = [self.data objectForKey:iGPSTitlesKey];
    
    cell.textLabel.text = NSLocalizedString([labels objectAtIndex:indexPath.row],nil);
    
    if (indexPath.row == [self.selectedRow intValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

//  Metoda ozanci bunku za vybratu a nastavi jej fajku ako accessory.
//  Posle notifikaciu a ulozi nastavenie do pamate.
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row != [self.selectedRow intValue]) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.selectedRow intValue] 
                                                                                         inSection:0]];
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
        [newCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        self.selectedRow = [NSNumber numberWithInt:indexPath.row];
        [self sendNotification];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}


#pragma mark -
#pragma mark Memory management

- (void)releaseOutlets {
    
    self.selectedRow = nil;
    self.keyForData = nil;
    self.data = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;    
    [self releaseOutlets];

}


- (void)dealloc {
    
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self releaseOutlets];
    [super dealloc];
}


@end

