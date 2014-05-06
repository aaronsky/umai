//
//  AnimeModel.m
//  Anime List
//
//  Created by Aaron Sky on 4/23/14.
//  Copyright (c) 2014 Aaron Sky. All rights reserved.
//

#import "Anime.h"

@implementation Anime

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-mm-dd"];
        
        _series_animedb_id = [dictionary[@"series_animedb_id"] ? dictionary[@"series_animedb_id"] : (dictionary[@"id"] ? dictionary[@"id"] : 0) intValue];
        _series_title = dictionary[@"series_title"] ? [NSString stringWithFormat:@"%@",dictionary[@"series_title"]] : (dictionary[@"title"] ? [NSString stringWithFormat:@"%@",dictionary[@"title"]] : nil);
        _series_synonyms = [(dictionary[@"series_synonyms"] ? dictionary[@"series_synonyms"] : dictionary[@"synonyms"]) componentsSeparatedByString:@";"];
        _series_type = [dictionary[@"series_type"] ? dictionary[@"series_type"] : (dictionary[@"type"] ? dictionary[@"type"] : 0) intValue];
        _series_episodes = [dictionary[@"series_episodes"] ? dictionary[@"series_episodes"] : (dictionary[@"episodes"] ? dictionary[@"episodes"] : 0) intValue];
        _series_status = dictionary[@"series_status"] ? [dictionary[@"series_status"] intValue] : 0;
        _series_start = dictionary[@"series_start"] ? [dateFormat dateFromString:dictionary[@"series_start"]] : (dictionary[@"start_date"] ? [dateFormat dateFromString:dictionary[@"start_date"]] : [NSDate date]);
        _series_end = dictionary[@"series_end"] ? [dateFormat dateFromString:dictionary[@"series_end"]] : (dictionary[@"end_date"] ? [dateFormat dateFromString:dictionary[@"end_date"]] : [NSDate date]);
        _series_image = dictionary[@"series_image"] ? [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dictionary[@"series_image"]]]] : (dictionary[@"image"] ? [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dictionary[@"image"]]]] : [[UIImage alloc]init]);
        _series_synopsis = dictionary[@"synopsis"] ? dictionary[@"synopsis"] : @"";
        _my_id = [(dictionary[@"my_id"] ? dictionary[@"my_id"] : 0) intValue];
        _my_watched_episodes = [(dictionary[@"my_watched_episodes"] ? dictionary[@"my_watched_episodes"] : 0) intValue];
        _my_start_date = dictionary[@"my_start_date"] ? [dateFormat dateFromString:dictionary[@"my_start_date"]] : [NSDate date];
        _my_finish_date = dictionary[@"my_finish_date"] ? [dateFormat dateFromString:dictionary[@"my_finish_date"]] : [NSDate date];
        _my_score = dictionary[@"my_score"] ? [dictionary[@"my_score"] intValue] : 0;
        _my_status = [(dictionary[@"my_status"] ? dictionary[@"my_status"] : 0) intValue];
        _my_rewatching = [(dictionary[@"my_rewatching"] ? dictionary[@"my_rewatching"] : 0) boolValue];
        _my_rewatching_ep = [(dictionary[@"my_rewatching_ep"] ? dictionary[@"my_rewatching_ep"] : 0) intValue];
        _my_last_updated = [(dictionary[@"my_last_updated"] ? dictionary[@"my_last_updated"] : 0) intValue];
        _my_tags = [(dictionary[@"my_tags"] ? dictionary[@"my_tags"] : @"") componentsSeparatedByString:@";"];
        
    }
    return self;
}

@end
