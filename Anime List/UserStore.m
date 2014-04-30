//
//  UserStore.m
//  Anime List
//
//  Created by Aaron Sky on 4/23/14.
//  Copyright (c) 2014 Aaron Sky. All rights reserved.
//

#import "UserStore.h"

@implementation UserStore

+(id)currentUser{
    static UserStore* currentUser = nil;
    if (!currentUser) {
        currentUser = [[self alloc] initPrivate];
    }
    return currentUser;
}

-(instancetype)init{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[UserStore currentUser]!" userInfo:nil];
    return nil;
}

-(instancetype) initPrivate{
    if(self = [super init]){
        _username = @"";
        _password = @"";
    }
    return self;
}

@end
