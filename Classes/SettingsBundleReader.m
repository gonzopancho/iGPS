//
//  SettingsBundleReader.m
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import "SettingsBundleReader.h"
#import "Constants.h"



@implementation SettingsBundleReader

@synthesize rows;
@synthesize sections;
@synthesize defaultValues;


//  vola metody loadRowsAndSections a loadDefaultValues
- (void)setup {
    
    [self loadRowsAndSections];
    [self loadDefaultValues];
    
}

//  inicializuje a nastavi instanciu
- (id)initAndSetup {
    
    if ((self = [super init])) {
        [self setup];
    }
    return self;
}

//  vracia xml Root.plist ako nemenne pole
- (NSArray *)settingsBundle {
    
    NSString *pathStr = [[NSBundle mainBundle] bundlePath];
    NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:iGPSSettingsBundle];
    NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:iGPSRootPlist];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    
    return [NSArray arrayWithArray:[dict objectForKey:iGPSPrefernceSpecifiersKey]];
}

//  nacita prevolene hodnoty v uzivatelskych nastaveniach
- (void)loadDefaultValues {
    
    __block NSMutableArray *temp = [NSMutableArray array];
    NSMutableArray *storage      = [NSMutableArray array];
    
    [self.rows enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL *stop) {
        
        for (NSDictionary *dict in obj) {
            
            NSArray *values = [dict objectForKey:iGPSTitlesKey];
            NSNumber *defaultValue = [[NSUserDefaults standardUserDefaults] objectForKey:[dict objectForKey:iGPSKey]];
            
            [temp addObject:NSLocalizedString([values objectAtIndex:[defaultValue intValue]],nil)];
            
        }
        
        [storage addObject:temp];
        temp = [NSMutableArray array];
    }];
    
    self.defaultValues = storage;
    
}

// nastavi atributy rows a sections
- (void)loadRowsAndSections {
    
    NSMutableArray *subArray = [NSMutableArray array];
    NSMutableArray *mainArray = [NSMutableArray array];
    NSMutableArray *tempSections = [NSMutableArray array];
        
   [[self settingsBundle] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx,BOOL *stop){
                                              
       if ([dict objectForKey:iGPSKey]) {
           [subArray addObject:dict];
       } else {
           [tempSections addObject:dict];
           if ([subArray count] > 0) {
               [mainArray addObject:[NSArray arrayWithArray:subArray]];
               [subArray removeAllObjects];
           }
       }
                                               
    }];
    if ([subArray count] > 0) [mainArray addObject:[NSArray arrayWithArray:subArray]];
    
    self.rows = mainArray;
    self.sections = tempSections;

}

//  vrati slovnikovy kontajner pre predany objekt triedy NSIndexPath, 
//  ktora reprezentuje specificky uzol vo viacrozmernych poliach
- (NSDictionary *)dataForIndexPath:(NSIndexPath *)indexPath {
    
    return [[self.rows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}


//  destruktor
- (void)dealloc {
    
    [rows release];
    [sections release];
    [defaultValues release];
    [super dealloc];
}

@end
