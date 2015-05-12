//
//  CoffeeViewController.m
//  CoffeeKit
//
//  Created by Lori Hill on 5/11/15.
//  Copyright (c) 2015 Lori Hill. All rights reserved.
//

#import "CoffeeViewController.h"
#import <RestKit/RestKit.h>
#import "Venue.h"
#import "Location.h"
#import "VenueCell.h"
#import "Stats.h"

#define kCLIENTID @"E0V1ROXTBSLEH4ZTIR3VBYSZNVNBRERZ2KTX2PZDKHYVOZFK"
#define kCLIENTSECRET @"0B3VZEM425O2XBV5IQHELKDGHISYM2IT2MZQJAHYJFANJOMX"

@interface CoffeeViewController ()

@property (nonatomic, strong) NSArray *venues;

@end

@implementation CoffeeViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
	[self configureRestKit];
	[self loadVenues];
}
- (UIStatusBarStyle) preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)configureRestKit
{
		// initialize AFNetworking HTTPClient
	NSURL *baseURL = [NSURL URLWithString:@"https://api.foursquare.com"];
	AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];

		// initialize RestKit
	RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];

		// setup object mappings
	RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[Venue class]];
	[venueMapping addAttributeMappingsFromArray:@[@"name"]];

		// register mappings with the provider using a response descriptor
	RKResponseDescriptor *responseDescriptor =
	[RKResponseDescriptor responseDescriptorWithMapping:venueMapping
												 method:RKRequestMethodGET
											pathPattern:@"/v2/venues/search"
												keyPath:@"response.venues"
											statusCodes:[NSIndexSet indexSetWithIndex:200]];

	[objectManager addResponseDescriptor:responseDescriptor];

		// define location object mapping
	RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
	[locationMapping addAttributeMappingsFromArray:@[@"address", @"city", @"country", @"crossStreet", @"postalCode", @"state", @"distance", @"lat", @"lng"]];

		// define relationship mapping
	[venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"location" toKeyPath:@"location" withMapping:locationMapping]];

	RKObjectMapping *statsMapping = [RKObjectMapping mappingForClass:[Stats class]];
	[statsMapping addAttributeMappingsFromDictionary:@{@"checkinsCount": @"checkins", @"tipsCount": @"tips", @"usersCount": @"users"}];

	[venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"stats" toKeyPath:@"stats" withMapping:statsMapping]];
}
- (void)loadVenues
{
	NSString *latLon = @"47.615363,-122.348278"; // approximate latLon of DatStat
	NSString *clientID = kCLIENTID;
	NSString *clientSecret = kCLIENTSECRET;

	NSDictionary *queryParams = @{@"ll" : latLon,
								  @"client_id" : clientID,
								  @"client_secret" : clientSecret,
								  @"categoryId" : @"4bf58dd8d48988d1e0931735",
								  @"v" : @"20140118"};

	[[RKObjectManager sharedManager] getObjectsAtPath:@"/v2/venues/search"
				   parameters:queryParams
					  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
						  NSArray *unsortedVenues = mappingResult.array;
						  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"location.distance.intValue" ascending:YES];
						  self.venues = [unsortedVenues sortedArrayUsingDescriptors:@[sort]];
						  [self.tableView reloadData];
					  }
					  failure:^(RKObjectRequestOperation *operation, NSError *error) {
						  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
					  }];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	VenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueCell" forIndexPath:indexPath];

	Venue *venue = _venues[indexPath.row];
	cell.nameLabel.text = venue.name;
	CGFloat distance = venue.location.distance.floatValue/ 1609.344;
	cell.distanceLabel.text = [NSString stringWithFormat:@"%.1fm", distance];
	cell.checkInLabel.text = [NSString stringWithFormat:@"%d checkins", venue.stats.checkins.intValue];

	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return NO;
}



@end
