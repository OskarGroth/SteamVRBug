//
//  SwiftBridge.m
//  SteamVR
//
//  Created by Oskar Groth on 2017-06-06.
//  Copyright © 2017 Oskar Groth. All rights reserved.
//

#import "VRInterface.h"
#import <OpenVR/OpenVR.h>

@implementation VRInterface {
    vr::IVRSystem *hmd;
    vr::TrackedDevicePose_t rawDevicePoses[ vr::k_unMaxTrackedDeviceCount ];
    vr::IVRRenderModels *ivrRenderModels;
    vr::Texture_t eyeTexture;
}

+ (VRInterface *)shared {
    static VRInterface *sharedInstance = nil;

    if (sharedInstance == nil) {
        sharedInstance = [[VRInterface alloc] init];
    }
    
    return sharedInstance;
}

// MARK: Lifecycle

-(id)init {
    if (!(self = [super init])) return nil;
    
    vr::EVRInitError eError = vr::VRInitError_None;
    hmd = vr::VR_Init( &eError, vr::VRApplication_Scene );
    
    if ( eError != vr::VRInitError_None ) {
        hmd = NULL;
        NSLog(@"Unable to init VR runtime: %s", vr::VR_GetVRInitErrorAsEnglishDescription( eError ));
        return nil;
    }
    
    if ( !vr::VRCompositor() ) {
        printf( "Compositor initialization failed. See log file for details\n" );
        return nil;
    }
    
    uint32_t width, height;
    hmd->GetRecommendedRenderTargetSize(&width, &height);
    
    ivrRenderModels = (vr::IVRRenderModels *)vr::VR_GetGenericInterface( vr::IVRRenderModels_Version, &eError );
    if( !ivrRenderModels ) {
        hmd = NULL;
        vr::VR_Shutdown();
        NSLog(@"Unable to get render model interface: %s", vr::VR_GetVRInitErrorAsEnglishDescription( eError ));
        return nil;
    }
    return self;
}


-(void)shutdown {
    vr::VR_Shutdown();
    hmd = nil;
}

-(void)postPresentHandoff {
    vr::VRCompositor()->PostPresentHandoff();
}

-(id<MTLDevice>)getDevice {
    id<MTLDevice> vrDevice = nil;
    void *ptr = &vrDevice;
    hmd->GetOutputDevice((uint64_t*)ptr, vr::TextureType_IOSurface);
    return vrDevice;
}

// MARK: Head Tracking

-(void)updateHMDMatrixPose {
    if ( !hmd ) {
        NSLog(@"Update tracking failed: No device");
        return;
    }
    vr::VRCompositor()->WaitGetPoses(rawDevicePoses, vr::k_unMaxTrackedDeviceCount, NULL, 0 );
    //do things
}


@end

