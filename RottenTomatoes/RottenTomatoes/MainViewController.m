//
//  MainViewController.m
//  RottenTomatoes
//
//  Created by Ali YAZDAN PANAH on 10/16/14.
//  Copyright (c) 2014 Ali YAZDAN PANAH. All rights reserved.
//

#import "MainViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetail.h"


@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property (strong,nonatomic) NSArray *movies;

@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  
  self.moviesTableView.rowHeight = 150;
  self.moviesTableView.delegate = self;
  self.moviesTableView.dataSource = self;
  self.title = @"Box Office Movies";
  
  [self.moviesTableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
   
  
  NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=y6968ys33bjkmvw5jmf4jp84";
  NSURLRequest  *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
   {
     if (connectionError)
     {
       NSLog(@"ERROR CONNECTING DATA FROM SERVER: %@", connectionError.localizedDescription);
     }
     else{
       id object  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
       self.movies = object[@"movies"];
       [self.moviesTableView reloadData];
       NSLog(@"%@",object);
     }
     
   }];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.movies.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  
  MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
  NSDictionary *movie = self.movies[indexPath.row];
  NSDictionary *poster = movie[@"posters"];
  NSString *posterURL = poster[@"detailed"];
  posterURL = [posterURL stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
  cell.movieTitleLabel.text = movie[@"title"];
  cell.movieSynopsisLabel.text = movie[@"synopsis"];
  [cell.moviePosterImage setImageWithURL:[NSURL URLWithString:posterURL]];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  MovieDetail *movieDetail = [[MovieDetail alloc]init];
  NSDictionary *movie = self.movies[indexPath.row];
  NSString *posterURL = movie[@"posters"][@"detailed"];
  movieDetail.posterURL = [posterURL stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
  
  [self.navigationController pushViewController:movieDetail animated:YES];
  
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
