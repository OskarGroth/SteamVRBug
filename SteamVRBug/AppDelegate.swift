//
//  AppDelegate.swift
//  SteamVRBug
//
//  Created by Oskar Groth on 2018-04-29.
//  Copyright © 2018 Oskar Groth. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var vr: VRInterface?
    internal var queue: DispatchQueue?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        vr = VRInterface.shared()
    }

    func start() {
        queue = DispatchQueue(label: "render")
        queue?.async {
            print("\n\n\nStarting Render...\n\n")
            while true {
                self.vr?.updateHMDMatrixPose() //waitGetPoses
                // do rendering
            }
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

