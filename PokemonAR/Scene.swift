//
//  Scene.swift
//  PokemonAR
//
//  Created by Mac QA Acertum on 12/09/17.
//  Copyright © 2017 Mac QA Acertum. All rights reserved.
//

import SpriteKit
import ARKit
import GameplayKit

class Scene: SKScene {
    
    let remainingLabel = SKLabelNode()
    var timer : Timer?
    var targetsCreated = 0
    var targetCount = 0 {
        //Se ejecuta despues de que cambia el valor de targetCount
        didSet{
            self.remainingLabel.text = "Faltan: \(targetCount)"
        }
    }
    //Para llamar el sonido cuando se muere un pokemon
    //el waitForComletion: es para hacer que el audio se pueda ejecutar dos o mas veces a la vez
    //o esperar que uno termine para que se haga la siguiente reproduccion, en este casso
    //se pondra false porque si queremos que se ejecuten varios simultaneamente
    let deathSound = SKAction.playSoundFileNamed("QuickDeath", waitForCompletion: false)
    //Nos regresa el date
    let startTime = Date()
    
    //Metodo similar al viewDidLoad
    override func didMove(to view: SKView) {
        /*
         Nota. La etiqueta aun no es Realidad Aumentada solo se coloca un label en la pantalla
         Se pueden configurar algunos elementos (La label) de la vista del SKLabelNode()
         programaticamente
         Las posiciones son objetos de la clase CoreGraphics.
         */
        //Configuracion del HeadUpDisplay
       remainingLabel.fontSize = 30
        remainingLabel.fontName = "Avenir Next"
        remainingLabel.color = .white
        //midY = la mitad de la pantalla
        remainingLabel.position = CGPoint(x: 0, y: view.frame.midY)
        addChild(remainingLabel)
        
        targetCount = 0
        
        
        //Crear temporizador que depesues de cada tiempo se ejecute un closure
        //para que se creee un enemigo en la pantalla
        //Creacion de enemigos cada 3 segundos
        
        //withTimeInterval, intervalo de ejecucion
        //repeat = i se va a repetir
        //block = closure de lo que se debe de ejecutar
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true,
                                     block: { (timer) in
                                        self.createTarget()
                                    })
        
        /*
         //NOTA como funciona GameplayKit
        let random = GKRandomSource.sharedRandom()
        //random.nextUniform() Genera un numero aleatorio entre 0 y  1
        //Como rotaremos en el eje X colocamos 1 en la posicion del eje x y los demas en 0
        //El 2 * Pi genera una vuelta completa
        //SCNMatrix4MakeRotation = Regresa la matriz de rotacion
        //float4x4.init = Transforma la matriz de roatacion a una 4x4
        let rotateX = float4x4.init(SCNMatrix4MakeRotation(2.0 * Float.pi *
            random.nextUniform(), 1, 0, 0))
        */
        
        
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
        
        //El reto es eobtener una coordenada 2D a partir de un plano 3D (La pantalla y los graficos)
        //Localizar le primer toque del conjunto de toques
        //Mirar si el toque cae dentro de nuestra vista de AR
        //guard es una sentencia de control como if pero siemrpe con elese
        guard let touch = touches.first else {return}
        //localizacion del toque
        let location = touch.location(in:self)
        print("El toque ha sido en: (\(location.x), \(location.y)")
        
        //Buscar todos los nodos que han sido tocados por ese toque de usuario
        let hit = nodes(at: location)
        
        //Cogeremos el primer sprite del array que nos devuelve el metodo anterior (si lo hay)
        //y animaremos ese pokemon hasta hacerlo desaparecer
        //Si hay primer objeto (significado de sentencia)
        if let sprite = hit.first{
            //Para animarlo hasta hacerlo desaparecer
            //Animacion, lo escalara al doble (el 2) de su tamaño con una animacion de 0.4 s
            let scaleOut = SKAction.scale(to: 2, duration: 0.4)
            //Para que desaparesca desvaneciendoce
            let fadeOut = SKAction.fadeOut(withDuration: 0.4)
            
            //Remueve el nodo de la pantalla, crea una accion que elimina el nodo de la pantalla
            let remove = SKAction.removeFromParent()
            
            //Para que las haga las dos animaciones al mismo tiempo
            //El death Sound es el sonido de muerte :D
            let groupAction = SKAction.group([scaleOut, fadeOut, deathSound])
            
            //Eliminamos el nodo de lapantalla ya que desaparecio el pokemn, se ejecutan una tras otra
            //Primero ejecuta la agrupacion que es escalar mas fadeout y despues los desaparece de la pantalla
            let sequenceAction = SKAction.sequence([groupAction,remove])
            
            //Corremos la sequencia
            sprite.run(sequenceAction)
            //actualizaremos que hay un pokemos menos con la variable target count
            targetCount -= 1
            
            //Se llama al metodo para visualizar el eltrero de gameover
            if targetsCreated == 25 && targetCount == 0 {
                gameOver()
            }
            
        }
        
        
        
        
        
        
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
    
    func createTarget(){
        //checamos si targetsCreated llega a 25  detenemos el timer y lo destruimos
        if targetsCreated == 25 {
            timer?.invalidate()
            timer = nil
            return
        }
        //Creamos los enemigos
        targetsCreated += 1
        targetCount += 1
        
        //Asegurarmos de que existe la sceneView
        //Sintaxix de Swift para asegurar que existe la scene
        guard let sceneView = self.view as? ARSKView else {return}
        
        //1. Crear un generador de numeros aleatorios
        let random = GKRandomSource.sharedRandom()
        
        //2. Crear una matriz de rotacion aleatroia en X
        //El eje de las X va de isquierda a derecha en la pantalla del celular (En portair)
        //El eje de las Y va de arriba a abajo en la pantalla del celular (En portair)
        //El eje Z sale del celular para rotar sobre su eje
        let rotateX = float4x4.init(SCNMatrix4MakeRotation(2.0 * Float.pi * random.nextUniform(), 1, 0, 0))
        
        //3. Crear una matriz de rotacion aleatorioa en Y
        let rotateY = float4x4.init(SCNMatrix4MakeRotation(2.0 * Float.pi * random.nextUniform(), 0, 1, 0))
        
        //4. Combinar las dos rotaciones con un producto de matrices
        let rotation = simd_mul(rotateX, rotateY)
        
        //5. Crear una translacion de 1.5 metros en la direccion de la pantalla
        //Se crea matriz identidad
        var translation = matrix_identity_float4x4
        //Se coloca la translacion a 1.5 m en Z
        translation.columns.3.z = -1.5
        
        //6. Combinar la rotacion del paso 4 con la translacion del paso 5
        let finalTransform = simd_mul(rotation, translation)
        
        //7. Crear un punto de ancla en el punto final determinado en el paso 6
        let anchor = ARAnchor(transform: finalTransform)
        
        //8. Añadir esa ancal a ala escena
        sceneView.session.add(anchor: anchor)
        
        
    }
    
    
    
    func gameOver() {
        
        //Ocultar la remainingLabel
        remainingLabel.removeFromParent()
        
        //Crear una nueva imagen con la foto de game over
        let gameOver = SKSpriteNode(imageNamed: "gameover")
        //Se añade a la pantalla
        addChild(gameOver)
        
        //Calcular cuanro le ha llevado al usuario cazar a todos los pokemon
        let timeTaken = Date().timeIntervalSince(startTime)
        
        //Mostrar ese tiempo que le ha llevado en pantalla en una etiqueta nueva
        let timeTakenLabel = SKLabelNode(text: "Te ha llevado: \(Int(timeTaken)) segundos")
        timeTakenLabel.fontSize = 40
        timeTakenLabel.color = .white
        //El view es opcional pero le colocamos ! porque estamos seguros de que exite la vista
        //Mover posiciones de X y Y para que aparesca el letrero
        timeTakenLabel.position = CGPoint(x: view!.frame.maxX - 50, y: -view!.frame.midY + 50)
        
        //Se añadel el label a la pantalla
        addChild(timeTakenLabel)
    }
    
    
    
    
}
