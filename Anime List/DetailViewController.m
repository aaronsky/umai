//
//  DetailViewController.m
//  Anime List
//
//  Created by Aaron Sky on 4/18/14.
//  Copyright (c) 2014 Aaron Sky. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController {
    NSURLSession* _session;
    XMLDictionaryParser* _parser;
    URBMediaFocusViewController* _mediaController;
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
    _parser = [[XMLDictionaryParser alloc]init];
    _mediaController = [[URBMediaFocusViewController alloc]init];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"mm/dd/yy"];
    
    _animeName.text = _anime.series_title;
    _epCountLabel.text = [NSString stringWithFormat:@"%d episodes",_anime.series_episodes];
    _runDateLabel.text = [NSString stringWithFormat:@"%@ - %@", [dateFormat stringFromDate:_anime.series_start], [dateFormat stringFromDate:_anime.series_end]];
    _synopsisLabel.editable = NO; // don't allow editing text
    [self getSynopsisForTitle:_anime.series_title];
    switch (_anime.my_status) {
        case kCompleted:
            _watchStatusLabel.text = @"You finished this anime!";
            _watchStatusLabel.backgroundColor = [UIColor colorWithRed:0.25 green:0.5 blue:0.25 alpha:1.0 /*greenColor*/];
            break;
        case kOnHold:
            _watchStatusLabel.text = @"You put this anime on hold";
            _watchStatusLabel.backgroundColor = [UIColor colorWithRed:0.75 green:0.0 blue:0.0 alpha:1.0 /*redColor*/];
            break;
        case kDropped:
            _watchStatusLabel.text = @"You dropped this anime";
            _watchStatusLabel.backgroundColor = [UIColor colorWithRed:0.75 green:0.0 blue:0.75 alpha:1.0 /*purpleColor*/];
            break;
        case kWatching:
            _watchStatusLabel.text = @"You are currently watching this anime";
            _watchStatusLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.75 alpha:1.0 /*blueColor*/];
            break;
        case kPlanToWatch:
            _watchStatusLabel.text = @"You plan to watch this anime.";
            _watchStatusLabel.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0 /*grayColor*/];
            break;
        default:
            [UIView animateWithDuration:0.1f animations:^{
                _watchStatusLabel.frame = CGRectMake(_watchStatusLabel.frame.origin.x, _watchStatusLabel.frame.origin.x, _watchStatusLabel.frame.size.width, 0.0f);
            } completion:^(BOOL finished) {
                _watchStatusLabel.hidden = YES;
            }];
            break;
    }
    if (_anime.series_image) {
        _animeImageView.image = _anime.series_image;
    } else {
        _animeImageView.userInteractionEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getSynopsisForTitle:(NSString*)title
{
    __block NSString* synopsis = @"no synopsis was found";
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
    searchString.query = [NSString stringWithFormat:@"q=%@",title];
    NSURL* url = [searchString URL];
    
    NSURLSessionDataTask* dataTask = [_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            NSHTTPURLResponse* httpResp = (NSHTTPURLResponse*)response;
            
            if (httpResp.statusCode == 200) {
                NSDictionary* dictFromXml = [_parser dictionaryWithData:data];
                
                if (dictFromXml) {
                    NSLog(@"%@",dictFromXml);
                    
                    NSArray* entries = [dictFromXml objectForKey:@"entry"];
                    
                    for (NSDictionary* dict in entries) {
                        if ([dict isKindOfClass:[NSString class]]) {
                            if (dictFromXml[@"entry"][@"id"]) {
                                if ([dictFromXml[@"entry"][@"id"] intValue] == _anime.series_animedb_id) {
                                    synopsis = dictFromXml[@"entry"][@"synopsis"] ? dictFromXml[@"entry"][@"synopsis"] : synopsis;
                                        break;
                                }
                            }
                        } else {
                            NSLog(@"%@",dict);
                            if ([dict objectForKey:@"id"]) {
                                if ([[dict objectForKey:@"id"] intValue] == _anime.series_animedb_id) {
                                    synopsis = [dict objectForKey:@"synopsis"] ? [dict objectForKey:@"synopsis"] : synopsis;
                                        break;
                                }
                            }
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([synopsis isKindOfClass:[NSDictionary class]]) {
                            synopsis = @"No synopsis was found";
                        } else {
                            
                            synopsis = [self cleanUpText:[NSString stringWithFormat:@"%@",synopsis]];
                        }
                        _synopsisLabel.text = synopsis;
                        NSLog(@"i tried");
                    });
                }
            }
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    [dataTask resume];
}

-(NSString*)cleanUpText:(NSString*)original
{
    NSString* modified = [original stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    modified = [modified stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    modified = [modified stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    modified = [modified stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
    return modified;
    
    //return [[NSString alloc]initWithData:[original dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] encoding:NSASCIIStringEncoding];
}

- (IBAction)tappedImage:(UITapGestureRecognizer *)sender {
    [_mediaController showImage:_anime.series_image fromRect:self.animeImageView.frame];
}


 #pragma mark - Navigation

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"UpdateFromDetail"]) {
        [[[UIAlertView alloc] initWithTitle:@"Incomplete Feature" message:@"Adding/Updating currently unsupported in prototype build" delegate:self cancelButtonTitle:@"sry" otherButtonTitles:nil] show];
        return NO;
    }
    return YES;
}

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([[segue identifier]  isEqualToString:@"UpdateFromDetail"]) {
         AddMediaViewController* addVC = [segue destinationViewController];
         addVC.anime = _anime;
     }
 }

@end
