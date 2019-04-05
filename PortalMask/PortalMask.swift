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

	var depth: CGFloat = 2.0
	var outerMult: CGFloat = 3.0
	/// Initializes a Portal of a given width and height.
	///
	/// - Parameters:
	///   - frameSize: [CGSize](apple-reference-documentation://hsWG5FZjhU) of the width and height the
	///       portal should be
	///   - depth: Optional depth the portal should go back. If no value is given it will default to twice
	///       the largest dimention of the frame
	///   - outerMult: Optional size the mask around the frame should be. The default is 3, making the
	///       edge three times the largest dimention of the frame.
	public init(frameSize: CGSize, depth: CGFloat! = nil, outerMult: CGFloat = 3) {
		self.outerMult = outerMult
		let depth = depth ?? max(frameSize.width, frameSize.height) * 2
		self.depth = depth
		super.init()
		self.bezierPath.usesEvenOddFillRule = true

		let hiderSize = max(frameSize.width, frameSize.height) * max(1, outerMult)
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
	public class func tube(
		radius: CGFloat, subdivisions: Int = 7,
		depth: CGFloat! = nil, outerMult: CGFloat = 5
	) -> PortalMask {
		let node = PortalMask()
		let segments = 1 << max(2, subdivisions)
		let depth = depth ?? radius * 2
		node.depth = depth
		node.outerMult = outerMult
		let shape = SCNTube(innerRadius: radius / 1.975, outerRadius: radius * outerMult, height: depth)
		shape.radialSegmentCount = segments
		let mask = SCNMaterial()
		mask.colorBufferWriteMask = SCNColorMask(rawValue: 0)
		mask.isDoubleSided = true
		let seeInside = SCNMaterial()
		seeInside.diffuse.contents = UIColor.clear
		shape.materials = [mask, seeInside]

		node.geometryHolder.geometry = shape
		node.geometryHolder.position.z = Float(-depth / 2) + 0.0003
		node.addChildNode(node.geometryHolder)
		return node
	}

	/// Initializes a Portal of a given radius with a square outer mask.
	///
	/// - Parameters:
	///   - radius: [CGFloat](apple-reference-documentation://hsX1m9hE7m) of the required portal
	///   - flatness: How smooth the desired circle will be. Value will be multiplied by
	///       the radius of the marker. Default value is 0.005.
	///       Would not recommend going higher than 0.01
	///   - depth: Optional depth the portal should go back. If no value is given it will default to
	///       four times the radius
	///   - outerMult: Optional size the mask around the frame should be. The default is 5, making the
	///       edge five times the radius.
	public init(radius: CGFloat, flatness: CGFloat = 0.005, depth: CGFloat! = nil, outerMult: CGFloat = 5) {
		self.bezierPath = UIBezierPath(ovalIn: CGRect(
			origin: CGPoint(x: -radius, y: -radius),
			size: CGSize(width: radius * 2, height: radius * 2)
		))
		let depth = depth ?? radius * 4
		self.depth = depth
		self.outerMult = max(1, outerMult)
		super.init()
		self.bezierPath.usesEvenOddFillRule = true
		let hiderSize = radius * self.outerMult
		self.bezierPath.addFrame(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: hiderSize, height: hiderSize)))
		self.bezierPath.flatness = radius * flatness

		self.geometryHolder.geometry = self.maskSCNShape(path: self.bezierPath, extrusionDepth: depth)
		self.geometryHolder.position.z = Float(-depth / 2) + 0.0003
		self.addChildNode(self.geometryHolder)
	}

	/// Initializes a Portal based on a given list of points
	///
	/// - Parameters:
	///   - path: A list of points that make up the edge of the portal.
	///   - flatness: Flatness best explained [here](apple-reference-documentation://hsY81TGpr3). The higher
	///       the value, the less vertices in the geometry, choose a lower value if the geometry is detailed.
	///   - depth: Optional depth the portal should go back. If no value is given it will default to twice
	///     	the largest dimention of the frame.
	///   - outerMult: Optional size the mask around the frame should be. The default is 3, making the
	///       edge three times the largest dimention of the frame.
	public init(path: [CGPoint], flatness: CGFloat = 0.6, depth: CGFloat! = nil, outerMult: CGFloat = 3) {
		self.outerMult = outerMult
		super.init()
		self.bezierPath.addPath(path: path)
		let bounds = self.bezierPath.bounds
		let largestDim = max(bounds.width, bounds.height)
		let depth = depth ?? largestDim * 2
		self.depth = depth
		self.bezierPath.usesEvenOddFillRule = true
		self.bezierPath.addFrame(frame:
			CGRect(
				origin: CGPoint.zero,
				size: CGSize(width: bounds.width * outerMult, height: bounds.height * outerMult)
			)
		)
		self.bezierPath.flatness = largestDim * flatness

		self.geometryHolder.geometry = self.maskSCNShape(path: self.bezierPath, extrusionDepth: depth)
		self.geometryHolder.position.z = Float(-depth / 2) + 0.0003
		self.addChildNode(self.geometryHolder)
	}

	/// Update the geometry to follow a new list of points
	///
	/// - Parameter path: A new list of points to define the shape of the portal
	public func updateGeometry(with path: [CGPoint]) {
		self.bezierPath.removeAllPoints()
		self.bezierPath.addPath(path: path)
		let bounds = self.bezierPath.bounds
		self.bezierPath.usesEvenOddFillRule = true
//		let largestDim = max(bounds.width, bounds.height)
		self.bezierPath.addFrame(frame:
			CGRect(
				origin: CGPoint.zero,
				size: CGSize(width: bounds.width * self.outerMult, height: bounds.height * self.outerMult)
			)
		)
		self.geometryHolder.geometry = self.maskSCNShape(path: self.bezierPath, extrusionDepth: self.depth)
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
