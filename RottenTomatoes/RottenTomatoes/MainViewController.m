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
#import "MBProgressHUD.h"

@interface MainViewController ()<MBProgressHUDDelegate> {
  UIView *networkErrorView;
  UILabel *networkErrorLabel;
  MBProgressHUD *HUD;
  
  
}

@property (strong,nonatomic) NSArray *movies;
@property (strong,nonatomic) NSMutableData  *incomingData;
@property (strong,nonatomic) UIRefreshControl *refreshControl;

@end

@implementation MainViewController

@synthesize isFiltered;

- (void)viewDidLoad {
  [super viewDidLoad];
  UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
  [self.moviesTableView addGestureRecognizer:gestureRecognizer];
  gestureRecognizer.cancelsTouchesInView = NO;
  
  UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
  [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
  self.refreshControl = refreshControl;
  [self.moviesTableView addSubview:refreshControl];
  self.incomingData = [[NSMutableData alloc]init];
  self.moviesSearchBar.delegate = self;
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.moviesTableView.rowHeight = 150;
  self.moviesTableView.delegate = self;
  self.moviesTableView.dataSource = self;
  self.moviesTableView.backgroundColor = [UIColor blackColor];
  self.title = @"Movies";
  [self.moviesTableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
  self.APIurl = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=y6968ys33bjkmvw5jmf4jp84";
  [self loadRottenTomatoesMovies:self.APIurl];
}

- (void) hideKeyboard {
  if([self.moviesSearchBar isFirstResponder]){
    [self.view endEditing:YES];
  }
}

-(void)loadRottenTomatoesMovies:(NSString*)url{
  NSURLRequest  *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
  [connection start];
  HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
  HUD.labelText = @"Loading...";
  HUD.delegate = self;
}

-(void)refresh{
  [self loadRottenTomatoesMovies:self.APIurl];
  [self.refreshControl endRefreshing];
}

#pragma mark - NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  [self.incomingData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  self.incomingData = nil;
  [self handleConnectionError:error];
  [HUD hide:YES];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  [HUD hide:YES];
  if (self.incomingData){
    id object  = [NSJSONSerialization JSONObjectWithData:self.incomingData  options:0 error:nil];
    self.movies = object[@"movies"];
    [self.moviesTableView reloadData];
    // NSLog(@"%@",object);
  }
  self.incomingData = nil;
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
  movieDetail.title = movie[@"title"];
  movieDetail.movieSynopsisString = movie[@"synopsis"];
  
  [self.navigationController pushViewController:movieDetail animated:YES];
  self.navigationController.navigationBar.topItem.title = @"Movies";
  
}

- (void)handleConnectionError:(NSError *)error {
  
  NSError *underlyingError = [[error userInfo] objectForKey:NSUnderlyingErrorKey];
  
  networkErrorView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 320, 40)];
  networkErrorView.backgroundColor = [UIColor darkGrayColor];
  networkErrorView.alpha = 1;
  
  networkErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 300, 20)];
  networkErrorLabel.text = [underlyingError localizedDescription];
  [networkErrorLabel setTextColor:[UIColor whiteColor]];
  [networkErrorLabel setFont:[UIFont systemFontOfSize:12]];
  [networkErrorLabel setTextAlignment:NSTextAlignmentCenter];
  
  [networkErrorView addSubview:networkErrorLabel];
  [self.view addSubview:networkErrorView];
  
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
