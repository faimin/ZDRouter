//
//  ZDRServiceBox.m
//  ZDRouter
//
//  Created by Zero.D.Saber on 2023/7/22.
//

#import "ZDRServiceBox.h"

@implementation ZDRServiceBox

- (void)dealloc {
    _strongObj = nil;
    _weakObj = nil;
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (instancetype)initWithClass:(Class)cls {
    if (self = [super init]) {
        _cls = cls;
    }
    return self;
}

#pragma mark - Setter

- (void)setStrongObj:(id<ZDRCommonProtocol>)strongObj {
    if (_strongObj == strongObj) {
        return;
    }
    
    [self _zdr_willRemoveObj:_strongObj];
    _strongObj = strongObj;
}

- (void)setWeakObj:(id<ZDRCommonProtocol>)weakObj {
    if (_weakObj == weakObj) {
        return;
    }
    
    [self _zdr_willRemoveObj:_weakObj];
    _weakObj = weakObj;
}

#pragma mark - Private

- (void)_zdr_willRemoveObj:(id<ZDRCommonProtocol>)obj {
    if (obj && [obj respondsToSelector:@selector(zdr_willDispose)]) {
        [obj zdr_willDispose];
    }
}

#pragma mark -

- (BOOL)isEqual:(ZDRServiceBox *)other {
    if (other == self) {
        return YES;
    }
    else if (self.strongObj && [self.strongObj isEqual:other.strongObj]) {
        return YES;
    }
    else if (self.weakObj && [self.weakObj isEqual:other.weakObj]) {
        return YES;
    }
    else {
        return [super isEqual:other];
    }
}

- (NSUInteger)hash {
    if (_strongObj) {
        return [_strongObj hash] ^ [self.cls hash] ^ self.priority;
    }
    else if (_weakObj) {
        return [_weakObj hash] ^ [self.cls hash] ^ self.priority;
    }
    else if (_cls) {
        return [self.cls hash] ^ self.priority;
    }
    return [super hash];
}

@end
