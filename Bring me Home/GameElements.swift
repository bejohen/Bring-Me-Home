//
//  GameElements.swift
//  Beetle
//
//  Created by Muskan on 1/22/17.
//  Copyright © 2017 Muskan. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let playerCategory:UInt32 = 0x1 << 0
    static let obstacleCategory:UInt32 = 0x1 << 1
    static let triggerCategory:UInt32 = 0x1 << 2
    static let groundCategory:UInt32 = 0x1 << 3
    static let rumahCategory:UInt32 = 0x1 << 4
}

extension GameScene{
    func createPlayer() -> SKSpriteNode {
        let bird = SKSpriteNode(texture: SKTexture(imageNamed: "chibi"))
        bird.name = "player"
        bird.size = CGSize(width: 100, height: 100)
        bird.position = CGPoint(x:-620.127, y: self.frame.height / 2)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        bird.physicsBody?.categoryBitMask = CollisionBitMask.playerCategory
        bird.physicsBody?.collisionBitMask = CollisionBitMask.obstacleCategory | CollisionBitMask.triggerCategory | CollisionBitMask.groundCategory | CollisionBitMask.rumahCategory
        bird.physicsBody?.contactTestBitMask = CollisionBitMask.obstacleCategory | CollisionBitMask.triggerCategory | CollisionBitMask.groundCategory | CollisionBitMask.rumahCategory
        bird.physicsBody?.affectedByGravity = true
        bird.physicsBody?.isDynamic = true
        
        return bird
    }
    
    func createGround() -> SKNode {
        let groundLeft = SKSpriteNode(texture: SKTexture(imageNamed: "ground"))
        let groundRight = SKSpriteNode(texture: SKTexture(imageNamed: "ground"))
        
        groundLeft.position = CGPoint(x: -443.436, y: -306.058)
        groundRight.position = CGPoint(x: 443.436, y: -306.058)
        
        groundPair = SKNode()
        groundPair.name = "groundPair"
        
        groundLeft.physicsBody = SKPhysicsBody(rectangleOf: groundLeft.size)
        groundLeft.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        groundLeft.physicsBody?.collisionBitMask = CollisionBitMask.playerCategory
        groundLeft.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        groundLeft.physicsBody?.isDynamic = false
        groundLeft.physicsBody?.affectedByGravity = false
        
        groundRight.physicsBody = SKPhysicsBody(rectangleOf: groundRight.size)
        groundRight.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        groundRight.physicsBody?.collisionBitMask = CollisionBitMask.playerCategory
        groundRight.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        groundRight.physicsBody?.isDynamic = false
        groundRight.physicsBody?.affectedByGravity = false
        
        groundPair.addChild(groundLeft)
        groundPair.addChild(groundRight)
        
        return groundPair
    }
    
    func createRightBtn() {
        buttonRight = SKSpriteNode(imageNamed: "buttonRight")
        buttonRight.size = CGSize(width:150, height:150)
        buttonRight.position = CGPoint(x: -555, y: -290)
        buttonRight.zPosition = 6
        buttonRight.alpha = 0.5
        self.addChild(buttonRight)
        //restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func createLeftBtn() {
        buttonLeft = SKSpriteNode(imageNamed: "buttonLeft")
        buttonLeft.size = CGSize(width:150, height:150)
        buttonLeft.position = CGPoint(x: -725, y: -290)
        buttonLeft.zPosition = 6
        buttonLeft.alpha = 0.5
        self.addChild(buttonLeft)
    }
    
    func createBackground() {
        background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize(width:1792, height:828)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -5
        background.alpha = 1
        self.addChild(background)
    }
    
    func createJumpBtn() {
        buttonJump = SKSpriteNode(imageNamed: "buttonJump")
        buttonJump.size = CGSize(width:150, height:150)
        buttonJump.position = CGPoint(x: 715, y: -290)
        buttonJump.zPosition = 6
        buttonJump.alpha = 0.5
        self.addChild(buttonJump)
    }
    
    
    func createRestartBtn() {
        restartBtn = SKSpriteNode(imageNamed: "buttonJump")
        restartBtn.size = CGSize(width:150, height:150)
        restartBtn.position = CGPoint(x: 0, y: 0)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width:40, height:40)
        pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }
    
    func createScoreLabel() -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 50
        scoreLbl.fontName = "HelveticaNeue-Bold"
        
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        scoreBg.path = CGPath(roundedRect: CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100)), cornerWidth: 50, cornerHeight: 50, transform: nil)
        let scoreBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.2))
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = -1
        scoreLbl.addChild(scoreBg)
        return scoreLbl
    }
    
    func createHighscoreLabel() -> SKLabelNode {
        let highscoreLbl = SKLabelNode()
        highscoreLbl.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
        if let highestScore = UserDefaults.standard.object(forKey: "highestScore"){
            highscoreLbl.text = "Highest Score: \(highestScore)"
        } else {
            highscoreLbl.text = "Highest Score: 0"
        }
        highscoreLbl.zPosition = 5
        highscoreLbl.fontSize = 15
        highscoreLbl.fontName = "Helvetica-Bold"
        return highscoreLbl
    }
    
    func createLogo() {
        logoImg = SKSpriteNode()
        logoImg = SKSpriteNode(imageNamed: "chibi")
        logoImg.size = CGSize(width: 100, height: 100)
        logoImg.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 100)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func createTaptoplayLabel() -> SKLabelNode {
        let taptoplayLbl = SKLabelNode()
        taptoplayLbl.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 100)
        taptoplayLbl.text = "Tap anywhere to play"
        taptoplayLbl.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        taptoplayLbl.zPosition = 5
        taptoplayLbl.fontSize = 20
        taptoplayLbl.fontName = "HelveticaNeue"
        return taptoplayLbl
    }
    
    func createObstacle(position: CGPoint, alpha: CGFloat, rotation: CGFloat) -> SKSpriteNode  {
        let obstacle = SKSpriteNode(texture: SKTexture(imageNamed: "obstacle"))
        
        obstacle.position = position
        obstacle.alpha = alpha
        obstacle.zRotation = rotation
        
        obstacle.setScale(0.2)
        obstacle.name = "obstacle"
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.categoryBitMask = CollisionBitMask.obstacleCategory
        obstacle.physicsBody?.collisionBitMask = CollisionBitMask.playerCategory
        obstacle.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.affectedByGravity = false
        
        return obstacle
    }
    
    func createHome() -> SKSpriteNode  {
        let home = SKSpriteNode(texture: SKTexture(imageNamed: "home"))
        
        home.position = CGPoint(x:723, y: -30)
        
        //home.setScale(0.2)
        home.name = "obstacle"
        
        home.physicsBody = SKPhysicsBody(rectangleOf: home.size)
        home.physicsBody?.categoryBitMask = CollisionBitMask.rumahCategory
        home.physicsBody?.collisionBitMask = CollisionBitMask.playerCategory
        home.physicsBody?.contactTestBitMask = CollisionBitMask.playerCategory
        home.physicsBody?.isDynamic = false
        home.physicsBody?.affectedByGravity = false
        
        return home
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
}
