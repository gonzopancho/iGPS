//
//  SettingsBundleReader.m
//  iGPS
//
//  Created by Jakub Petrík on 1/24/11.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import "SettingsBundleReader.h"


@implementation SettingsBundleReader

@synthesize rows;
@synthesize sections;
@synthesize defaultValues;


- (void)setup {
    
    [self loadRowsAndSections];
    [self loadDefaultValues];
    
}

- (id)initAndSetup {
    
    if ((self = [super init])) {
        [self setup];
    }
    return self;
}

- (NSArray *)settingsBundle {
    
    NSString *pathStr = [[NSBundle mainBundle] bundlePath];
    NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    
    return [NSArray arrayWithArray:[dict objectForKey:@"PreferenceSpecifiers"]];
}


- (void)loadDefaultValues {
    
    __block NSMutableArray *temp = [NSMutableArray array];
    NSMutableArray *storage      = [NSMutableArray array];
    
    [self.rows enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL *stop) {
        
        for (NSDictionary *dict in obj) {
            
            NSArray *values = [dict objectForKey:@"Titles"];
            NSNumber *defaultValue = [[NSUserDefaults standardUserDefaults] objectForKey:[dict objectForKey:@"Key"]];
            
            [temp addObject:NSLocalizedString([values objectAtIndex:[defaultValue intValue]],nil)];
            
        }
        
        [storage addObject:temp];
        temp = [NSMutableArray array];
    }];
    
    self.defaultValues = storage;
    
}


- (void)loadRowsAndSections {
    
    NSMutableArray *subArray = [NSMutableArray array];
    NSMutableArray *mainArray = [NSMutableArray array];
    NSMutableArray *tempSections = [NSMutableArray array];
        
   [[self settingsBundle] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx,BOOL *stop){
                                              
       if ([dict objectForKey:@"Key"]) {
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


- (NSDictionary *)dataForIndexPath:(NSIndexPath *)indexPath {
    
    return [[self.rows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}






- (void)dealloc {
    [rows release];
    [sections release];
    [defaultValues release];
    [super dealloc];
}

@end
