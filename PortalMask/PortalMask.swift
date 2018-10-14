//
//  PortalMask.swift
//  PortalMask
//
//  Created by Max Cobb on 14/10/2018.
//  Copyright © 2018 Max Cobb. All rights reserved.
//

import SceneKit.SCNNode

// MARK: -
/// A node containing a geometry that will create a portal of the specified properties and dimensions.
open class PortalMask: SCNNode {
	/**
	Initializes a Portal of a given width and height.

	- Parameters:
		- frameSize: [CGSize](apple-reference-documentation://hsWG5FZjhU) of the width and height the portal should be
		- depth: Optional depth the portal should go back. If no value is given it will default to twice the largest dimention of the frame
		- outerMult: Optional size the mask around the frame should be. The default is three times the largest dimention of the frame.

	- Returns: A new rectangular portal
	*/
	public init(frameSize: CGSize, depth: CGFloat! = nil, outerMult: CGFloat = 3) {
		super.init()
		let depth = depth ?? max(frameSize.width, frameSize.height) * 2
		self.bezierPath.usesEvenOddFillRule = true

		let hiderSize = max(frameSize.width, frameSize.height) * max(1,outerMult)
		self.bezierPath.addFrame(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: hiderSize, height: hiderSize)))

		// dividing by exactly 2 doesn't work so well for tracking images
		let innerW = frameSize.width / 1.975
		let innerH = frameSize.height / 1.975
		self.bezierPath.addFrame(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: innerW, height: innerH)))

		self.geometryHolder.geometry = self.maskSCNShape(path: self.bezierPath, extrusionDepth: depth)
		self.geometryHolder.position.z = Float(-depth / 2) + 0.0003
		self.addChildNode(self.geometryHolder)
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private let geometryHolder = SCNNode()
	private var bezierPath = UIBezierPath()

	private func materialList() -> [SCNMaterial] {
		let mask = SCNMaterial()
		mask.colorBufferWriteMask = SCNColorMask(rawValue: 0)
		mask.isDoubleSided = true
		let seeInside = SCNMaterial()
		seeInside.diffuse.contents = UIColor.clear
		return [mask, SCNMaterial(), seeInside]
	}

	private func maskSCNShape(path: UIBezierPath, extrusionDepth: CGFloat) -> SCNShape {
		let shape = SCNShape(path: self.bezierPath, extrusionDepth: extrusionDepth)
		shape.materials = self.materialList()
		return shape
	}
}
