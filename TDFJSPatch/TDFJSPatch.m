//
//  TDFJSPatch.m
//  jspatch
//
//  Created by chaiweiwei on 16/6/21.
//  Copyright © 2016年 chaiweiwei. All rights reserved.
//

#import "TDFJSPatch.h"

static  NSString * const zipFilePassword = @"123456";

@implementation TDFJSPatch

- (void)start {
    [JPEngine startEngine];
    NSString *documentFile = [self getDocPath];
    NSString *unZipTargetDirPath = [documentFile stringByAppendingPathComponent:@"JSPatchFile"];
    NSString *mainJSPath = [[unZipTargetDirPath stringByAppendingPathComponent:[self clientVersion]] stringByAppendingPathComponent:@"main.js"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:mainJSPath]) {
        NSError *error = nil;
        NSString *script = [NSString stringWithContentsOfFile:mainJSPath encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
            NIDERROR(@"JSPatch load js from file error %@", script);
        }else {
            [JPEngine evaluateScript:script];
        }
    }
}

+ (void)setupJSPathWithData:(NSDictionary *)JSPatchInfo {
    
    if(!JSPatchInfo) return;
    
    TDFJSPatch *jsPatch = [[TDFJSPatch alloc] init];

    NSString *oldJsVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kTDFJSPatchFileVersion];
    
    NSString *newJsVersion = JSPatchInfo[@"jsFile_version"];
    
    NSURL *url = [NSURL URLWithString:JSPatchInfo[@"jsFile_zip_url"]];
    
    NSString *zipfileName = [url lastPathComponent];
    
    NSString *cachePath = [[jsPatch getCatchPath] stringByAppendingPathComponent:zipfileName];
    NSString *unZipTargetDirPath = [[jsPatch getDocPath] stringByAppendingPathComponent:@"JSPatchFile"];
    
    if (![oldJsVersion isEqualToString:newJsVersion]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
            NSError *err;
            [[NSFileManager defaultManager] removeItemAtPath:cachePath error:&err];
            
            if (err) {
                NIDERROR(@"JSPatch remove cache file error:%@",err);
            }
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:unZipTargetDirPath]) {
            NSError *err;
            [[NSFileManager defaultManager] createDirectoryAtPath:unZipTargetDirPath withIntermediateDirectories:YES attributes:nil error:&err];
            
            if (err) {
                NIDERROR(@"JSPatch create document file error:%@",err);
            }
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            NSString *dataHash = NIMD5HashFromData(data);
            NSString *zipHash = JSPatchInfo[@"jsFile_zip_hash"];
            
            [data writeToFile:cachePath atomically:YES];
            
            if(data && [dataHash isEqualToString:zipHash]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:newJsVersion forKey:kTDFJSPatchFileVersion];
                
                [SSZipArchive unzipFileAtPath:cachePath
                                toDestination:unZipTargetDirPath
                                    overwrite:YES
                                     password:zipFilePassword
                              progressHandler:nil
                            completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [jsPatch start];
                                });
                            }];
            }
        });
    }
}

- (NSString *)clientVersion {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *clientVersion = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    return clientVersion;
}

- (NSString *)getDocPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}

- (NSString *)getCatchPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return paths[0];
}

@end
