////
////  GameScene.swift
////  game1
////
////  Created by Jigar on 30/05/24.
////
//
//import SpriteKit
//
//struct PhysicsCategory {
//    static let none: UInt32 = 0
//    static let player: UInt32 = 0x1 << 0
//    static let ground: UInt32 = 0x1 << 1
//    static let platform: UInt32 = 0x1 << 2
//    static let enemy: UInt32 = 0x1 << 3
//}
//
//enum PlayerType {
//    case cody, guy, haggar
//}
//
//class GameScene: SKScene, SKPhysicsContactDelegate {
//    var playerType: PlayerType = .cody
//    var player: SKSpriteNode!
//    var score = 0
//    let scoreLabel = SKLabelNode(fontNamed: "PressStart2P") // Retro font
//    var isMovingLeft = false
//    var isMovingRight = false
//
//    override func didMove(to view: SKView) {
//        self.backgroundColor = .black
//
//        addScrollingBackground()
//
//        addPlayer()
//        setupGround()
//        setupScoreLabel()
//        addPlatforms()
//        addEnemy()
//
//        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
//        physicsWorld.contactDelegate = self
//    }
//
//    func addPlayer() {
//        switch playerType {
//        case .cody:
//            player = SKSpriteNode(imageNamed: "cody")
//        case .guy:
//            player = SKSpriteNode(imageNamed: "guy")
//        case .haggar:
//            player = SKSpriteNode(imageNamed: "haggar")
//        }
//        
//        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
//        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
//        player.physicsBody?.affectedByGravity = true
//        player.physicsBody?.categoryBitMask = PhysicsCategory.player
//        player.physicsBody?.contactTestBitMask = PhysicsCategory.ground | PhysicsCategory.platform | PhysicsCategory.enemy
//        player.physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.platform
//        addChild(player)
//    }
//
//    func setupGround() {
//        let ground = SKSpriteNode(color: .brown, size: CGSize(width: size.width, height: 50))
//        ground.position = CGPoint(x: size.width / 2, y: 25)
//        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
//        ground.physicsBody?.isDynamic = false
//        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
//        ground.physicsBody?.collisionBitMask = PhysicsCategory.player
//        addChild(ground)
//    }
//
//    func setupScoreLabel() {
//        scoreLabel.text = "Score: \(score)"
//        scoreLabel.fontSize = 20
//        scoreLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.9)
//        addChild(scoreLabel)
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//
//        if location.x < size.width / 2 {
//            isMovingLeft = true
//        } else {
//            isMovingRight = true
//        }
//
//        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50)) // Keep this for jump
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        isMovingLeft = false
//        isMovingRight = false
//    }
//
//    override func update(_ currentTime: TimeInterval) {
//        if isMovingLeft {
//            player.position.x -= 5
//        } else if isMovingRight {
//            player.position.x += 5
//        }
//    }
//
//    func addPlatforms() {
//        let positions = [
//            CGPoint(x: size.width * 0.2, y: size.height * 0.6),
//            CGPoint(x: size.width * 0.5, y: size.height * 0.7),
//            CGPoint(x: size.width * 0.8, y: size.height * 0.5)
//        ]
//
//        for position in positions {
//            let platform = SKSpriteNode(color: .green, size: CGSize(width: 100, height: 20))
//            platform.position = position
//            platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
//            platform.physicsBody?.isDynamic = false
//            platform.physicsBody?.categoryBitMask = PhysicsCategory.platform
//            platform.physicsBody?.collisionBitMask = PhysicsCategory.player
//            addChild(platform)
//        }
//    }
//
//    func addEnemy() {
//        let enemy = SKSpriteNode(color: .red, size: CGSize(width: 40, height: 40))
//        enemy.position = CGPoint(x: size.width * 0.8, y: size.height * 0.4)
//        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
//        enemy.physicsBody?.isDynamic = true
//        enemy.physicsBody?.affectedByGravity = false
//        enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
//        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.player
//        enemy.physicsBody?.collisionBitMask = PhysicsCategory.none
//
//        addChild(enemy)
//
//        let moveLeft = SKAction.moveBy(x: -size.width * 0.6, y: 0, duration: 2)
//        let moveRight = SKAction.moveBy(x: size.width * 0.6, y: 0, duration: 2)
//        let sequence = SKAction.sequence([moveLeft, moveRight])
//        let repeatForever = SKAction.repeatForever(sequence)
//        enemy.run(repeatForever)
//    }
//
//    func addScrollingBackground() {
//        for i in 0...1 {
//            let background = SKSpriteNode(imageNamed: "background")
//            background.position = CGPoint(x: CGFloat(i) * size.width, y: size.height / 2)
//            background.size = CGSize(width: size.width, height: size.height)
//            background.zPosition = -1
//            addChild(background)
//
//            let moveLeft = SKAction.moveBy(x: -size.width, y: 0, duration: 5)
//            let resetPosition = SKAction.moveBy(x: size.width, y: 0, duration: 0)
//            let moveSequence = SKAction.sequence([moveLeft, resetPosition])
//            let moveForever = SKAction.repeatForever(moveSequence)
//            background.run(moveForever)
//        }
//    }
//
//    func incrementScore() {
//        score += 1
//        scoreLabel.text = "Score: \(score)"
//    }
//
//    func gameOver() {
//        let gameOverLabel = SKLabelNode(fontNamed: "PressStart2P")
//        gameOverLabel.text = "GAME OVER"
//        gameOverLabel.fontSize = 40
//        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        addChild(gameOverLabel)
//    }
//
//    func didBegin(_ contact: SKPhysicsContact) {
//        if contact.bodyA.categoryBitMask == PhysicsCategory.enemy || contact.bodyB.categoryBitMask == PhysicsCategory.enemy {
//            gameOver()
//        }
//    }
//}
