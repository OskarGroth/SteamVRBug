//
//  IVRCommon.swift
//  SteamVR
//
//  Created by Oskar Groth on 2017-06-16.
//  Copyright © 2017 Oskar Groth. All rights reserved.
//

import Cocoa
import SceneKit

@objc public class CompositorTextureBounds: NSObject {
    @objc public let uMin: Float
    @objc public let uMax: Float
    @objc public let vMin: Float
    @objc public let vMax: Float
    
    @objc public init(uMin: Float, uMax: Float, vMin: Float, vMax: Float) {
        self.uMin = uMin
        self.uMax = uMax
        self.vMin = vMin
        self.vMax = vMax
    }
    
}

@objc public enum DeviceType: Int {
    case hmd
    case controller
    case tracker // Generic trackers, similar to controllers
    case reference // Camera and base stations that serve as tracking reference points
    case displayRedirect // Accessories that aren't necessarily tracked themselves, but may redirect video output from other tracked devices
    case unknown
}

@objc public protocol VRDelegate: class {
    func trackedDeviceAppeared(_ device: TrackedDevice?)
    func trackedDeviceDisappeared(_ device: TrackedDevice?)
}

@objc public class RenderModel: NSObject {
    @objc public let name: String
    @objc public let geometry: SCNGeometry
    
    @objc init(name: String, vPos: SCNVector3, vNormal: SCNVector3, textureCoord: CGPoint, vertexCount: Int, vertexData: Data, indexData: Data, triangleCount: Int, texture: RenderModelTexture?) {
        self.name = name
        let stride = 8*MemoryLayout<Float>.size
        let dataSize = MemoryLayout<Float>.size
        let vertexSource = SCNGeometrySource(data: vertexData, semantic: .vertex, vectorCount: vertexCount, usesFloatComponents: true, componentsPerVector: 3, bytesPerComponent: dataSize, dataOffset: 0, dataStride: stride)
        let normalSource = SCNGeometrySource(data: vertexData, semantic: .normal, vectorCount: vertexCount, usesFloatComponents: true, componentsPerVector: 3, bytesPerComponent: dataSize, dataOffset: 3*dataSize, dataStride: stride)
        let tcoordSource = SCNGeometrySource(data: vertexData, semantic: .texcoord, vectorCount: vertexCount, usesFloatComponents: true, componentsPerVector: 2, bytesPerComponent: dataSize, dataOffset: 6*dataSize, dataStride: stride)
        let geometryElement = SCNGeometryElement(data: indexData, primitiveType: .triangles, primitiveCount: triangleCount, bytesPerIndex: MemoryLayout<UInt16>.size)
        geometry = SCNGeometry(sources: [vertexSource, normalSource, tcoordSource], elements: [geometryElement])
        super.init()
    }
    
}

@objc public class TrackedDevice: SCNNode {
    @objc public let deviceName: String
    @objc public let deviceType: DeviceType
    
    @objc init(renderModel: RenderModel, deviceType: DeviceType) {
        self.deviceName = renderModel.name
        self.deviceType = deviceType
        super.init()
        geometry = renderModel.geometry
        let material = SCNMaterial()
        material.diffuse.contents = NSColor.darkGray
        geometry?.materials[0] = material
    }
    
    override public var debugDescription: String {
        return "\(deviceName)"
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

@objc class RenderModelTexture: NSObject {
    let width: UInt16
    let height: UInt16
    let data: Data
    
    @objc init(width: UInt16, height: UInt16, data: Data) {
        self.width = width
        self.height = height
        self.data = data
    }
}
