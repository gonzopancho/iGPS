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


@synthesize delegate;
@synthesize reader;


- (void)awakeFromNib {
    
    if (!self.reader) {
        self.reader = [[SettingsBundleReader alloc] init];
    }
    [self performSelector:@selector(setupData)];
    
}

#pragma mark -
#pragma mark View lifecycle


- (IBAction)done:(id)sender {

    [self.delegate settingsViewControllerDidFinish];	
}


- (void)setupData {
    
    dispatch_queue_t setupQueue = dispatch_queue_create("iGPS.SettingsViewController.setupQueue", NULL);
    dispatch_async(setupQueue, ^{
        
        [self.reader setup];
        
    });
    dispatch_release(setupQueue);
        
    
}
    
- (void)refreshTable {
    
    dispatch_queue_t refreshQueue = dispatch_queue_create("iGPS.SettingsViewController.refreshQueue", NULL);
    dispatch_async(refreshQueue, ^{
        
        @synchronized(self) {
        
            [self.reader loadDefaultValues];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
    });
    dispatch_release(refreshQueue);
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    self.title = NSLocalizedString(@"Settings",nil);
    [self refreshTable];
    [super viewWillAppear:animated];
    
}


#pragma mark -
#pragma mark Table view data source

- (NSDictionary *)rowForIndexPath:(NSIndexPath *)indexPath {
    
    return [[self.reader.rows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
}


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
        
        
        [dvc setTitle:NSLocalizedString([row objectForKey:@"Title"],nil)];
        [self.navigationController pushViewController:dvc animated:YES];
        [dvc release];

    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)dealloc {
    [reader release];
    [super dealloc];
}

@end

