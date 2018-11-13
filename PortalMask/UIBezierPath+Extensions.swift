//
//  UIBezierPath+Extensions.swift
//  PortalMask
//
//  Created by Max Cobb on 14/10/2018.
//  Copyright © 2018 Max Cobb. All rights reserved.
//

import UIKit

private func + (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

internal extension UIBezierPath {

	/// Frame on a [UIBezierPath](apple-reference-documentation://hs-I2UtavK) to draw
	///
	/// - Parameter frame: Frame on the [UIBezierPath](apple-reference-documentation://hs-I2UtavK) to draw
	internal func addFrame(frame: CGRect) {
		self.move(to: CGPoint(x: -frame.width, y: -frame.height) + frame.origin)
		self.addLine(to: CGPoint(x: -frame.width, y: frame.height) + frame.origin)
		self.addLine(to: CGPoint(x: frame.width, y: frame.height) + frame.origin)
		self.addLine(to: CGPoint(x: frame.width, y: -frame.height) + frame.origin)
		self.close()
	}

	internal func addPath(path: [CGPoint]) {
		guard let firstPoint = path.first else {
			return
		}
		self.move(to: firstPoint)
		for point in path[1...] {
			self.addLine(to: point)
		}
		self.close()
	}
}
