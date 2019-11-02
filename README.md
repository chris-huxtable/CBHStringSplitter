# CBHStringSplitter

[![release](https://img.shields.io/github/release/chris-huxtable/CBHStringSplitter.svg)](https://github.com/chris-huxtable/CBHStringSplitter/releases)
[![pod](https://img.shields.io/cocoapods/v/CBHStringSplitter.svg)](https://cocoapods.org/pods/CBHStringSplitter)
[![licence](https://img.shields.io/badge/licence-ISC-lightgrey.svg?cacheSeconds=2592000)](https://github.com/chris-huxtable/CBHStringSplitter/blob/master/LICENSE)
[![coverage](https://img.shields.io/badge/coverage-100%25-brightgreen.svg?cacheSeconds=2592000)](https://github.com/chris-huxtable/CBHStringSplitter)

`CBHStringSplitter` is an `NSEnumerator` subclass which splits strings using an `NSInputStream` to process input with minimal memory use. 

While `CBHStringSplitter` is slightly slower than the equivalent `componentsSeparatedByCharactersInSet` it does not load the entire contents of a file into memory. This makes it more appropriate for some use cases.


## Examples

### Process each line in a file using a for in loop:

```objective-c
NSString *path = @"/path/to/file";
CBHStringSplitter *splitter = [CBHStringSplitter splitterWithFileAtPath:path andSeparators:[NSCharacterSet newlineCharacterSet]];

for (NSString *line in splitter)
{
	// Do something with the line...
}
```


### Process each line in a file using a while loop:

```objective-c
NSString *path = @"/path/to/file";
CBHStringSplitter *splitter = [CBHStringSplitter splitterWithFileAtPath:path andSeparators:[NSCharacterSet newlineCharacterSet]];

NSString *line;
while ( (line = [splitter nextObject]) )
{
	// Do something with the line...
}
```


## Notes:

- Unlike `componentsSeparatedByCharactersInSet` if the input is suffixed with a separator character an empty string will not be given as the last entry. It will just be ignored.


## TODO:
 - Performance Improvements
 - Simplify buffering
 - Block based enumeration

Pull requests are welcome.


## Licence
CBHStringSplitter is available under the [ISC license](https://github.com/chris-huxtable/CBHStringSplitter/blob/master/LICENSE).
