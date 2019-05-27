//
//  GameScene.swift
//  Bring me Home
//
//  Created by Johanes Steven on 25/05/19.
//  Copyright © 2019 bejohen. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameStarted = Bool(false)

    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var background = SKSpriteNode()
    var rumah = SKSpriteNode()
    var isWin = Bool(false)
    var score = Int(0)
    var scoreLbl = SKLabelNode()
    var playAgainLbl = SKLabelNode()
    var youWinLbl = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var groundPair = SKNode()
    var moveAndRemove = SKAction()
    var obstacle = SKNode()
    
    var life = Int(5)
    var jatoh = SKSpriteNode()
    
    var cloud = SKNode()
    var thunder = SKSpriteNode()
    
    var trigger = SKSpriteNode()
    var triggerL = SKSpriteNode()
    var triggerJ = SKSpriteNode()
    
    var buttonRight = SKSpriteNode()
    var buttonLeft = SKSpriteNode()
    var buttonJump = SKSpriteNode()
    
    var isGameOver = false
    var player = SKSpriteNode()
    
    var jatohTrigger = false
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        createScene()
        //self.physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "player" {
            collisionBetween(player: nodeA, object: nodeB)
        } else if nodeB.name == "player" {
            collisionBetween(player: nodeB, object: nodeA)
        }
    }
    
    func collisionBetween(player: SKNode, object: SKNode) {
        var actionArray = [SKAction]()
        actionArray.append(SKAction.moveTo(x: self.position.x + 800, duration: 0.5))
        if object.name == "ground" {
            print("collision with ground")
        } else if object.name == "obstacle" && !isGameOver {
            print("collision with obstacle")
            object.alpha = 1
            isGameOver = true
            self.player.texture = SKTexture(imageNamed: "chibi-lose")
            self.player.removeAllActions()
            life -= 1
            createGameOverText(text: "You Lose! :(", miniText: "Try Again?")
            createRestartBtn()
        } else if object.name == "trigger" && !isGameOver {
            print("collision with trigger")
            let groundRight = groundPair.children[1]
            groundRight.run(actionArray[0])
        } else if object.name == "home" && !isGameOver {
            print("collision with home")
            isGameOver = true
            isWin = true
            self.player.removeAllActions()
            createGameOverText(text: "You Win!", miniText: "Play Again?")
            createRestartBtn()
        } else if object.name == "thunder" && !isGameOver {
            print("collision with thunder")
            isGameOver = true
            self.player.texture = SKTexture(imageNamed: "chibi-lose")
            self.player.removeAllActions()
            life -= 1
            createGameOverText(text: "You Lose! :(", miniText: "Try Again?")
            createRestartBtn()
            let grin = SKLabelNode()
            grin.position = CGPoint(x: 350, y: 250)
            grin.text = "🤪"
            grin.zPosition = 5
            self.addChild(grin)
        } else if object.name == "triggerLightning" && !isGameOver {
            print("collision with triggerL")
            createThunder()
        }
        else if object.name == "triggerJatoh" && !isGameOver && !jatohTrigger {
            print("collision with triggerJ")
            jatohTrigger = true
            jatoh = objJatoh()
            self.addChild(jatoh)
            jatoh.run(SKAction.moveTo(y: self.position.y - 500, duration: 1))
        }
    }
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            for button in [buttonLeft, buttonRight, buttonJump] {
                if button.contains(location) && !isGameOver {//&& pressedButtons.index(of: button) == nil {
                    switch button {
                    case buttonLeft:
                        player.run(SKAction.moveTo(x: player.position.x - 100, duration: 0.5))
                        player.texture = SKTexture(imageNamed: "chibi-left")
                    case buttonRight:
                        player.run(SKAction.moveTo(x: player.position.x + 100, duration: 0.5))
                        player.texture = SKTexture(imageNamed: "chibi")
                    case buttonJump:
                        //player.run(SKAction.moveTo(y: player.position.y + 200, duration: 0.5))
                        player.run(SKAction.applyImpulse(CGVector(dx: 0, dy: 500), duration: 0.3))
                    default:
                        player.run(SKAction.moveTo(y: player.position.x, duration: 0.5))
                    }
                    
                }
            }
            
            for button in [restartBtn] {
                if button.contains(location) {
                    restartScene()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            for button in [buttonLeft, buttonRight] {
                if button.contains(location) && !isGameOver {//&& pressedButtons.index(of: button) == nil {
                    switch button {
                    case buttonLeft:
                        player.run(SKAction.moveTo(x: player.position.x - 100, duration: 0.5))
                        player.texture = SKTexture(imageNamed: "chibi-left")
                    case buttonRight:
                        player.run(SKAction.moveTo(x: player.position.x + 100, duration: 0.5))
                        player.texture = SKTexture(imageNamed: "chibi")
                    default:
                        player.run(SKAction.moveTo(y: player.position.x, duration: 0.5))
                    }
                    
                }
            }
            
            //player.run(SKAction.moveTo(x: player.position.x + 10, duration: 0.5))
        }
    }
    
    func restartScene(){
        self.removeAllChildren()
        self.obstacle.removeAllChildren()
        self.removeAllActions()
        isGameOver = false
        gameStarted = false
        jatohTrigger = false
        createScene()
        if isWin {
            isWin = false
            score = 0
            life = 5
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    
    func createScene(){
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.playerCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        //self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        createBackground()
        self.cloud = createCloud()
        self.addChild(cloud)
        
        self.scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)

        self.groundPair = self.createGround()
        self.addChild(self.groundPair)
        
        self.rumah = createHome()
        self.addChild(rumah)
        
        self.player = createPlayer()
        self.addChild(player)
        
        self.trigger = createTrigger()
        self.addChild(trigger)
        
        self.triggerL = createTriggerLightning()
        self.addChild(triggerL)
        
        self.triggerJ = createTriggerObsJatoh()
        self.addChild(triggerJ)
        
        self.obstacle.addChild(createObstacle(position: CGPoint(x: -400.436, y: -156.058), alpha: 1, rotation: 0))
        self.obstacle.addChild(createObstacle(position: CGPoint(x: -20.436, y: -156.058), alpha: 0, rotation: 0))
        
        //yg disamping kiri
        self.obstacle.addChild(createObstacle(position: CGPoint(x: -873.436, y: -116.058), alpha: 0, rotation: -(CGFloat.pi/2)))
        self.obstacle.addChild(createObstacle(position: CGPoint(x: -873.436, y: 0), alpha: 0, rotation: -(CGFloat.pi/2)))
        self.obstacle.addChild(createObstacle(position: CGPoint(x: -873.436, y: 116.058), alpha: 0, rotation: -(CGFloat.pi/2)))
        self.obstacle.addChild(createObstacle(position: CGPoint(x: -873.436, y: 116.058*2), alpha: 0, rotation: -(CGFloat.pi/2)))
        self.obstacle.addChild(createObstacle(position: CGPoint(x: -873.436, y: 116.058*3), alpha: 0, rotation: -(CGFloat.pi/2)))
        
        //yg diatas
        self.obstacle.addChild(createObstacle(position: CGPoint(x: -50, y: 290), alpha: 0, rotation: CGFloat.pi))
        
        self.obstacle.addChild(createObstacle(position: CGPoint(x: 100, y: 200), alpha: 1, rotation: CGFloat.pi))
        
        self.obstacle.addChild(createObstacle(position: CGPoint(x: 300, y: 390), alpha: 0, rotation: CGFloat.pi))
        self.obstacle.addChild(createObstacle(position: CGPoint(x: -500, y: 390), alpha: 0, rotation: CGFloat.pi))
        self.obstacle.addChild(createObstacle(position: CGPoint(x: 550, y: 150), alpha: 0, rotation: CGFloat.pi))
        
        //yg dibawah
        self.obstacle.addChild(createObstacle(position: CGPoint(x: 130, y: -390), alpha: 0, rotation: 0))
        self.obstacle.addChild(createObstacle(position: CGPoint(x: 230, y: -390), alpha: 0, rotation: 0))
        
        self.addChild(obstacle)
        
        createRightBtn()
        createLeftBtn()
        createJumpBtn()
        
        //ANIMATE THE BIRD AND REPEAT THE ANIMATION FOREVER
        
        //scoreLbl = createScoreLabel()
        //self.addChild(scoreLbl)
        
        //highscoreLbl = createHighscoreLabel()
        //self.addChild(highscoreLbl)
        
        //createLogo()
        
        //taptoplayLbl = createTaptoplayLabel()
        //self.addChild(taptoplayLbl)
    }
}
