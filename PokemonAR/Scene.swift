//
//  Scene.swift
//  PokemonAR
//
//  Created by Mac QA Acertum on 12/09/17.
//  Copyright © 2017 Mac QA Acertum. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    
    //Metodo similar al viewDidLoad
    override func didMove(to view: SKView) {
        // Setup your scene here
    }
    
    /*Intenta renderizar a 70 frames por segundo
         currente time = momento en el que se llama el metodo updat
         en este metodo se pueden actualizar imagenes que se mueven
     */
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    /*
     Metodo que se ejecuta cuando se toca la pantalla
     touches = todos los toques que ocurren en la pantalla
     event = movimiento que se ha llegado a cabo con todos estos toques
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        
/*
        //Consulta si tiene una pantalla actual
        //Esto casi no deberia pasar, solo es por seguridad que no se encutnre el View
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        // Create anchor using the camera's current position
        //Devuelve el frame actual del video
        if let currentFrame = sceneView.session.currentFrame {
            
            // Create a transform with a translation of 0.2 meters in front of the camera
            //Crea una matriz identidad
            var translation = matrix_identity_float4x4
            /* Pos = (0,0,0), Rot = (0,0,0)
              0 1 2 3
             [1,0,0,0] -> x
             [0,1,0,0] -> y
             [0,0,1,0] -> z
             [0,0,0,1] -> t
             */
            //Colcoa el valor z de la columna 3 a -0.2
            //Se desplaza 20 cm del origen
            translation.columns.3.z = -0.2
            /* Pos = (0,0,-0.2), Rot = (0,0,0)
             0 1 2 3
             [1,0,0,0] -> x
             [0,1,0,0] -> y
             [0,0,1,-0.2] -> z
             [0,0,0,1] -> t
             */
            //Multiplica dos matrices
            //Se crea una transformacion (Producto)
            let transform = simd_mul(currentFrame.camera.transform, translation)
            //simd_mul = Single Instruction Multiple Data - Multiply
            
            // Add a new anchor to the session
            //Se combina el SpriteKit con el ARKit
            //Se define el sitio donde iran los objetos
            let anchor = ARAnchor(transform: transform)
            //Se añaden
            sceneView.session.add(anchor: anchor)
        }
*/
  
    }
}
