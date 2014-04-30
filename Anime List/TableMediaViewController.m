//
//  MediaViewController.m
//  Anime List
//
//  Created by Aaron Sky on 4/18/14.
//  Copyright (c) 2014 Aaron Sky. All rights reserved.
//

#import "TableMediaViewController.h"

@interface TableMediaViewController ()

@end

@implementation TableMediaViewController {
    UIActivityIndicatorView* activityIndicator;
    NSURLSession* _session;
    NSMutableArray* _filteredResults;
    XMLDictionaryParser* _parser;
}

#pragma mark - Initialize

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _filteredResults = [NSMutableArray array];
    _parser = [[XMLDictionaryParser alloc]init];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setFrame:self.view.frame];
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    
    [self loadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*! Loads anime list data from MAL API. Consider moving elsewhere.
 */
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
                                             [self.tableView reloadData];
                                         }];
                    });
                }
            }
        }
    }];
    [activityIndicator startAnimating];
    [dataTask resume];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredResults count];
    } else {
        return [_animeList count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnimeListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[AnimeListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    else {
        cell = (AnimeListTableViewCell*)cell;
    }
    Anime* cellAnime;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cellAnime = _filteredResults[indexPath.row];
    } else {
        cellAnime = _animeList[indexPath.row];
    }
    cell.titleLabel.text = cellAnime.series_title;
    cell.progressLabel.text = [NSString stringWithFormat:@"%d/%d Watched", cellAnime.my_watched_episodes, cellAnime.series_episodes];
    cell.posterImage.image = cellAnime.series_image;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        _selected = _filteredResults[indexPath.row];
    } else {
        _selected = _animeList[indexPath.row];
    }
    [self performSegueWithIdentifier:@"DetailFromList" sender:self];
}

-(void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    tableView.rowHeight = self.tableView.rowHeight;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Sharing

- (IBAction)shareButtonPressed:(UIBarButtonItem *)sender {
    NSURL* dataToShare = [NSURL URLWithString:@"http://myanimelist.net/profile/METC"];
    UIActivityViewController* activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[dataToShare] applicationActivities:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIPopoverController* popover = [[UIPopoverController alloc]initWithContentViewController:activityVC];
        [popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self.navigationController presentViewController:activityVC animated:YES completion:^{
            //nah
        }];
    }
}

#pragma mark - Searching
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate* resultPredicate = [NSPredicate predicateWithFormat:@"SELF.series_title contains[c] %@", searchText];
    _filteredResults = [NSMutableArray arrayWithArray:[_animeList filteredArrayUsingPredicate:resultPredicate]];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DetailFromList"]) {
        // Get the new view controller using [segue destinationViewController].
        DetailViewController* detailVC = [segue destinationViewController];
        // Pass the selected object to the new view controller.
        detailVC.anime = _selected;
    }
}

@end
