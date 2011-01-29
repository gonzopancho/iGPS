//
//  iGPSCustomTableViewCell.m
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import "iGPSCustomTableViewCell.h"


@implementation iGPSCustomTableViewCell

@synthesize mainText;
@synthesize detailText;

//  Konstruktor
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

//  Metoda nastavi bunku ako ozancenu.
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
}

//  Nastavy hlavny text bunky na text predany ako argument.
- (void)setMainTextLabel:(NSString *)newMainText {
    self.mainText.text = newMainText;
}

//  Nastavy vedajsi text bunky na text predany ako argument.
- (void)setDetailTextLabel:(NSString *)newDetailText {
    self.detailText.text = newDetailText;
}

//  Destruktor
- (void)dealloc {
    [mainText release];
    [detailText release];
    [super dealloc];
}


@end
