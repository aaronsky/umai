//
//  CollectionMediaViewController.m
//  Anime List
//
//  Created by Aaron Sky on 4/27/14.
//  Copyright (c) 2014 Aaron Sky. All rights reserved.
//

#import "CollectionMediaViewController.h"

@interface CollectionMediaViewController ()

@end

@implementation CollectionMediaViewController {
    UIActivityIndicatorView* activityIndicator;
    NSURLSession* _session;
    NSMutableArray* _filteredResults;
    XMLDictionaryParser* _parser;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData
{
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    config.HTTPAdditionalHeaders = @{
                                     @"user-agent" : @"api-indiv-251441CE138A074CF5CFDB484047C6FD",
                                     @"username" : [UserStore currentUser].username,
                                     @"password" : [UserStore currentUser].password
                                     };
    _session = [NSURLSession sessionWithConfiguration:config];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //This is really messy, fix this later
    NSMutableString* searchString = [NSMutableString string];
    [searchString appendString:@"http://myanimelist.net/malappinfo.php?u="];
    [searchString appendString:[UserStore currentUser].username];
    [searchString appendString:@"&status=all&type=anime"];
    
    
    NSURL *url = [NSURL URLWithString:searchString];
    NSURLSessionDataTask* dataTask = [_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            NSHTTPURLResponse* httpResp = (NSHTTPURLResponse*)response;
            
            if (httpResp.statusCode == 200) {
                
                NSDictionary* dictFromXml = [_parser dictionaryWithData:data];
                
                if (dictFromXml) {
                    NSMutableArray* tempArray = [NSMutableArray array];
                    
                    for (NSDictionary* dict in dictFromXml[@"anime"]) {
                        Anime* anime = [[Anime alloc]initWithDictionary:dict];
                        [tempArray addObject:anime];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        [UIView animateWithDuration:0.5f
                                              delay:0.0f
                                            options:UIViewAnimationOptionCurveEaseOut
                                         animations:^{
                                             [activityIndicator setAlpha:0.0f];
                                         } completion:^(BOOL finished) {
                                             _animeList = tempArray;
                                             //[self.tableView reloadData];
                                         }];
                    });
                }
            }
        }
    }];
    [activityIndicator startAnimating];
    [dataTask resume];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_animeList count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AnimeListCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Anime* cellAnime = _animeList[indexPath.row];
    cell.titleLabel.text = cellAnime.series_title;
    cell.progressLabel.text = [NSString stringWithFormat:@"%d/%d Watched", cellAnime.my_watched_episodes, cellAnime.series_episodes];
    cell.posterImage.image = cellAnime.series_image;
    
    return cell;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
