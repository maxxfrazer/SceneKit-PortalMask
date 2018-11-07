//
//  PortalMask.swift
//  PortalMask
//
//  Created by Max Cobb on 14/10/2018.
//  Copyright © 2018 Max Cobb. All rights reserved.
//

import SceneKit.SCNNode

/// A node containing a geometry that will create a portal of the specified properties and dimensions.
open class PortalMask: SCNNode {

	/// Initializes a Portal of a given width and height.
	///
	/// - Parameters:
	///   - frameSize: [CGSize](apple-reference-documentation://hsWG5FZjhU) of the width and height the
	///       portal should be
	///   - depth: Optional depth the portal should go back. If no value is given it will default to twice
	///       the largest dimention of the frame
	///   - outerMult: Optional size the mask around the frame should be. The default is three times
	///       the largest dimention of the frame.
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

	/// Initializes a Portal of a given radius with a circular outer mask at the cost of using almost double
	/// vertices than the other circular portal.
	///
	/// - Parameters:
	///   - radius: [CGFloat](apple-reference-documentation://hsX1m9hE7m) of the required portal
	///   - subdivisions: How circular the desired circle will be. Default is 7, creating a circle with
	///       128 (2^7) vertices on the inside. Minimum is 2 and will produce a square with vertices
	///       on the sides, top and bottom.
	///   - depth: Optional depth the portal should go back. If no value is given it will default to
	///       four times the radius
	///   - outerMult: Optional size the mask around the frame should be. The default is six times the radius.
	/// - Returns: A new rectangular portal
	public class func tube(radius: CGFloat, subdivisions: Int = 7, depth: CGFloat! = nil, outerMult: CGFloat = 5) -> PortalMask {
		let node = PortalMask()
		let segments = 1 << max(2, subdivisions)
		let depth = depth ?? radius * 2
		let shape = SCNTube(innerRadius: radius / 1.975, outerRadius: radius * outerMult, height: depth)
		shape.radialSegmentCount = segments
		let mask = SCNMaterial()
		mask.colorBufferWriteMask = SCNColorMask(rawValue: 0)
		mask.isDoubleSided = true
		let seeInside = SCNMaterial()
		seeInside.diffuse.contents = UIColor.clear
		shape.materials = [mask, seeInside]

		node.geometryHolder.geometry = shape
		node.geometryHolder.eulerAngles.x = -.pi / 2
		node.geometryHolder.position.z = Float(-depth / 2) + 0.0003
		node.addChildNode(node.geometryHolder)
		return node
	}

	/// Initializes a Portal of a given radius with a square outer mask.
	///
	/// - Parameters:
	///   - radius: [CGFloat](apple-reference-documentation://hsX1m9hE7m) of the required portal
	///   - subdivisions: How circular the desired circle will be. Default is 8, creating a circle
	///       with 256 (2^8) vertices on the inside. Minimum is 2 and will produce a square with
	///       vertices on the sides, top and bottom.
	///   - depth: Optional depth the portal should go back. If no value is given it will default to
	///       four times the radius
	///   - outerMult: Optional size the mask around the frame should be.
	///       The default is six times the radius.
	public init(radius: CGFloat, subdivisions: Int = 7, depth: CGFloat! = nil, outerMult: CGFloat = 6) {
		super.init()
		// have a minimum subdivisions here because the circle must have at least 4 points
		let segments = 1 << max(2, subdivisions)
		let depth = depth ?? radius * 4
		self.bezierPath.usesEvenOddFillRule = true
		let hiderSize = radius * max(1,outerMult)
		self.bezierPath.addFrame(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: hiderSize, height: hiderSize)))

		self.bezierPath.move(to: CGPoint(x: radius, y: 0))
		let angleInc = (.pi * 2) / CGFloat(segments)
		var currentAngle: CGFloat = angleInc
		while currentAngle < .pi * 2 {
			let newPoint = CGPoint(x: radius * cos(currentAngle), y: radius * sin(currentAngle))
			bezierPath.addLine(to: newPoint)
			currentAngle += angleInc
		}
		self.bezierPath.close()

		self.geometryHolder.geometry = self.maskSCNShape(path: self.bezierPath, extrusionDepth: depth)
		self.geometryHolder.position.z = Float(-depth / 2) + 0.0003
		self.addChildNode(self.geometryHolder)
	}

	private override init() {
		super.init()
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
