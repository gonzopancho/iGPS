//
//  iGPSCustomTableViewCell.m
//  iGPS
//
//  Created by Jakub Petrík on 1/8/11.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import "iGPSCustomTableViewCell.h"


@implementation iGPSCustomTableViewCell

@synthesize mainText;
@synthesize detailText;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void)setMainTextLabel:(NSString *)newMainText {
    self.mainText.text = newMainText;
}


- (void)setDetailTextLabel:(NSString *)newDetailText {
    self.detailText.text = newDetailText;
}


- (void)dealloc {
    [mainText release];
    [detailText release];
    [super dealloc];
}


@end
