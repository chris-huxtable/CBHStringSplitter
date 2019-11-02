//  CBHStringSplitterTests.h
//  CBHStringSplitterTests
//
//  Created by Christian Huxtable <chris@huxtable.ca>, June 2019.
//  Copyright (c) 2019 Christian Huxtable. All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
//  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
//  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

#import <XCTest/XCTest.h>

@import CBHStringSplitter;


@interface CBHStringSplitterTests : XCTestCase
@end


@implementation CBHStringSplitterTests


#pragma mark Setup

static NSString *kSampleName = @"CBHStringSplitterTests";


static NSString *kBasicString = @"a\nb\nc\nd\ne";
static NSArray<NSString *> *kBasicReference = nil;
static NSCharacterSet *kBasicCharacterSet = nil;

+ (void)initialize
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		kBasicReference = @[@"a", @"b", @"c", @"d", @"e"];
		kBasicCharacterSet = [NSCharacterSet newlineCharacterSet];
	});
}


#pragma mark Initialization

- (void)testInitialization_string
{
	CBHStringSplitter *splitter = [CBHStringSplitter splitterWithString:kBasicString andSeparators:kBasicCharacterSet];

	NSArray *array = [splitter allObjects];
	XCTAssertEqualObjects(array, kBasicReference, @"Enumeration results should match reference");
}

- (void)testInitialization_data
{
	NSStringEncoding encoding = NSUTF8StringEncoding;
	NSData *data = [kBasicString dataUsingEncoding:encoding];
	CBHStringSplitter *splitter = [CBHStringSplitter splitterWithData:data encoding:encoding andSeparators:kBasicCharacterSet];

	NSArray *array = [splitter allObjects];
	XCTAssertEqualObjects(array, kBasicReference, @"Enumeration results should match reference");
}

- (void)testInitialization_path
{
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:kSampleName ofType:@"sample"];

	CBHStringSplitter *splitter = [CBHStringSplitter splitterWithFileAtPath:path andSeparators:kBasicCharacterSet];
	NSArray *array = [splitter allObjects];
	XCTAssertEqualObjects(array, kBasicReference, @"Enumeration results should match reference");

	splitter = [CBHStringSplitter splitterWithFileAtPath:path encoding:NSUTF8StringEncoding andSeparators:kBasicCharacterSet];
	array = [splitter allObjects];
	XCTAssertEqualObjects(array, kBasicReference, @"Enumeration results should match reference");
}

- (void)testInitialization_url
{
	NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:kSampleName withExtension:@"sample"];

	CBHStringSplitter *splitter = [CBHStringSplitter splitterWithURL:url andSeparators:kBasicCharacterSet];
	NSArray *array = [splitter allObjects];
	XCTAssertEqualObjects(array, kBasicReference, @"Enumeration results should match reference");

	splitter = [CBHStringSplitter splitterWithURL:url encoding:NSUTF8StringEncoding andSeparators:kBasicCharacterSet];
	array = [splitter allObjects];
	XCTAssertEqualObjects(array, kBasicReference, @"Enumeration results should match reference");
}

- (void)testInitialization_stream
{
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"CBHStringSplitterTests" ofType:@"sample"];

	NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:path];
	CBHStringSplitter *splitter = [CBHStringSplitter splitterWithInputStream:stream andSeparators:kBasicCharacterSet];
	NSArray *array = [splitter allObjects];
	XCTAssertEqualObjects(array, kBasicReference, @"Enumeration results should match reference");

	stream = [NSInputStream inputStreamWithFileAtPath:path];
	splitter = [CBHStringSplitter splitterWithInputStream:stream andSeparators:kBasicCharacterSet];
	array = [splitter allObjects];
	XCTAssertEqualObjects(array, kBasicReference, @"Enumeration results should match reference");

	stream = [NSInputStream inputStreamWithFileAtPath:path];
	splitter = [CBHStringSplitter splitterWithInputStream:stream encoding:NSUTF8StringEncoding andSeparators:kBasicCharacterSet];
	array = [splitter allObjects];
	XCTAssertEqualObjects(array, kBasicReference, @"Enumeration results should match reference");
}


#pragma mark Encoding

- (void)testEncoding_utf8
{
	NSStringEncoding encoding = NSUTF8StringEncoding;

	NSData *data = [kBasicString dataUsingEncoding:encoding];
	CBHStringSplitter *splitter = [CBHStringSplitter splitterWithData:data encoding:encoding andSeparators:kBasicCharacterSet];

	NSArray *array = [splitter allObjects];
	XCTAssertEqualObjects(array, kBasicReference, @"Enumeration results should match reference");
}

- (void)testEncoding_utf16
{
	NSStringEncoding encoding = NSUTF16StringEncoding;

	NSData *data = [kBasicString dataUsingEncoding:encoding];
	CBHStringSplitter *splitter = [CBHStringSplitter splitterWithData:data encoding:encoding andSeparators:kBasicCharacterSet];

	NSArray *array = [splitter allObjects];
	XCTAssertEqualObjects(array, kBasicReference, @"Enumeration results should match reference");
}

- (void)testEncoding_utf32
{
	NSStringEncoding encoding = NSUTF32StringEncoding;

	NSData *data = [kBasicString dataUsingEncoding:encoding];
	CBHStringSplitter *splitter = [CBHStringSplitter splitterWithData:data encoding:encoding andSeparators:kBasicCharacterSet];

	NSArray *array = [splitter allObjects];
	XCTAssertEqualObjects(array, kBasicReference, @"Enumeration results should match reference");
}


#pragma mark Iterators

- (void)testBasic_next
{
	CBHStringSplitter *splitter = [CBHStringSplitter splitterWithString:@"a\nb\nc\nd\ne" andSeparators:kBasicCharacterSet];

	NSMutableArray *array = [NSMutableArray array];
	NSString *line;

	while ( (line = [splitter nextObject]) )
	{
		[array addObject:line];
	}

	XCTAssertEqualObjects(array, kBasicReference, @"Enumeration results should match reference");
}

- (void)testBasic_all
{
	CBHStringSplitter *splitter = [CBHStringSplitter splitterWithString:@"a\nb\nc\nd\ne" andSeparators:kBasicCharacterSet];

	NSArray *array = [splitter allObjects];

	XCTAssertEqualObjects(array, kBasicReference, @"Enumeration results should match reference");
}

- (void)testBasic_fast
{
	CBHStringSplitter *splitter = [CBHStringSplitter splitterWithString:@"a\nb\nc\nd\ne" andSeparators:kBasicCharacterSet];

	NSMutableArray *array = [NSMutableArray array];
	for (NSString *line in splitter)
	{
		[array addObject:line];
	}

	XCTAssertEqualObjects(array, kBasicReference, @"Enumeration results should match reference");
}


#pragma mark Edge Cases

- (void)testEdge_emptyString
{
	CBHStringSplitter *splitter = [CBHStringSplitter splitterWithString:@"" andSeparators:kBasicCharacterSet];
	XCTAssertNil([splitter nextObject], @"Enumeration results should not be nil");
}

- (void)testEdge_nextAtEnd
{
	CBHStringSplitter *splitter = [CBHStringSplitter splitterWithString:kBasicString andSeparators:kBasicCharacterSet];

	NSArray *array = [splitter allObjects];
	XCTAssertEqualObjects(array, kBasicReference, @"Enumeration results should match reference");

	XCTAssertNil([splitter nextObject], @"Next should be nil");
}

- (void)testEdge_enumerationInterruptionSmall
{
	CBHStringSplitter *splitter = [CBHStringSplitter splitterWithString:kBasicString andSeparators:kBasicCharacterSet];

	XCTAssertEqualObjects([splitter nextObject], kBasicReference[0], @"Enumeration results should match reference");
	XCTAssertEqualObjects([splitter nextObject], kBasicReference[1], @"Enumeration results should match reference");

	splitter = nil;
}

- (void)testEdge_enumerationInterruptionLarge
{
	CBHStringSplitter *splitter = [CBHStringSplitter splitterWithFileAtPath:@"/usr/share/dict/words" andSeparators:kBasicCharacterSet];

	XCTAssertNotNil([splitter nextObject], @"Enumeration results should not be nil");
	XCTAssertNotNil([splitter nextObject], @"Enumeration results should not be nil");

	splitter = nil;
}


#pragma mark Correctness

- (void)testCorrectness_withTrailingNewline
{
	NSString *string = @"a\nb\nc\nd\ne";
	CBHStringSplitter *splitter = [CBHStringSplitter splitterWithString:string andSeparators:kBasicCharacterSet];

	NSArray *array = [splitter allObjects];
	XCTAssertEqualObjects(array, kBasicReference, @"Enumeration results should match reference");
}

- (void)testCorrectness_missingTrailingNewline
{
	NSString *string = @"a\nb\nc\nd\ne\n";
	CBHStringSplitter *splitter = [CBHStringSplitter splitterWithString:string andSeparators:kBasicCharacterSet];

	NSArray *array = [splitter allObjects];
	XCTAssertEqualObjects(array, kBasicReference, @"Enumeration results should match reference");
}


#pragma mark Performance

- (void)testPerformance_next
{
	[self measureBlock:^{
		CBHStringSplitter *splitter = [CBHStringSplitter splitterWithFileAtPath:@"/usr/share/dict/words" andSeparators:kBasicCharacterSet];

		NSMutableArray *array = [NSMutableArray array];
		NSString *line;

		while ( (line = [splitter nextObject]) )
		{
			[array addObject:line];
		}
		XCTAssertEqual([array count], 235886);
	}];
}

- (void)testPerformance_all
{
	[self measureBlock:^{
		CBHStringSplitter *splitter = [CBHStringSplitter splitterWithFileAtPath:@"/usr/share/dict/words" andSeparators:kBasicCharacterSet];

		NSArray *array = [splitter allObjects];
		XCTAssertEqual([array count], 235886);
	}];
}

- (void)testPerformance_fast
{
	[self measureBlock:^{
		CBHStringSplitter *splitter = [CBHStringSplitter splitterWithFileAtPath:@"/usr/share/dict/words" andSeparators:kBasicCharacterSet];
		NSMutableArray *array = [NSMutableArray array];

		for (NSString *line in splitter)
		{
			[array addObject:line];
		}

		XCTAssertEqual([array count], 235886);
	}];
}

- (void)testPerformance_normal
{
	[self measureBlock:^{
		NSString *string = [NSString stringWithContentsOfFile:@"/usr/share/dict/words" encoding:NSUTF8StringEncoding error:nil];
		NSArray *array = [string componentsSeparatedByCharactersInSet:kBasicCharacterSet];

		XCTAssertEqual([array count], 235887);
	}];
}

@end
