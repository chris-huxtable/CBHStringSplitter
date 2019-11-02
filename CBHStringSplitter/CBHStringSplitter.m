//  CBHStringSplitter.m
//  CBHStringSplitter
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

#import "CBHStringSplitter.h"


NS_ASSUME_NONNULL_BEGIN

@interface CBHStringSplitter ()
{
	NSInputStream * __nullable _stream;

	NSCharacterSet *_separators;

	NSMutableArray<NSString *> * __nullable _buffer;
	NSString * __nullable _leftOvers;
	NSUInteger _bufferSize;

	BOOL _isFinishedBuffering;
	BOOL _isFinished;
}

#pragma mark Private Utilities

- (nullable NSString *)popBuffer;

- (BOOL)buffer;
- (void)processChunk:(uint8_t *)chunk ofLength:(NSInteger)length;

- (void)finish;
- (void)finishBuffering;

@end

NS_ASSUME_NONNULL_END


@implementation CBHStringSplitter


#pragma mark Factories

+ (instancetype)splitterWithString:(NSString *)string andSeparators:(NSCharacterSet *)separators
{
	return [[self alloc] initWithString:string andSeparators:separators];
}


+ (instancetype)splitterWithData:(NSData *)data encoding:(NSStringEncoding)encoding andSeparators:(NSCharacterSet *)separators
{
	return [[self alloc] initWithData:data encoding:encoding andSeparators:separators];
}


+ (instancetype)splitterWithFileAtPath:(NSString *)path andSeparators:(NSCharacterSet *)separators
{
	return [[self alloc] initWithFileAtPath:path encoding:NSUTF8StringEncoding andSeparators:separators];
}

+ (instancetype)splitterWithFileAtPath:(NSString *)path encoding:(NSStringEncoding)encoding andSeparators:(NSCharacterSet *)separators
{
	return [[self alloc] initWithFileAtPath:path encoding:encoding andSeparators:separators];
}


+ (instancetype)splitterWithURL:(NSURL *)url andSeparators:(NSCharacterSet *)separators
{
	return [[self alloc] initWithURL:url encoding:NSUTF8StringEncoding andSeparators:separators];
}

+ (instancetype)splitterWithURL:(NSURL *)url encoding:(NSStringEncoding)encoding andSeparators:(NSCharacterSet *)separators
{
	return [[self alloc] initWithURL:url encoding:encoding andSeparators:separators];
}


+ (instancetype)splitterWithInputStream:(NSInputStream *)stream andSeparators:(NSCharacterSet *)separators
{
	return [[self alloc] initWithInputStream:stream encoding:NSUTF8StringEncoding andSeparators:separators];
}

+ (instancetype)splitterWithInputStream:(NSInputStream *)stream encoding:(NSStringEncoding)encoding andSeparators:(NSCharacterSet *)separators
{
	return [[self alloc] initWithInputStream:stream encoding:encoding andSeparators:separators];
}


#pragma mark Initializers

- (instancetype)initWithString:(NSString *)string andSeparators:(NSCharacterSet *)separators
{
	NSStringEncoding encoding = [string fastestEncoding];
	return [self initWithData:[string dataUsingEncoding:encoding] encoding:encoding andSeparators:separators];
}

- (instancetype)initWithData:(NSData *)data encoding:(NSStringEncoding)encoding andSeparators:(NSCharacterSet *)separators
{
	return [self initWithInputStream:[NSInputStream inputStreamWithData:data] encoding:encoding andSeparators:separators];
}

- (instancetype)initWithFileAtPath:(NSString *)path encoding:(NSStringEncoding)encoding andSeparators:(NSCharacterSet *)separators
{
	return [self initWithInputStream:[NSInputStream inputStreamWithFileAtPath:path] encoding:encoding andSeparators:separators];
}

- (instancetype)initWithURL:(NSURL *)url encoding:(NSStringEncoding)encoding andSeparators:(NSCharacterSet *)separators
{
	return [self initWithInputStream:[NSInputStream inputStreamWithURL:url] encoding:encoding andSeparators:separators];
}

- (instancetype)initWithInputStream:(NSInputStream *)stream encoding:(NSStringEncoding)encoding andSeparators:(NSCharacterSet *)separators
{
	if ( (self = [super init]) )
	{
		_stream = stream;
		[_stream open];

		_bufferSize = 1024;
		_encoding = encoding;

		_separators = separators;

		_buffer = [[NSMutableArray alloc] init];
		_leftOvers = nil;

		_isFinished = false;
	}

	return self;
}


#pragma mark Destructor

- (void)dealloc
{
	if ( _stream ) { [_stream close]; }
}


#pragma mark Enumerator Overrides

- (NSArray<NSString *> *)allObjects
{
	NSMutableArray<NSString *> *objects = [NSMutableArray array];

	while ( [self buffer] )
	{
		[objects addObjectsFromArray:_buffer];
		[_buffer removeAllObjects];
	}

	return objects;
}

- (nullable NSString *)nextObject
{
	if ( _isFinished ) { return nil; }
	if ( [_buffer count] <= 1 ) { [self buffer]; }

	if ( [_buffer count] <= 0 )
	{
		[self finish];
		return nil;
	}

	return [self popBuffer];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)length
{
	if ( _isFinished ) { return 0; }

	if ( state->state == 0 ) { ++(state->state); }
	state->mutationsPtr = &state->extra[1];
	state->itemsPtr = buffer;

	NSUInteger i = 0;
	while ( i < length )
	{
		id object = [self nextObject];
		if ( !object ) { break; }

		buffer[i] = object;
		++i;
	}

	return i;
}


#pragma mark Properties

@synthesize separators = _separators;

@synthesize bufferSize = _bufferSize;
@synthesize encoding = _encoding;

@synthesize isFinishedBuffering = _isFinishedBuffering;
@synthesize isFinished = _isFinished;


#pragma mark Private Utilities

- (nullable NSString *)popBuffer
{
	if ( [_buffer count] <= 0 ) { return nil; }

	NSString *tmp = [_buffer objectAtIndex:0];
	[_buffer removeObjectAtIndex:0];

	return tmp;
}

- (BOOL)buffer
{
	/// Ensure nullables and bytes available.
	if ( _isFinishedBuffering || _isFinished ) { return NO; }
	if ( !_stream || !_buffer ) { [self finishBuffering]; return NO; }

	/// Buffer if able. The while loop allows for lines longer than the chunk size.
	while ( [_buffer count] <= 1 && [_stream hasBytesAvailable] )
	{
		/// Read the stream.
		uint8_t chunk[_bufferSize];
		NSInteger length = [_stream read:chunk maxLength:_bufferSize];

		/// Finish if the buffer is empty or errors.
		if ( length <= 0 ) { [self finishBuffering]; return YES; }
		[self processChunk:chunk ofLength:length];
	}

	/// Finished buffering if necessary
	if ( ![_stream hasBytesAvailable] ) { [self finishBuffering]; }

	return YES;
}

- (void)processChunk:(uint8_t *)chunk ofLength:(NSInteger)length
{
	/// Buffer data (Memory not copied, and not freed. its on the stack and used completely before next loop)
	NSString *string = [[NSString alloc] initWithBytesNoCopy:chunk length:(NSUInteger)length encoding:_encoding freeWhenDone:NO];
	if ( length <= 0 ) { return; }

	/// Use the leftovers if there are any.
	if ( _leftOvers )
	{
		string = [_leftOvers stringByAppendingString:string];
		_leftOvers = nil;
	}
	
	NSScanner *scanner = [NSScanner scannerWithString:string];
	NSString *found = nil;

	while ( [scanner scanUpToCharactersFromSet:_separators intoString:&found] )
	{
		/// Buffer what is found if not at end.
		if ( ![scanner isAtEnd] ) { [_buffer addObject:found]; continue; }

		unichar tail = [string characterAtIndex:[string length] - 1];
		if ( [_separators characterIsMember:tail] )
		{
			_leftOvers = [found stringByAppendingFormat:@"%c", tail];
		}
		else
		{
			_leftOvers = found;
		}
	}
}

- (void)finish
{
	if ( _isFinished ) { return; }
	_isFinished = true;

	/// Free the buffer and stream as they no longer necessary.
	if ( _buffer ) { _buffer = nil; }

	if ( _stream )
	{
		[_stream close];
		_stream = nil;
	}
}

- (void)finishBuffering
{
	_isFinishedBuffering = true;

	/// Add leftovers to buffer and close stream if at end.
	if ( _leftOvers )
	{
		/// Strip trailing separators and add to buffer.
		[_buffer addObject:[_leftOvers stringByTrimmingCharactersInSet:_separators]];
		_leftOvers = nil;
	}
}

@end
