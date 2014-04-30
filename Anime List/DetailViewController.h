//
//  DetailViewController.h
//  Anime List
//
//  Created by Aaron Sky on 4/18/14.
//  Copyright (c) 2014 Aaron Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Anime.h"
#import "UserStore.h"
#import "URBMediaFocusViewController.h"
#import "AddMediaViewController.h"

@interface DetailViewController : UIViewController

@property (nonatomic, weak) Anime* anime;
@property (weak, nonatomic) IBOutlet UIImageView *animeImageView;
@property (weak, nonatomic) IBOutlet UILabel *animeName;
@property (weak, nonatomic) IBOutlet UILabel *epCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *runDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *watchStatusLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addToAnimeList;

@end
