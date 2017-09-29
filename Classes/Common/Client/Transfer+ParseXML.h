//
//  Transfer+ParseXML.h
//  LKOA4iPhone
//
//  Created by  STH on 7/28/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transfer.h"

@interface Transfer (ParseXML)

- (id) ParseXMLWithReqName:(NSString *) reqName
                           xmlString:(NSString *) xml;


@end


