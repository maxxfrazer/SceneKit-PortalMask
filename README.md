# SceneKit-PortalMask

[![Version](https://img.shields.io/cocoapods/v/PortalMask.svg)](https://cocoapods.org/pods/PortalMask)
[![License](https://img.shields.io/cocoapods/l/PortalMask.svg)](https://cocoapods.org/pods/PortalMask)
[![Platform](https://img.shields.io/cocoapods/p/PortalMask.svg)](https://cocoapods.org/pods/PortalMask)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://swift.org/)
[![Build Status](https://travis-ci.com/maxxfrazer/SceneKit-PortalMask.svg?branch=master)](https://travis-ci.com/maxxfrazer/SceneKit-PortalMask)

[See my Medium post about this CocoaPod](https://link.medium.com/4LK2PReBXR)

This class `PortalMask` creates an occluding box around any rectangular frame, including a tracking image, which turns the tracking image or any static area into an Augmented Reality portal into a scene you can define inside that area that can be seen by looking through the defined portal.
This can also be used to have the illusion of a hole in the ground.

Include this pod in your project:
`pod 'PortalMask'`

The following example code creates a portal ontop of a tracking marker, similar to the example gif.

```
func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
	if let imageAnchor = anchor as? ARImageAnchor {
		let nodeRotated = SCNNode()
		nodeRotated.eulerAngles.x = -.pi / 2
		// the next 2 lines add the portal
		let portal = PortalMask(frameSize: imageAnchor.referenceImage.physicalSize)
		nodeRotated.addChildNode(portal)

		// the next 4 lines add a cube inside the image area
		let width = imageAnchor.referenceImage.physicalSize.width
		let boxNode = SCNNode(geometry: SCNBox(width: width, height: width, length: width, chamferRadius: 0))
		boxNode.position.z = -boxNode.width
		nodeRotated.addChildNode(boxNode)

		node.addChild(nodeRotated)
	}
}

```

Also contains functions for circular holes:
```
let portal = PortalMask(radius: imageAnchor.referenceImage.physicalSize.width)
```
And any other polygon by feeding coordinates. This example will make a triangular portal:
```
let portal = PortalMask(path: [CGPoint(x: 1, y: -1), CGPoint(x: 0, y: 1), CGPoint(x: -1, y: -1)])
```

Here's some basic examples of what you can do with this Pod:

![Tracking Portal Example](https://github.com/maxxfrazer/SceneKit-PortalMask/blob/master/media/PortalMask-example.gif)
![Flappy Bird Example](https://github.com/maxxfrazer/SceneKit-PortalMask/blob/master/media/PortalMask-FlappyBird.gif)
