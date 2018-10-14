//
//  PortalMask.swift
//  PortalMask
//
//  Created by Max Cobb on 14/10/2018.
//  Copyright © 2018 Max Cobb. All rights reserved.
//

import SceneKit.SCNNode

open class PortalMask: SCNNode {
	private let geometryHolder = SCNNode()
	private var bezierPath = UIBezierPath()
	private func addOutsideBox(boxSize: CGFloat) {
		self.bezierPath.move(to: CGPoint(x: -boxSize, y: -boxSize))
		self.bezierPath.addLine(to: CGPoint(x: -boxSize, y: boxSize))
		self.bezierPath.addLine(to: CGPoint(x: boxSize, y: boxSize))
		self.bezierPath.addLine(to: CGPoint(x: boxSize, y: -boxSize))
		self.bezierPath.close()
	}
	public init(frameSize: CGSize, depth: CGFloat! = nil, outerMult: CGFloat = 3) {
		super.init()
		let depth = depth ?? max(frameSize.width, frameSize.height) * 2
		bezierPath.usesEvenOddFillRule = true
		let hiderSize = max(frameSize.width, frameSize.height) * max(1,outerMult)
		self.addOutsideBox(boxSize: hiderSize)

		let innerW = frameSize.width / 1.975
		let innerH = frameSize.height / 1.975
		bezierPath.move(to: CGPoint(x: -innerW, y: -innerH))
		bezierPath.addLine(to: CGPoint(x: -innerW, y: innerH))
		bezierPath.addLine(to: CGPoint(x: innerW, y: innerH))
		bezierPath.addLine(to: CGPoint(x: innerW, y: -innerH))
		bezierPath.close()

		let mask = SCNMaterial()
		mask.colorBufferWriteMask = SCNColorMask(rawValue: 0)
		mask.isDoubleSided = true
		let seeInside = SCNMaterial()
		seeInside.diffuse.contents = UIColor.clear

		let shape = SCNShape(path: bezierPath, extrusionDepth: depth)
		shape.materials = [mask, SCNMaterial(), seeInside]

		self.geometryHolder.geometry = shape
		self.geometryHolder.position.z = Float(-depth / 2) + 0.0003
		self.addChildNode(self.geometryHolder)
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
