//
//  FeedViewController.m
//  ClickPic
//
//  Created by Jon on 11/16/14.
//  Copyright (c) 2014 ClickPic. All rights reserved.
//

#import "FeedViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "FeedCell.h"
@import CoreLocation;

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (nonatomic, strong) NSArray *content;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    NSDictionary *coords = @{@"lat" : [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude],
                             @"long" : [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude]};

    [self.locationManager stopUpdatingLocation];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"" parameters:coords success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.content = responseObject;
        [self.feedTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)upvote:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.feedTableView];
    NSIndexPath *indexPath = [self.feedTableView indexPathForRowAtPoint:buttonPosition];
    NSDictionary *data = @{@"id" : [[self.content objectAtIndex:indexPath.row] objectForKey:@"id"]};
    
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    [operationManager setSecurityPolicy:policy];
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer = [AFJSONResponseSerializer serializer];

    [operationManager POST:@"" parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        FeedCell *cell = (FeedCell *)[self.feedTableView cellForRowAtIndexPath:indexPath];
        NSInteger num = [cell.votes.text integerValue] + 1;
        [cell.votes setText:[NSString stringWithFormat:@"%i", num]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (IBAction)addPic:(id)sender {
    
}

- (IBAction)downvote:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.feedTableView];
    NSIndexPath *indexPath = [self.feedTableView indexPathForRowAtPoint:buttonPosition];
    NSDictionary *data = @{@"id" : [[self.content objectAtIndex:indexPath.row] objectForKey:@"id"]};
    
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    [operationManager setSecurityPolicy:policy];
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operationManager POST:@"" parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        FeedCell *cell = (FeedCell *)[self.feedTableView cellForRowAtIndexPath:indexPath];
        NSInteger num = [cell.votes.text integerValue] - 1;
        [cell.votes setText:[NSString stringWithFormat:@"%i", num]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedcell"];
    
    if (cell == nil) {
        cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"feedcell"];
    }
    
    [cell.imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[[self.content objectAtIndex:indexPath.row] objectForKey:@"picture"]]]];
    [cell.caption setText:[[self.content objectAtIndex:indexPath.row] objectForKey:@"caption"]];
    [cell.votes setText:[[self.content objectAtIndex:indexPath.row] objectForKey:@"net"]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.content count];
}

@end
