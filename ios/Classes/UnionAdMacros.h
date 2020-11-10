//
//  UnionAdMacros.h
//  Pods
//
//  Created by OctMon on 2020/11/10.
//

#ifndef UnionAdMacros_h
#define UnionAdMacros_h


#define BUD_Log(frmt, ...)   \
do {                                                      \
NSLog(@"【UnionAdExample】%@", [NSString stringWithFormat:frmt,##__VA_ARGS__]);  \
} while(0)


#endif /* UnionAdMacros_h */
