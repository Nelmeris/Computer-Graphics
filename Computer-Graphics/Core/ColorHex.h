//
//  ColorHex.h
//  Computer-Graphics
//
//  Created by Artem Kufaev on 03.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

#ifndef ColorHex_h
#define ColorHex_h

@interface NSColor (Hex)

+ (NSColor *)colorFromHexString:(NSString *)hexString;
+ (NSColor*) colorWithHex: (NSUInteger) hex;

- (NSString*)hexString;

@end

#endif /* ColorHex_h */
