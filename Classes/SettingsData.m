//
//  SettingsData.m
//  iGPS
//
//  Created by Jakub Petrík on 1/1/11.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import "SettingsData.h"


@implementation SettingsData

@synthesize data;
@synthesize sections;
@synthesize rows;
@synthesize row;
@synthesize isChild;



- (NSArray *)data {
    
    NSString *pathString = [[NSBundle mainBundle] bundlePath];
    NSString *settingsBundlePath = [pathString stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *fullPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:fullPath];
    
    self.data = [NSArray arrayWithArray:[dict objectForKey:@"PreferenceSpecifiers"]];
    
    return data;
}

- (NSArray *)sections {
    
    NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSDictionary *dict in self.data) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            if ([[dict objectForKey:@"Type"] isEqual:@"PSGroupSpecifier"]) {
                [temp addObject:dict];
            }
        }
    }

    self.sections = temp;
    
    return sections;
}

- (NSArray *)rows {
    
    NSMutableArray *subArray = [NSMutableArray array];
    NSMutableArray *mainArray = [NSMutableArray array];
    
    for (NSDictionary *dict in self.data) {
        
        if ([dict isKindOfClass:[NSDictionary class]]) {
            if (![[dict objectForKey:@"Type"] isEqual:@"PSGroupSpecifier"]) {
                [subArray addObject:dict];
            } else if ([subArray count] > 0) {
                
                [mainArray addObject:[NSArray arrayWithArray:subArray]];
                [subArray removeAllObjects];
            }
            
        }
    }
    
    if ([subArray count] > 0) [mainArray addObject:[NSArray arrayWithArray:subArray]];
    
    
    self.rows = mainArray;    
    
    return rows;
    
}


- (void)dealloc {
    [rows release];
    [sections release];
    [data release];
    [super dealloc];
}

@end
