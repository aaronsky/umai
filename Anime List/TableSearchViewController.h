//
//  SearchViewController.h
//  Anime List
//
//  Created by Aaron Sky on 4/18/14.
//  Copyright (c) 2014 Aaron Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserStore.h"
#import "Anime.h"
#import "DetailViewController.h"

@interface TableSearchViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, weak) Anime* selected;

@end
