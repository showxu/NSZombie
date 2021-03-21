//
//  NSObject+NSZombie.m
//  NSZombie
//
//  Created by Xudong Xu on 2016/11/26.
//

#import "NSObject+NSZombie.h"

@import Foundation.NSObject;
@import ObjectiveC.runtime;
@import Darwin.C.stdio;
@import Darwin.malloc._malloc;

#define ZOMBIE_PREFIX "_NSZombie_"

NS_ROOT_CLASS
@interface _NSZombie_ {
    Class isa;
}

@end

@implementation _NSZombie_

+ (void)initialize {
}

@end


@implementation NSObject(NSZombie)

- (void)dealloc {
    const char *name = object_getClassName(self);
    char *zombie = nil;
    do {
        if (asprintf(&zombie, "%s%s", ZOMBIE_PREFIX, name) == -1) {
            break;
        }
        
        Class zombieClass = objc_getClass(zombie);
        
        if (!zombieClass) {
            zombieClass = objc_duplicateClass(objc_getClass(ZOMBIE_PREFIX), zombie, 0);
        }
        
        if (zombieClass == Nil) {
            break;
        }
//        objc_destructInstance(self);
        object_setClass(self, zombieClass);
    } while (0);
    
    if (zombie != NULL) {
        free(zombie);
    }
}

@end
