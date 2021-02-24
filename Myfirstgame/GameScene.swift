//
//  GameScene.swift
//  Myfirstgame
//
//  Created by harpanth kaur on 2021-02-10.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene , SKPhysicsContactDelegate {
    var birds = SKSpriteNode()
    var bg = SKSpriteNode()
    var scorelabel = SKLabelNode()
    var gameOver = SKLabelNode()
    var score = 0
    var timer = Timer()
    enum Collidertype: UInt32
    {
      case bird = 1
      case object = 2
        case gap = 4
    }
    
    var gameover = false
    @objc func makepipes()
   {
    let movepipe = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 100))
    let gapheight = birds.size.height * 6
    let movement = arc4random() % UInt32(self.frame.height / 2)
    let pipeoffset = CGFloat(movement) - self.frame.height / 4
    let pipetexture = SKTexture(imageNamed: "pipe1.png")
    let pipe1 = SKSpriteNode(texture: pipetexture)
    pipe1.run(movepipe)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipetexture.size())
        pipe1.physicsBody!.isDynamic = false
        pipe1.physicsBody!.contactTestBitMask = Collidertype.object.rawValue
        pipe1.physicsBody!.categoryBitMask = Collidertype.object.rawValue
        pipe1.physicsBody!.collisionBitMask = Collidertype.object.rawValue
    pipe1.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + self.frame.height / 1 + gapheight / 2 + pipeoffset)
        pipe1.zPosition = -1
    self.addChild(pipe1)
    
    let pipetexture1 = SKTexture(imageNamed: "pipe2.png")
    let pipe2 = SKSpriteNode(texture: pipetexture1)
    pipe2.run(movepipe)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipetexture1.size())
        pipe2.physicsBody!.isDynamic = false
        pipe2.physicsBody!.contactTestBitMask = Collidertype.object.rawValue
        pipe2.physicsBody!.categoryBitMask = Collidertype.object.rawValue
        pipe2.physicsBody!.collisionBitMask = Collidertype.object.rawValue
    pipe2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + -self.frame.height / 1 - gapheight / 2 + pipeoffset)
        pipe2.zPosition = -1
    self.addChild(pipe2)
        let gap = SKNode()
        
        gap.position = CGPoint(x:self.frame.midX + self.frame.width, y:self.frame.midY+pipeoffset)
        gap.physicsBody = SKPhysicsBody(rectangleOf: pipetexture1.size())
        gap.physicsBody!.isDynamic = false
        gap.run(movepipe)
        gap.physicsBody!.contactTestBitMask = Collidertype.bird.rawValue
        gap.physicsBody!.categoryBitMask = Collidertype.gap.rawValue
        gap.physicsBody!.collisionBitMask = Collidertype.gap.rawValue
        self.addChild(gap)
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == Collidertype.gap.rawValue || contact.bodyB.categoryBitMask == Collidertype.gap.rawValue
        {
            score += 1
            scorelabel.text = String(score)
           // print("add one to score")
        }
        else{
        //print("contact made")
       self.speed = 0
        gameover = true
            timer.invalidate()
            gameOver.fontName="Helvetica"
            gameOver.text="gameover! tap to play again"
            gameOver.fontSize = 30
            gameOver.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            self.addChild(gameOver)
        }
    }
    override func didMove(to view: SKView)
    {
        self.physicsWorld.contactDelegate = self
       setupgame()
    }
        
   func setupgame()
   {
   timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makepipes), userInfo: nil, repeats: true)
  //  birds = childNode(withName: "bird")as? SKSpriteNode
    let bgtexture = SKTexture(imageNamed: "bg.png")
    let movebackground = SKAction.move(by: CGVector(dx: -bgtexture.size().width, dy: 0), duration: 6)
    let shiftanimation = SKAction.move(by: CGVector(dx: bgtexture.size().width, dy: 0), duration: 0)
    
    let backgroundforever = SKAction.repeatForever(SKAction.sequence([movebackground, shiftanimation]))
    var i:CGFloat = 0
    while i < 3
    {
    bg = SKSpriteNode(texture: bgtexture)
    bg.position = CGPoint(x:bgtexture.size().width * i, y:self.frame.midY)
    bg.size.height = self.frame.height
    bg.run(backgroundforever)
    bg.zPosition = -2
    self.addChild(bg)
     i += 1
    }
    let
    birdtexture = SKTexture(imageNamed: "flappy1.png")
    let birdtexture1 = SKTexture(imageNamed: "flappy2.png")
    let animation = SKAction.animate(with: [birdtexture, birdtexture1] , timePerFrame: 0.01)
    let makeflip = SKAction.repeatForever(animation)
    birds = SKSpriteNode(texture: birdtexture)
    birds.position = CGPoint(x: self.frame.midX, y:self.frame.midY)
    birds.run(makeflip)
    
    //birdtexture = SKTexture(imageNamed: "flappy1.png")
    birds.physicsBody = SKPhysicsBody(circleOfRadius: birdtexture.size().height/2);
    birds.physicsBody!.isDynamic = false
    birds.physicsBody!.contactTestBitMask = Collidertype.object.rawValue
    birds.physicsBody!.categoryBitMask = Collidertype.bird.rawValue
    birds.physicsBody!.collisionBitMask = Collidertype.bird.rawValue
    self.addChild(birds)
    let ground = SKNode()
    ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
    ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 100))
    ground.physicsBody!.isDynamic = false
    
   ground.physicsBody!.contactTestBitMask = Collidertype.object.rawValue
   ground.physicsBody!.categoryBitMask = Collidertype.object.rawValue
    ground.physicsBody!.collisionBitMask = Collidertype.object.rawValue
    self.addChild(ground)
    scorelabel.fontName = "Helvetica"
    scorelabel.fontSize = 60
    scorelabel.text = "0"
    scorelabel.position = CGPoint(x:self.frame.midX, y:self.frame.height/2 - 70)
    self.addChild(scorelabel)
    
       }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     if gameover == false
     {
             birds.physicsBody!.isDynamic = true
        birds.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        birds.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 50))
    }
     else{
        gameover = false
        score = 0
        self.speed = 1
        self.removeAllChildren()
    setupgame()
     }
        
      
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
