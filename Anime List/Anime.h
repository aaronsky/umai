//
//  AnimeModel.h
//  Anime List
//
//  Created by Aaron Sky on 4/23/14.
//  Copyright (c) 2014 Aaron Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kUnknown = 0,
    kWatching = 1, //watching
    kCompleted = 2, //completed
    kOnHold = 3, //onhold
    kDropped = 4, //dropped
    kPlanToWatch = 6 //plantowatch
}CompletionStatus;

@interface Anime : NSObject

@property (nonatomic) int series_animedb_id;
@property (nonatomic, copy) NSString* series_title;
@property (nonatomic) NSArray* series_synonyms;
@property (nonatomic) int series_type;
@property (nonatomic) int series_episodes;
@property (nonatomic) CompletionStatus series_status;
@property (nonatomic) NSDate* series_start;
@property (nonatomic) NSDate* series_end;
@property (nonatomic) UIImage* series_image;
@property (nonatomic,copy) NSString* series_synopsis;
@property (nonatomic) int my_id;
@property (nonatomic) int my_watched_episodes;
@property (nonatomic) NSDate* my_start_date;
@property (nonatomic) NSDate* my_finish_date;
@property (nonatomic) int my_score;
@property (nonatomic) CompletionStatus my_status;
@property (nonatomic) BOOL my_rewatching;
@property (nonatomic) int my_rewatching_ep;
@property (nonatomic) int my_last_updated;
@property (nonatomic) NSArray* my_tags;

-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
