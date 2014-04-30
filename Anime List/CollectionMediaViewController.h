//
//  CollectionMediaViewController.h
//  Anime List
//
//  Created by Aaron Sky on 4/27/14.
//  Copyright (c) 2014 Aaron Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserStore.h"
#import "Anime.h"
#import "AnimeListCollectionViewCell.h"

@interface CollectionMediaViewController : UICollectionViewController

@property (nonatomic) NSMutableArray* animeList;

@end
