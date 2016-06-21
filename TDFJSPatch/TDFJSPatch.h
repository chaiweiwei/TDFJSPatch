//
//  TDFJSPatch.h
//  jspatch
//
//  Created by chaiweiwei on 16/6/21.
//  Copyright © 2016年 chaiweiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobeConst.h"
#import <JSPatch/JPEngine.h>
#import <SSZipArchive/SSZipArchive.h>
#import <Nimbus/NimbusCore.h>

@interface TDFJSPatch : NSObject

+ (void)setupJSPathWithData:(NSDictionary *)JSPatchInfo;

@end
