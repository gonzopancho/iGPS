//
//  SettingsViewController.m
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsBundleReader.h"
#import "SettingsDetailViewController.h"
#import "Constants.h"
#import <dispatch/dispatch.h>


//  Implementacia triedy
@implementation SettingsViewController

//  Automaticky generovane metod accessorov
@synthesize reader;

//  Metóda volaná po načítaní príslušnej objektovej siete. 
//  Využívaná pre doplňujúce nastavenia, ktoré nemôžu byť
//  uskutočniteľné pri procese dizajnu konkrétnej objektovej 
//  siete. Inicializuje a nastaví atributy inštancie a
//  registruje inštanciu pre príjem notifikácií.
- (void)awakeFromNib {
    
    if (!self.reader) {
        self.reader = [[SettingsBundleReader alloc] init];
    }
    [self performSelector:@selector(setupData)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    
    [super awakeFromNib];    
    
}

#pragma mark -
#pragma mark View lifecycle

//  Metóda nastaví atribut reader triedy SBR pomocou správy setup.
- (void)setupData {
    
    dispatch_queue_t setupQueue = dispatch_queue_create("iGPS.SettingsViewController.setupQueue", NULL);
    dispatch_async(setupQueue, ^{
        
        [self.reader setup];
        
    });
    dispatch_release(setupQueue);
        
    
}

//  Metóda volania pri obdržaní notifikácie o zmene užívateľských nastavení. 
//  Aktualizuje jednotlivé riadky tabuľky rámca.
- (void)refreshTable {

    
    NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self.reader
                                                                            selector:@selector(loadDefaultValues)
                                                                              object:nil];
    [queue addOperation:operation];
    [operation release];

    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
}

//  Druhotna inicializacia
- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationItem.title = NSLocalizedString(@"Settings",nil);
    
    [self refreshTable];
    [super viewWillAppear:animated];
    
}


#pragma mark -
#pragma mark Table view data source

//  Vrati slovnik reprezentujuci riadok na konretnej indexovej ceste
- (NSDictionary *)rowForIndexPath:(NSIndexPath *)indexPath {
    
    return [[self.reader.rows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
}

// Prisposoby pocet sekcii v tabulke
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {

    return [self.reader.sections count]; 
    
}

//  Prisposoby pocet riadkov sekcie.
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    
    return [[self.reader.rows objectAtIndex:section] count];
       
}

// Prisposoby titulok sekcie.
- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section {
    
    return NSLocalizedString([[self.reader.sections objectAtIndex:section] objectForKey:iGPSTitleKey],nil);
}

// Vracia nastavenu bunku tabulky
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    NSDictionary *row = [self rowForIndexPath:indexPath];
    NSString *textLabel = NSLocalizedString([row objectForKey:iGPSTitleKey],nil);
    NSString *detailLabel = [[self.reader.defaultValues objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = textLabel;

    // vieme ako vyzera xml, preto staci tato jedna podmienka
    if ([[row objectForKey:@"Type"] isEqualToString:@"PSMultiValueSpecifier"]) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = detailLabel;
            
    } 
    
    return cell;
    
}


#pragma mark -
#pragma mark Table view delegate


//  Metóda volaná pri registrácii dotyku na konkrétnom riadku tabuľky. 
//  Inicializuje SettingsDetailViewController inštanciu, priradí jej dáta,
//  ktoré má zobraziť a posunie ju do zásobníka svojho navigationController
//  atributu prostredníctvom správy pushViewController:animated:.
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *row = [self.reader dataForIndexPath:indexPath];
             
    if ([[row objectForKey:@"Type"] isEqual:[NSString stringWithString:@"PSMultiValueSpecifier"]]) {
        
        SettingsDetailViewController *dvc = [[SettingsDetailViewController alloc] 
                                             initWithNibName:@"TableView"
                                             bundle:nil];
        dvc.data = row;

        [self.navigationController pushViewController:dvc animated:YES];
        [dvc release];

    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}



#pragma mark -
#pragma mark Memory management

//  poziadavka na uvolnenie nepotrebnych objektov.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


//  Destruktor.
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [reader release];
    [super dealloc];
}

@end

