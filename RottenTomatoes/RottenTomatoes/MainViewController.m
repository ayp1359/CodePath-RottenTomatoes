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

@property (strong,nonatomic) NSArray *movies;

@end

@implementation MainViewController

@synthesize isFiltered;

- (void)viewDidLoad {
  [super viewDidLoad];

  self.moviesSearchBar.delegate = self;
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.moviesTableView.rowHeight = 150;
  self.moviesTableView.delegate = self;
  self.moviesTableView.dataSource = self;
  self.moviesTableView.backgroundColor = [UIColor blackColor];
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
  
  if(searchText.length == 0)
  {
    isFiltered = FALSE;
  }
  else
  {
    isFiltered = true;
    self.filteredTableData = [[NSMutableArray alloc] init];
    
    for (NSDictionary *movie in self.movies)
    {
      NSString *movieTitle =movie[@"title"];
      NSString *movieSynopsis =movie[@"synopsis"];
      NSRange nameRange = [movieTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
      NSRange descriptionRange = [movieSynopsis rangeOfString:searchText options:NSCaseInsensitiveSearch];
      if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
      {
        [self.filteredTableData addObject:movie];
      }
    }
  }
  
  [self.moviesTableView reloadData];
  
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
  NSInteger rowCount;
  if(self.isFiltered)
    rowCount = self.filteredTableData.count;
  else
    rowCount = self.movies.count;
  return rowCount;
  
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
  NSDictionary *movie = [[NSDictionary alloc] init];
  if(isFiltered){
    movie = [self.filteredTableData objectAtIndex:indexPath.row];
  }
  else{
     movie = [self.movies objectAtIndex:indexPath.row];
  }
  
  //movie = self.movies[indexPath.row];
  NSDictionary *poster = movie[@"posters"];
  NSString *posterURL = poster[@"detailed"];
  //posterURL = [posterURL stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
  cell.movieTitleLabel.text = movie[@"title"];
  cell.movieSynopsisLabel.text = movie[@"synopsis"];
  [cell.moviePosterImage setImageWithURL:[NSURL URLWithString:posterURL]];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
  [self.moviesSearchBar resignFirstResponder];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  MovieDetail *movieDetail = [[MovieDetail alloc]init];
  
  NSDictionary *movie = [[NSDictionary alloc] init];
  if(isFiltered){
    movie = [self.filteredTableData objectAtIndex:indexPath.row];
  }
  else{
    movie = [self.movies objectAtIndex:indexPath.row];
  }

  //NSDictionary *movie = self.movies[indexPath.row];
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
