//
//  GameScene.swift
//  game1
//
//  Created by Jigar on 04/06/24.
//

import SpriteKit

class GameScene: SKScene {
    var player: SKSpriteNode!
    var aliens: [SKSpriteNode] = []
    var scoreLabel: SKLabelNode!
    var livesLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var lives = 3 {
        didSet {
            livesLabel.text = "Lives: \(lives)"
            if lives <= 0 {
                gameOver()
            }
        }
    }
    var alienMoveDirection: CGFloat = 10.0
    var gameOverLabel: SKLabelNode?
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        player = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 20))
        player.position = CGPoint(x: size.width / 2, y: player.size.height + 20)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = 4
        player.physicsBody?.contactTestBitMask = 2
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.affectedByGravity = false
        addChild(player)
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 80, y: size.height - 40)
        scoreLabel.fontColor = .white
        addChild(scoreLabel)
        
        livesLabel = SKLabelNode(text: "Lives: 3")
        livesLabel.position = CGPoint(x: size.width - 80, y: size.height - 40)
        livesLabel.fontColor = .white
        addChild(livesLabel)
        
        spawnAliens()
        
        let shootAction = SKAction.run(shoot)
        let waitAction = SKAction.wait(forDuration: 0.5)
        let sequenceAction = SKAction.sequence([shootAction, waitAction])
        run(SKAction.repeatForever(sequenceAction))
        
        let alienShootAction = SKAction.run(alienShoot)
        let alienWaitAction = SKAction.wait(forDuration: 2.0)
        let alienSequenceAction = SKAction.sequence([alienShootAction, alienWaitAction])
        run(SKAction.repeatForever(alienSequenceAction))
        
        physicsWorld.contactDelegate = self
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        player.position.x = location.x
    }
    
    func spawnAliens() {
        let numberOfAliens = 6
        let alienWidth: CGFloat = 40
        let alienHeight: CGFloat = 20
        let totalWidth = alienWidth * CGFloat(numberOfAliens) + CGFloat(numberOfAliens - 1) * 10
        
        for i in 0..<numberOfAliens {
            let alien = SKSpriteNode(color: .red, size: CGSize(width: alienWidth, height: alienHeight))
            alien.position = CGPoint(x: size.width / 2 - totalWidth / 2 + CGFloat(i) * (alienWidth + 10), y: size.height - 50)
            alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
            alien.physicsBody?.categoryBitMask = 2
            alien.physicsBody?.contactTestBitMask = 1
            alien.physicsBody?.collisionBitMask = 0
            alien.physicsBody?.affectedByGravity = false
            addChild(alien)
            aliens.append(alien)
        }
    }
    
    func moveAliens() {
        var changeDirection = false
        for alien in aliens {
            alien.position.x += alienMoveDirection
            if alien.position.x > size.width - alien.size.width / 2 || alien.position.x < alien.size.width / 2 {
                changeDirection = true
            }
        }
        if changeDirection {
            alienMoveDirection *= -1
            for alien in aliens {
                alien.position.y -= 20
                if alien.position.y < player.position.y + player.size.height / 2 {
                    lives = 0
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveAliens()
    }
    
    func shoot() {
        let bullet = SKSpriteNode(color: .green, size: CGSize(width: 5, height: 10))
        bullet.position = player.position
        bullet.position.y += player.size.height / 2
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.categoryBitMask = 1
        bullet.physicsBody?.contactTestBitMask = 2
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.velocity = CGVector(dx: 0, dy: 600)
        addChild(bullet)
    }
    
    func alienShoot() {
        guard let alien = aliens.randomElement() else { return }
        let bullet = SKSpriteNode(color: .red, size: CGSize(width: 5, height: 10))
        bullet.position = alien.position
        bullet.position.y -= alien.size.height / 2
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.categoryBitMask = 2
        bullet.physicsBody?.contactTestBitMask = 4
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.velocity = CGVector(dx: 0, dy: -600)
        addChild(bullet)
    }
    
    func gameOver() {
        gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel?.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gameOverLabel?.fontColor = .white
        gameOverLabel?.fontSize = 40
        addChild(gameOverLabel!)
        
        isPaused = true
        
        let restartLabel = SKLabelNode(text: "Tap to Restart")
        restartLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50)
        restartLabel.fontColor = .white
        restartLabel.fontSize = 20
        addChild(restartLabel)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPaused {
            restartGame()
        }
    }
    
    func restartGame() {
        isPaused = false
        score = 0
        lives = 3
        gameOverLabel?.removeFromParent()
        gameOverLabel = nil
        
        removeAllChildren()
        
        didMove(to: view!)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node {
            if nodeA.physicsBody?.categoryBitMask == 2 && nodeB.physicsBody?.categoryBitMask == 1 {
                nodeA.removeFromParent()
                score += 1
            } else if nodeA.physicsBody?.categoryBitMask == 1 && nodeB.physicsBody?.categoryBitMask == 2 {
                nodeB.removeFromParent()
                score += 1
            } else if nodeA.physicsBody?.categoryBitMask == 4 && nodeB.physicsBody?.categoryBitMask == 2 {
                nodeB.removeFromParent()
                lives -= 1
            } else if nodeA.physicsBody?.categoryBitMask == 2 && nodeB.physicsBody?.categoryBitMask == 4 {
                nodeA.removeFromParent()
                lives -= 1
            }
        }
    }
}
