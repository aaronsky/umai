//
//  UserStore.h
//  Anime List
//
//  Created by Aaron Sky on 4/23/14.
//  Copyright (c) 2014 Aaron Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLDictionary.h"

@interface UserStore : NSObject

@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* password;

+(instancetype)currentUser;

@end
