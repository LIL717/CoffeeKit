//
//  VerifyClass.m
//  CoffeeKit
//
//  Created by Lori Hill on 5/12/15.
//  Copyright (c) 2015 Lori Hill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>
#import "Venue.h"

@interface VerifyClass : XCTestCase

@end

@implementation VerifyClass

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
	// Configure RKTestFixture
	NSBundle *testTargetBundle = [NSBundle bundleWithIdentifier:@"com.Frostbite-Learning.CoffeeKitTests"];
	[RKTestFixture setFixtureBundle:testTargetBundle];
}

- (RKObjectMapping *)nameMapping
{
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Venue class]];
	[mapping addAttributeMappingsFromDictionary:@{
												  @"venues.name":   @"name",
												  @"venues.location.distance":  @"location.distance",
												  @"venues.stats.checkins":    @"stats.checkins"
												  }];

	return mapping;
}

- (void)testMappingOfName
{
	id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"venues.json"];
	RKMappingTest *test = [RKMappingTest testForMapping:[self nameMapping] sourceObject:parsedJSON destinationObject:nil];
	[test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"venues.name" destinationKeyPath:@"name"]];
	XCTAssertTrue([test evaluate], @"The name has not been set up!");
		// or
	XCTAssertNoThrow([test verify], @"The name has not been set up!");
}

- (void)testMappingOfDistance
{
	id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"venues.json"];
	RKMappingTest *test = [RKMappingTest testForMapping:[self nameMapping] sourceObject:parsedJSON destinationObject:nil];
	[test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"venues.location.distance" destinationKeyPath:@"location.distance"]];
	XCTAssertTrue([test evaluate], @"The distance has not been set up!");
		// or
	XCTAssertNoThrow([test verify], @"The distance has not been set up!");
}
- (void)testMappingOfCheckins
{
	id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"venues.json"];
	RKMappingTest *test = [RKMappingTest testForMapping:[self nameMapping] sourceObject:parsedJSON destinationObject:nil];
	[test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"venues.stats.checkins" destinationKeyPath:@"stats.checkins"]];
	XCTAssertTrue([test evaluate], @"Checkins has not been set up!");
		// or
	XCTAssertNoThrow([test verify], @"Checkins has not been set up!");
}
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
