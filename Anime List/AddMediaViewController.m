//
//  AddMediaViewController.m
//  Anime List
//
//  Created by Aaron Sky on 4/18/14.
//  Copyright (c) 2014 Aaron Sky. All rights reserved.
//

#import "AddMediaViewController.h"

@interface AddMediaViewController ()

@end

@implementation AddMediaViewController {
    NSIndexPath* _selectedPath;
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"mm/dd/yy"];
    
    _statusSelectionLabel.text = [NSString stringWithFormat:@"%d",_anime.my_status];
    _scoreSelectionLabel.text = [NSString stringWithFormat:@"%d/10",_anime.my_score];
    _watchedSelectionLabel.text = [NSString stringWithFormat:@"%d",_anime.my_watched_episodes];
    _startDateSelectionLabel.text = [dateFormat stringFromDate:_anime.my_start_date];
    _endDateSelectionLabel.text  = [dateFormat stringFromDate:_anime.my_finish_date];
    _rewatchedSelectionLabel.text = [NSString stringWithFormat:@"%d",_anime.my_rewatching_ep];
    
    _episodeStepper.maximumValue = _downloadedStepper.maximumValue = _rewatchedStepper.maximumValue = _anime.series_episodes;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/


- (IBAction)doneEditing:(id)sender {
//    
//    NSMutableString* addString = [NSMutableString string];
//    [addString appendString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><entry>"];
//    [addString appendString:[NSString stringWithFormat:@"<episode>%@</episode>",@"11"]];
//    [addString appendString:[NSString stringWithFormat:@"<status>%@</status>",@""]];
//    [addString appendString:[NSString stringWithFormat:@"<score>%@</score>",@""]];
//    [addString appendString:[NSString stringWithFormat:@"<downloaded_episodes>%@</downloaded_episodes>",@""]];
//    [addString appendString:[NSString stringWithFormat:@"<storage_type>%@</storage_type>",@""]];
//    [addString appendString:[NSString stringWithFormat:@"<storage_value>%@</storage_value>",@""]];
//    [addString appendString:[NSString stringWithFormat:@"<times_rewatched>%@</times_rewatched>",@""]];
//    [addString appendString:[NSString stringWithFormat:@"<rewatch_value>%@</rewatch_value>",@""]];
//    [addString appendString:[NSString stringWithFormat:@"<date_start>%@</date_start>",[[[NSDateFormatter alloc]init] stringFromDate:_anime.my_start_date]]];
//    [addString appendString:[NSString stringWithFormat:@"<date_finish>%@</date_finish>",[[[NSDateFormatter alloc]init] stringFromDate:_anime.my_finish_date]]];
//    [addString appendString:[NSString stringWithFormat:@"<priority>%@</priority>",@""]];
//    [addString appendString:[NSString stringWithFormat:@"<enable_discussion>%@</enable_discussion>",@""]];
//    [addString appendString:[NSString stringWithFormat:@"<enable_rewatching>%@</enable_rewatching>",@""]];
//    [addString appendString:[NSString stringWithFormat:@"<comments>%@</comments>",@""]];
//    [addString appendString:[NSString stringWithFormat:@"<fansub_group>%@</fansub_group>",@""]];
//    [addString appendString:[NSString stringWithFormat:@"<tags>%@</tags>",@""]];
//    [addString appendString:@"</entry>"];
//    
//    NSLog(@"%@",addString);
//    
//    [self.navigationController popViewControllerAnimated:YES];
}

/*
-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedPath) {
        [tableView deleteRowsAtIndexPaths:@[_selectedPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        _selectedPath = nil;
    }
    _selectedPath = [NSIndexPath indexPathForRow:[indexPath row] + 1 inSection:[indexPath section]];
    [tableView insertRowsAtIndexPaths:@[_selectedPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView reloadData];
}
 */

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

- (IBAction)scoreChanged:(UIStepper *)sender {
    _scoreSelectionLabel.text = [NSString stringWithFormat:@"%f/10",sender.value];
}

- (IBAction)watchedChanged:(UIStepper*)sender {
    _watchedSelectionLabel.text = [NSString stringWithFormat:@"%f/%d",sender.value,_anime.series_episodes];
}

- (IBAction)downloadedChanged:(UIStepper*)sender {
    _downloadedSelectionLabel.text = [NSString stringWithFormat:@"%f/%d",sender.value,_anime.series_episodes];
}

- (IBAction)rewatchedChanged:(UIStepper*)sender {
    _rewatchedSelectionLabel.text = [NSString stringWithFormat:@"%f/%d",sender.value,_anime.series_episodes];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
