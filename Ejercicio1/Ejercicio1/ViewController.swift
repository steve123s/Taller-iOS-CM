//
//  ViewController.swift
//  Ejercicio1
//
//  Created by Daniel Esteban Salinas Suárez on 11/28/18.
//  Copyright © 2018 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit
import SceneKit



class ViewController: UIViewController, SCNPhysicsContactDelegate {
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    // create a scene view with an empty scene
    let sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    let scene = SCNScene()
    let audioSource = SCNAudioSource(fileNamed: "drop1.mp3")
    
    override func loadView() {
        
        scene.physicsWorld.contactDelegate = self
        sceneView.scene = scene
        sceneView.backgroundColor = UIColor.brown
        sceneView.scene?.background.contents = UIImage(named: "wall.jpeg")
        
        // default lighting
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        sceneView.autoenablesDefaultLighting = true
        
        // a camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 25)
        scene.rootNode.addChildNode(cameraNode)
        

        // add dice to the scene
        scene.rootNode.addChildNode(createDice(position: SCNVector3(-3, 0, 0)))
        scene.rootNode.addChildNode(createDice(position: SCNVector3(0, 3, 0)))
        scene.rootNode.addChildNode(createDice(position: SCNVector3(3, 6, 0)))
        scene.rootNode.addChildNode(createFloor())
        
        // add restart button
        let restartButton = UIButton(type: .custom)
        restartButton.frame = CGRect(x: 0, y: 50, width: 100, height: 100)
        restartButton.setTitle("🔄", for: .normal)
        restartButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        restartButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        sceneView.addSubview(restartButton)

        view = sceneView // Set the view property to the sceneView created here.
        
    }
    
    @objc func buttonClicked(sender : UIButton){
        scene.rootNode.childNode(withName: "dice", recursively: true)?.removeFromParentNode()
        scene.rootNode.childNode(withName: "dice", recursively: true)?.removeFromParentNode()
        scene.rootNode.childNode(withName: "dice", recursively: true)?.removeFromParentNode()
        scene.rootNode.addChildNode(createDice(position: SCNVector3(-3, 0, 0)))
        scene.rootNode.addChildNode(createDice(position: SCNVector3(0, 3, 0)))
        scene.rootNode.addChildNode(createDice(position: SCNVector3(3, 6, 0)))
    }
    
    func createFloor() -> SCNNode {
        // a geometry object for floor
        let floor = SCNBox(width: 50, height: 50, length: 0.1, chamferRadius: 5)
        let floorNode = SCNNode(geometry: floor)
        
        floor.firstMaterial?.diffuse.contents  = UIColor.red
        floorNode.position = SCNVector3(x: 0, y: -10, z: 0)
        floorNode.rotation = SCNVector4(x: 1, y: 0, z: 0.0, w: Float(Double.pi/2))
        
        // Add Physics Body
        let floorPhysicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: floor))
        floorNode.physicsBody = floorPhysicsBody
        floorNode.name = "floor"
        let floorMat = SCNMaterial()
        floorMat.diffuse.contents = UIImage(named: "table.jpeg")
        floor.firstMaterial = floorMat
        
        floorNode.physicsBody?.contactTestBitMask = 1
        
        return floorNode
    }
    
    func createDice(position: SCNVector3) -> SCNNode {
        // a geometry object for box
        let box = SCNBox(width: 1.5, height: 1.5, length: 1.5, chamferRadius: 0.2)
        
        // configure the textures
        box.materials = getDefaultDiceMaterials()
        let boxNode = SCNNode(geometry: box)
        boxNode.position = position
        
        // Add Physics Body
        let boxPhysicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: box))
        boxNode.physicsBody = boxPhysicsBody
        boxNode.name = "dice"
        boxNode.physicsBody?.damping = 0.0
        
        boxNode.physicsBody?.contactTestBitMask = 1

        return boxNode
    }

    
    func getDefaultDiceMaterials() -> [SCNMaterial] {
        var materials: [SCNMaterial] = []
        guard let diceTexture = UIImage(named: "de.jpg") else {return materials}
        let diceFaceWidth = diceTexture.size.width/4
        let diceFaceHeight = diceTexture.size.height/3
        
        for i in 0...5 {
            switch i {
            case 0:
                let five = SCNMaterial()
                let fiveRect = CGRect(x: diceFaceWidth * 2, y: diceFaceHeight * 2, width: diceFaceWidth, height: diceFaceHeight)
                five.diffuse.contents = cropImage(diceTexture, toRect: fiveRect)
                materials.append(five)
            case 1:
                let two = SCNMaterial()
                let twoRect = CGRect(x: diceFaceWidth * 2, y: 0, width: diceFaceWidth, height: diceFaceHeight)
                two.diffuse.contents = cropImage(diceTexture, toRect: twoRect)
                materials.append(two)
            case 2:
                let three = SCNMaterial()
                let threeRect = CGRect(x: diceFaceWidth * 3, y: diceFaceHeight, width: diceFaceWidth, height: diceFaceHeight)
                three.diffuse.contents = cropImage(diceTexture, toRect: threeRect)
                materials.append(three)
            case 3:
                let four = SCNMaterial()
                let fourRect = CGRect(x: diceFaceWidth, y: diceFaceHeight, width: diceFaceWidth, height: diceFaceHeight)
                four.diffuse.contents = cropImage(diceTexture, toRect: fourRect)
                materials.append(four)
            case 4:
                let one = SCNMaterial()
                let oneRect = CGRect(x: diceFaceWidth * 2, y: diceFaceHeight, width: diceFaceWidth, height: diceFaceHeight)
                one.diffuse.contents = cropImage(diceTexture, toRect: oneRect)
                materials.append(one)
            case 5:
                let six = SCNMaterial()
                let sixRect = CGRect(x: 0, y: diceFaceHeight, width: diceFaceWidth, height: diceFaceHeight)
                six.diffuse.contents = cropImage(diceTexture, toRect: sixRect)
                materials.append(six)
            default:
                break
            }
        }
        print(materials)
        return materials
    }
    
    
    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect) -> UIImage? {
        
        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x:cropRect.origin.x,
                              y:cropRect.origin.y,
                              width:cropRect.size.width,
                              height:cropRect.size.height)
        
        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
            else {
                return nil
        }
        
        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
    
    
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if event?.subtype == UIEvent.EventSubtype.motionShake{
            scene.rootNode.childNodes.filter({
                $0.name == "dice" }).forEach(
                    {   $0.physicsBody?.applyForce(SCNVector3(
                            x: Float.random(in: -0.1...0.1),
                            y: Float.random(in: 8...12),
                            z: Float.random(in: -0.1...0.1)) , asImpulse: true)
                        $0.physicsBody?.applyTorque(SCNVector4(
                            x: Float.random(in: -2...2) ,
                            y: Float.random(in: -2...2),
                            z: Float.random(in: -2...2),
                            w: Float.pi * Float.random(in: -1...1)) , asImpulse: true)
                })
        }
    }
    
    
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        print(contact.collisionImpulse)
        if contact.collisionImpulse <= 2 { return }
        if contact.nodeA.name == "dice" && !contact.nodeA.hasActions {
            contact.nodeA.runAction(SCNAction.playAudio(audioSource!, waitForCompletion: true))
        } else if contact.nodeB.name == "dice" && !contact.nodeB.hasActions {
                contact.nodeB.runAction(SCNAction.playAudio(audioSource!, waitForCompletion: true))
        }
    }

    
}



