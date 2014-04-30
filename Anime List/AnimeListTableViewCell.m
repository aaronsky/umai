//
//  AnimeListTableViewCell.m
//  Anime List
//
//  Created by Aaron Sky on 4/24/14.
//  Copyright (c) 2014 Aaron Sky. All rights reserved.
//

#import "AnimeListTableViewCell.h"

@implementation AnimeListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
