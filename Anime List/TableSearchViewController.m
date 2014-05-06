//
//  SearchViewController.m
//  Anime List
//
//  Created by Aaron Sky on 4/18/14.
//  Copyright (c) 2014 Aaron Sky. All rights reserved.
//

#import "TableSearchViewController.h"

@interface TableSearchViewController ()

@end

@implementation TableSearchViewController {
    NSURLSession* _session; //Session Manager (consider moving to a MAL utility class)
    NSMutableArray* _filteredResults; //Array of results
    XMLDictionaryParser* _parser; //Parser object (consider moving to a MAL utility class)
}

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return _filteredResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // Configure the cell...
    Anime* animeForCell = _filteredResults[indexPath.row];
    cell.textLabel.text = animeForCell.series_title;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selected = _filteredResults[indexPath.row];
    [self performSegueWithIdentifier:@"DetailFromSearch" sender:self];
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

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

#pragma mark - Searching
-(void)getContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSString* authInfo = [[[NSString stringWithFormat:@"%@:%@",[UserStore currentUser].username, [UserStore currentUser].password] dataUsingEncoding:NSASCIIStringEncoding] base64EncodedStringWithOptions:0];
    config.HTTPAdditionalHeaders = @{
                                     @"user-agent" : @"api-indiv-251441CE138A074CF5CFDB484047C6FD",
                                     @"Authorization": [NSString stringWithFormat:@"Basic %@",authInfo]
                                     };
    _session = [NSURLSession sessionWithConfiguration:config];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //iOS 7 added enhancements to networking directly to Foundation. Here's an undocumented one~!
    NSURLComponents* searchString = [NSURLComponents new];
    searchString.scheme = @"http";
    searchString.host = @"myanimelist.net";
    searchString.path = @"/api/anime/search.xml";
    searchString.query = [NSString stringWithFormat:@"q=%@",searchText];
    NSURL* url = [searchString URL];
    
    NSURLSessionDataTask* dataTask = [_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            NSHTTPURLResponse* httpResp = (NSHTTPURLResponse*)response;
            
            if (httpResp.statusCode == 200) {
                NSDictionary* dictFromXml = [_parser dictionaryWithData:data];
                
                if (dictFromXml) {
                    NSMutableArray* tempArray = [NSMutableArray array];
                    NSArray* entries = [dictFromXml objectForKey:@"entry"];
                    
                    for (NSDictionary* dict in entries) {
                        NSLog(@"%@",dict);
                        Anime* anime;
                        if ([dict isKindOfClass:[NSString class]]) {
                            anime = [[Anime alloc] initWithDictionary:dictFromXml[@"entry"]];
                        } else {
                            anime = [[Anime alloc]initWithDictionary:dict];
                        }
                        if (anime.series_title && anime.series_animedb_id) {
                            [tempArray addObject:anime];
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _filteredResults = tempArray;
                        [self.searchDisplayController.searchResultsTableView reloadData];
                    });
                }
            }
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    [dataTask resume];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self getContentForSearchText:searchString
                            scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                   objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return NO;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DetailFromSearch"]) {
        // Get the new view controller using [segue destinationViewController].
        DetailViewController* detailVC = [segue destinationViewController];
        // Pass the selected object to the new view controller.
        detailVC.anime = _selected;
    }
}

@end
