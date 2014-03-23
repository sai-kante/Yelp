//
//  BusinessModel.h
//  Yelp
//
//  Created by Sai Kante on 3/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "JSONModel.h"


@interface LocationModel : JSONModel
@property (strong, nonatomic) NSArray* address;
@end

@protocol BusinessModel @end

@interface BusinessModel : JSONModel
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* image_url;
@property (strong, nonatomic) LocationModel* location;
@end

@interface YelpModel : JSONModel
@property (strong, nonatomic) NSArray<BusinessModel>* businesses;
@end