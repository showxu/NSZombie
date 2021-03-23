//
//  NSObject+NSZombie.m
//  NSZombie
//
//  Created by Xudong Xu on 2016/11/26.
//

#pragma clang diagnostic push

#import "NSObject+NSZombie.h"

@import ObjectiveC.runtime;
@import Darwin.C.stdio;
@import Darwin.malloc._malloc;

NS_ROOT_CLASS
@interface _NSZombie_ {
    Class isa;
}

+ (char *)name;

@end

@implementation _NSZombie_

+ (void)initialize {
}

+ (char *)name {
    return "_NSZombie_";
}

@end

@implementation NSObject(NSZombie)

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)dealloc {
    const char *name = object_getClassName(self);
    char *zombie = nil;
    do {
        if (asprintf(&zombie, "%s%s", _NSZombie_.name, name) == -1) {
            break;
        }
        
        Class zombieClass = objc_getClass(zombie);
        if (!zombieClass) {
            zombieClass = objc_duplicateClass(objc_getClass(_NSZombie_.name), zombie, 0);
        }
        if (zombieClass == Nil) {
            break;
        }
        /// OBJC_ARC_UNAVAILABLE
        /// objc_destructInstance(self);
        object_setClass(self, zombieClass);
    } while (0);
    
    if (zombie != NULL) {
        free(zombie);
    }
}

@end

#pragma clang diagnostic pop
