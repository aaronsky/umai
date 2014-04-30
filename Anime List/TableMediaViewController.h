//
//  MediaViewController.h
//  Anime List
//
//  Created by Aaron Sky on 4/18/14.
//  Copyright (c) 2014 Aaron Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserStore.h"
#import "Anime.h"
#import "AnimeListTableViewCell.h"
#import "DetailViewController.h"

@interface TableMediaViewController : UITableViewController<UISearchDisplayDelegate,UISearchBarDelegate>

@property (nonatomic) NSMutableArray* animeList;
@property (nonatomic, weak) Anime* selected;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareListButton;

@end
