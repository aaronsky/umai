//
//  AddMediaViewController.h
//  Anime List
//
//  Created by Aaron Sky on 4/18/14.
//  Copyright (c) 2014 Aaron Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Anime.h"
#import "UserStore.h"

@interface AddMediaViewController : UITableViewController

@property (nonatomic) Anime* anime;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end
