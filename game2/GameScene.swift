//
//  GameScene.swift
//  game2
//
//  Created by Drum, Jesse on 12/14/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var aiPaddle = SKSpriteNode()
    var theBall = SKNode()
    var paddle = SKSpriteNode()
    var isFingerOnPaddle = false
    var top = SKSpriteNode()
    var bottom = SKSpriteNode()
    var botScore = 0
    var myScore = 0
    var scoreLabel = SKLabelNode()
    
    override func didMove(to view: SKView)
    {
        theBall = self.childNode(withName: "theBall")!
        paddle = self.childNode(withName: "paddle") as! SKSpriteNode
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        createAIPaddle()
        //followBall()
        createTopandBottom()
        physicsWorld.contactDelegate = self
        theBall.physicsBody?.categoryBitMask = 1
        top.physicsBody?.categoryBitMask = 2
        bottom.physicsBody?.categoryBitMask = 3
        
        theBall.physicsBody?.contactTestBitMask = 2 | 3
        setUpLabel()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
   
        print(contact.contactPoint)
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2
        {
            print("hit the top")
            myScore += 1
            resetBall()
        }
        if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1
        {
            print("hit the top")
            myScore += 1
            resetBall()
        }
        print(contact.contactPoint)
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 3
        {
            print("hit the bottom")
            botScore += 1
            resetBall()
        }
        if contact.bodyA.categoryBitMask == 3 && contact.bodyB.categoryBitMask == 1
        {
            print("hit the bottom")
            botScore += 1
            resetBall()
        }
        print("My Score: \(myScore) \nCPU Score: \(botScore)" )
    updateScoreLabels()
    }
    
    func setUpLabel()
    {
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel.text = " \(myScore) - \(botScore)"
        scoreLabel.position = CGPoint(x: frame.width * 0.75, y: frame.height * 0.5)
        scoreLabel.fontSize = 75
        scoreLabel.zRotation = CGFloat.pi / 2
        scoreLabel.fontColor = UIColor.black
        addChild(scoreLabel)
    }
    
    func updateScoreLabels()
    {
        scoreLabel.text = "\(myScore) - \(botScore)"
    }
    
    func createTopandBottom()
    {
        top = SKSpriteNode(color: .green, size: CGSize(width: frame.width, height: 50))
        top.position = CGPoint(x: frame.width/2, y: frame.height)
        addChild(top)
        top.physicsBody = SKPhysicsBody(rectangleOf: top.frame.size)
        top.physicsBody?.isDynamic = false
        top.name = "top"
        
        bottom = SKSpriteNode(color: .red, size: CGSize(width: frame.width, height: 50))
        bottom.position = CGPoint(x: frame.width/2, y: 0)
        addChild(bottom)
        bottom.physicsBody = SKPhysicsBody(rectangleOf: top.frame.size)
        bottom.physicsBody?.isDynamic = false
        bottom.name = "bottom"
        
    }
    
    func createAIPaddle()
    {
        aiPaddle = SKSpriteNode(color: UIColor.systemRed, size: CGSize(width: 200, height: 50))
        aiPaddle.position = CGPoint(x: frame.width/2, y: frame.height*0.9)
        
        aiPaddle.physicsBody = SKPhysicsBody(rectangleOf: aiPaddle.size)
        aiPaddle.physicsBody?.affectedByGravity = false
        aiPaddle.physicsBody?.friction = 0
        aiPaddle.physicsBody?.isDynamic = false
        aiPaddle.physicsBody?.allowsRotation = false
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(followBall),
            SKAction.wait(forDuration: 0.5)
        ])))
        
        
        addChild(aiPaddle)
    }
    
    func followBall()
    {
        let move = SKAction.moveTo(x: theBall.position.x, duration: 0.5)
        aiPaddle.run(move)
    }
    
    func pushBall()
    {
        var nums = [-200,200]
        var randomx = nums.randomElement()!
        var randomy = nums.randomElement()!
        theBall.physicsBody?.applyImpulse(CGVector(dx: randomx, dy: randomy))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        print(location)
//        makeNewBall(touchLocation: location!)
        if paddle.contains(location!)
        {
            isFingerOnPaddle = true
        }
        
//        theBall.physicsBody?.velocity = CGVector(dx: 0, dy: -1000)
//        print(event)
    }
    
    
    func resetBall()
    {
        theBall.physicsBody?.velocity = .zero
        let wait = SKAction.wait(forDuration: 1.0)
        let sequence = SKAction.sequence([wait, SKAction.run(bringBalltoCenter), wait, SKAction.run(pushBall)])
        run(sequence)
    
    }
    func bringBalltoCenter()
    {
        theBall.position = CGPoint(x: frame.width/2, y: frame.height/2)
    }
        
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        if isFingerOnPaddle == true
        {
            paddle.position = CGPoint(x: location!.x, y: paddle.position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnPaddle = false
    }

 
    
    
    

}
