//
//  SwiftBridge.h
//  SteamVR
//
//  Created by Oskar Groth on 2017-06-06.
//  Copyright © 2017 Oskar Groth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

@protocol VRDelegate;
@interface VRInterface : NSObject

+ (VRInterface *)shared;
-(id)init;
-(void)shutdown;
-(void)postPresentHandoff;
-(void)updateHMDMatrixPose;

@end
