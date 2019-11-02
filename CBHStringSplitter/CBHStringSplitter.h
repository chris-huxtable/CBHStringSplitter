//  CBHStringSplitter.h
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

@import Foundation;


FOUNDATION_EXPORT double CBHStringSplitterVersionNumber;
FOUNDATION_EXPORT const unsigned char CBHStringSplitterVersionString[];


NS_ASSUME_NONNULL_BEGIN

/** Enumerator of strings split from a given input
 *
 * @author    Christian Huxtable <chris@huxtable.ca>
 */
@interface CBHStringSplitter : NSEnumerator

#pragma mark - Factories

/** Creates a new `CBHStringSplitter` with a string using a set of separators.
 *
 * @param string       The string to split.
 * @param separators   The separators where the input should be split.
 *
 * @return             A newly created splitter.
 */
+ (instancetype)splitterWithString:(NSString *)string andSeparators:(NSCharacterSet *)separators;


/** Creates a new `CBHStringSplitter` with data using an encoding and a set of separators.
 *
 * @param data         The data to split.
 * @param encoding     The encoding to use in interpreting the data.
 * @param separators   The separators where the input should be split.
 *
 * @return             A newly created splitter.
 */
+ (instancetype)splitterWithData:(NSData *)data encoding:(NSStringEncoding)encoding andSeparators:(NSCharacterSet *)separators;


/** Creates a new `CBHStringSplitter` with data at a path using the UTF8 string encoding and a set of separators.
 *
 * @param path         The path where the data to split exists.
 * @param separators   The separators where the input should be split.
 *
 * @return             A newly created splitter.
 */
+ (instancetype)splitterWithFileAtPath:(NSString *)path andSeparators:(NSCharacterSet *)separators;

/** Creates a new `CBHStringSplitter` with data at a path using an encoding and a set of separators.
 *
 * @param path         The path where the data to split exists.
 * @param encoding     The encoding to use in interpreting the data.
 * @param separators   The separators where the input should be split.
 *
 * @return             A newly created splitter.
 */
+ (instancetype)splitterWithFileAtPath:(NSString *)path encoding:(NSStringEncoding)encoding andSeparators:(NSCharacterSet *)separators;


/** Creates a new `CBHStringSplitter` with data at a url using the UTF8 string encoding and a set of separators.
 *
 * @param url          The URL where the data to split exists.
 * @param separators   The separators where the input should be split.
 *
 * @return             A newly created splitter.
 */
+ (instancetype)splitterWithURL:(NSURL *)url andSeparators:(NSCharacterSet *)separators;

/** Creates a new `CBHStringSplitter` with data at a url using an encoding and a set of separators.
 *
 * @param url          The URL where the data to split exists.
 * @param encoding     The encoding to use in interpreting the data.
 * @param separators   The separators where the input should be split.
 *
 * @return             A newly created splitter.
 */
+ (instancetype)splitterWithURL:(NSURL *)url encoding:(NSStringEncoding)encoding andSeparators:(NSCharacterSet *)separators;


/** Creates a new `CBHStringSplitter` with data read from a stream using the UTF8 string encoding and a set of separators.
 *
 * @param stream       The stream to read the data from.
 * @param separators   The separators where the input should be split.
 *
 * @return             A newly created splitter.
 */
+ (instancetype)splitterWithInputStream:(NSInputStream *)stream andSeparators:(NSCharacterSet *)separators;

/** Creates a new `CBHStringSplitter` with data read from a stream using an encoding and a set of separators.
 *
 * @param stream       The stream to read the data from.
 * @param encoding     The encoding to use in interpreting the data.
 * @param separators   The separators where the input should be split.
 *
 * @return             A newly created splitter.
 */
+ (instancetype)splitterWithInputStream:(NSInputStream *)stream encoding:(NSStringEncoding)encoding andSeparators:(NSCharacterSet *)separators;


#pragma mark - Initializers

/** Initializes a `CBHStringSplitter` with a string using a set of separators.
 *
 * @param string       The string to split.
 * @param separators   The separators where the input should be split.
 *
 * @return             An initialized separator.
 */
- (instancetype)initWithString:(NSString *)string andSeparators:(NSCharacterSet *)separators;

/** Initializes a `CBHStringSplitter` with data using an encoding and a set of separators.
 *
 * @param data         The data to split.
 * @param encoding     The encoding to use in interpreting the data.
 * @param separators   The separators where the input should be split.
 *
 * @return             An initialized splitter.
 */
- (instancetype)initWithData:(NSData *)data encoding:(NSStringEncoding)encoding andSeparators:(NSCharacterSet *)separators;

/** Initializes a `CBHStringSplitter` with data at a path using an encoding and a set of separators.
 *
 * @param path         The path where the data to split exists.
 * @param encoding     The encoding to use in interpreting the data.
 * @param separators   The separators where the input should be split.
 *
 * @return             An initialized splitter.
 */
- (instancetype)initWithFileAtPath:(NSString *)path encoding:(NSStringEncoding)encoding andSeparators:(NSCharacterSet *)separators;

/** Initializes a `CBHStringSplitter` with data at a url using an encoding and a set of separators.
 *
 * @param url          The URL where the data to split exists.
 * @param encoding     The encoding to use in interpreting the data.
 * @param separators   The separators where the input should be split.
 *
 * @return             An initialized splitter.
 */
- (instancetype)initWithURL:(NSURL *)url encoding:(NSStringEncoding)encoding andSeparators:(NSCharacterSet *)separators;

/** Initializes a `CBHStringSplitter` with data read from a stream using an encoding and a set of separators.
 *
 * @param stream       The stream to read the data to split from.
 * @param encoding     The encoding to use in interpreting the data.
 * @param separators   The separators where the input should be split.
 *
 * @return             An initialized splitter.
 */
- (instancetype)initWithInputStream:(NSInputStream *)stream encoding:(NSStringEncoding)encoding  andSeparators:(NSCharacterSet *)separators NS_DESIGNATED_INITIALIZER;


#pragma mark - Enumerator Overrides

/** Compiles an array of all the remaining elements in the enumeration.
*
* Return: An `NSArray` containing all the remaining elements in the enumeration.
*/
- (NSArray<NSString *> *)allObjects;

/** Acquires the next string in the enumeration.
 *
 * Return: The next `NSString` in the enumeration or `nil` if at end.
 */
- (nullable NSString *)nextObject;


#pragma mark - Properties

/** The encoding to use while processing the input.
 */
@property (nonatomic, readonly) NSStringEncoding encoding;

/** The separators used to split the input.
*/
@property (nonatomic, readonly) NSCharacterSet *separators;

/** The size of the temporary buffer used in parsing the input.
*/
@property (nonatomic, readwrite) NSUInteger bufferSize;

/** Whether the enumeration has finished.
*/
@property (nonatomic, readonly) BOOL isFinished;

/** Whether the enumeration has finished buffering.
*/
@property (nonatomic, readonly) BOOL isFinishedBuffering;


#pragma mark - Unavailable

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
