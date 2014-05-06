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

typedef enum {
    kRequired,
    kDates,
    kDownloaded,
    kRewatch
}AddMediaSection;

@interface AddMediaViewController : UITableViewController

@property (nonatomic) Anime* anime;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (weak, nonatomic) IBOutlet UILabel *statusSelectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreSelectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *watchedSelectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateSelectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateSelectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadedSelectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *storageTypeSelectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewatchedSelectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewatchValueSelectionLabel;

@property (weak, nonatomic) IBOutlet UIStepper *scoreStepper;
@property (weak, nonatomic) IBOutlet UIStepper *episodeStepper;
@property (weak, nonatomic) IBOutlet UIStepper *downloadedStepper;
@property (weak, nonatomic) IBOutlet UIStepper *rewatchedStepper;

@end
