//
//  ViewController.swift
//  PokemonAR
//
//  Created by Mac QA Acertum on 12/09/17.
//  Copyright © 2017 Mac QA Acertum. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit
import GameplayKit


class ViewController: UIViewController, ARSKViewDelegate {
    
    //sceneView = Contenedero de escenas
    @IBOutlet var sceneView: ARSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        //A esa pantalla se le asigna como delegado la propia pantalla
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        //Frames por segundo (Por lo regular 60)
        sceneView.showsFPS = true
        //Mostrar cuantos nodos hay en ese momento ne pantalla
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            //En la escena acutal presentar una escena particular
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        //Basico ARSessionConfiguration() = 3 Grados de libertad para rotar
        /*El ARWorldTrackingConfiguration() = 6 grados de libertad:
        3 para rotar y 3 para movimiento o translacion*/
        
        let configuration = ARSessionConfiguration()
        //let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSKViewDelegate
    //Se encarga de posicionar el elemento en la vista
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        
        let random = GKRandomSource.sharedRandom()
        //sera un numero entre 1 2 3 4
        //regresa un entero sin signo, de 0 al numero que se undica el upperBound sin tocarlo
        let pokemonId = random.nextInt(upperBound: 4) + 1
        return SKSpriteNode(imageNamed: "pokemon\(pokemonId)")
        
        /*
        let labelNode = SKLabelNode(text: "👾")
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        return labelNode;
         */
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
