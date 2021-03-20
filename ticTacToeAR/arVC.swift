//
//  ViewController.swift
//  ticTacToeAR
//
//  Created by Jacek Chojnacki on 15/03/2021.
//

import UIKit
import RealityKit

class ARViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    @IBOutlet weak var newGameButton: UIButton!
    
    var currentEntity: Entity?
    var circlePawn: Entity?
    var crossPawn: Entity?
    var pawnTurn: Int = 0
    var winSign: Entity?
    var isWon: Bool = false
    var moveCount: Int = 0
    var gameType: Int = 1
    var aiPawn: Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        let boxAnchor = try! Experience.loadBox()
        
        circlePawn = boxAnchor.circlePawn
        crossPawn = boxAnchor.crossPawn
        
        circlePawn?.isEnabled = false
        crossPawn?.isEnabled = false
        
        winSign = boxAnchor.winSign
        winSign?.isEnabled = false
        
        arView.scene.anchors.append(boxAnchor)
        
//        if gameType == 0 {
//            randomPawn()
//        }
    }
    
    func randomPawn() {
        let number = Int.random(in: 0...1)
        if number == 0 {
            aiPawn = 0
        } else if number == 1 {
            aiPawn = 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isWon == false {
            guard let touchLocation = touches.first?.location(in: arView), let tappedEntity = arView.hitTest(touchLocation, query: .nearest, mask: .default).first?.entity else {
                return
            }
            
            currentEntity = tappedEntity
            
            if pawnTurn == 0 {
                if currentEntity?.findEntity(named: "crossPawn") == nil && currentEntity?.findEntity(named: "circlePawn") == nil{
                    let circlePawnCopy = (circlePawn?.clone(recursive: true))!
                    circlePawnCopy.isEnabled = true
                    currentEntity?.addChild(circlePawnCopy)
                    moveCount += 1
                    pawnTurn = 1
                    checkWin(currentEntity: currentEntity)
                    if isWon == true {
                        drawWinner(name: circlePawnCopy.name)
                    } else if isWon == false && moveCount == 9 {
                        drawWinner(name: "Draw")
                    } else if gameType == 0 {
                        makeRandomMove()
                    }
                }
            } else if pawnTurn == 1 {
                if currentEntity?.findEntity(named: "circlePawn") == nil && currentEntity?.findEntity(named: "crossPawn") == nil{
                    let crossPawnCopy = (crossPawn?.clone(recursive: true))!
                    crossPawnCopy.isEnabled = true
                    currentEntity?.addChild(crossPawnCopy)
                    moveCount += 1
                    pawnTurn = 0
                    checkWin(currentEntity: currentEntity)
                    if isWon == true {
                        drawWinner(name: crossPawnCopy.name)
                    } else if isWon == false && moveCount == 9 {
                        drawWinner(name: "Draw")
                    } else if gameType == 0 {
                        makeRandomMove()
                    }
                }
            }
        }
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("pawnTurn")
//        print(pawnTurn)
//        print("aiPawn")
//        print(aiPawn)
//        if gameType == 0 {
//            if pawnTurn == aiPawn {
//                var madeMove: Bool = false
//                while madeMove == false {
//                    if aiPawn == 0 {
//                            let boxNumber = "Box" + String(Int.random(in: 1...9))
//                            if currentEntity?.parent?.findEntity(named: boxNumber)?.findEntity(named: "circlePawn") == nil && currentEntity?.parent?.findEntity(named: boxNumber)?.findEntity(named: "crossPawn") == nil {
//                                let circlePawnCopy = (circlePawn?.clone(recursive: true))!
//                                circlePawnCopy.isEnabled = true
//                                currentEntity?.parent?.findEntity(named: boxNumber)?.addChild(circlePawnCopy)
//                                moveCount += 1
//                                pawnTurn = 1
//                                checkWin(currentEntity: currentEntity)
//                                if isWon == true {
//                                    drawWinner(name: circlePawnCopy.name)
//                                } else if isWon == false && moveCount == 9 {
//                                    drawWinner(name: "Draw")
//                                }
//                                madeMove = true
//                        }
//                    } else if aiPawn == 1 {
//                        let boxNumber = "Box" + String(Int.random(in: 1...9))
//                        if currentEntity?.parent?.findEntity(named: boxNumber)?.findEntity(named: "circlePawn") == nil && currentEntity?.parent?.findEntity(named: boxNumber)?.findEntity(named: "crossPawn") == nil {
//                            let crossPawnCopy = (crossPawn?.clone(recursive: true))!
//                            crossPawnCopy.isEnabled = true
//                            currentEntity?.parent?.findEntity(named: boxNumber)?.addChild(crossPawnCopy)
//                            moveCount += 1
//                            pawnTurn = 0
//                            checkWin(currentEntity: currentEntity)
//                            if isWon == true {
//                                drawWinner(name: crossPawnCopy.name)
//                            } else if isWon == false && moveCount == 9 {
//                                drawWinner(name: "Draw")
//                            }
//                            madeMove = true
//                        }
//                    }
//                }
//            }
//        }
//        print("pawnTurn")
//        print(pawnTurn)
//        print("aiPawn")
//        print(aiPawn)
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("pawnTurn")
//        print(pawnTurn)
//        print("aiPawn")
//        print(aiPawn)
//        if gameType == 0 {
//
//        }
//        print("pawnTurn")
//        print(pawnTurn)
//        print("aiPawn")
//        print(aiPawn)
//    }
    
    func makeRandomMove() {
        if pawnTurn == aiPawn {
            var madeMove: Bool = false
            while madeMove == false {
                if aiPawn == 0 {
                    let boxNumber = "Box" + String(Int.random(in: 1...9))
                    if currentEntity?.parent?.findEntity(named: boxNumber)?.findEntity(named: "circlePawn") == nil && currentEntity?.parent?.findEntity(named: boxNumber)?.findEntity(named: "crossPawn") == nil {
                        currentEntity = currentEntity?.parent?.findEntity(named: boxNumber)
                        let circlePawnCopy = (circlePawn?.clone(recursive: true))!
                        circlePawnCopy.isEnabled = true
                        currentEntity?.addChild(circlePawnCopy)
                        moveCount += 1
                        pawnTurn = 1
                        checkWin(currentEntity: currentEntity)
                        if isWon == true {
                            drawWinner(name: circlePawnCopy.name)
                        } else if isWon == false && moveCount == 9 {
                            drawWinner(name: "Draw")
                        }
                        madeMove = true
                    }
                } else if aiPawn == 1 {
                    let boxNumber = "Box" + String(Int.random(in: 1...9))
                    if currentEntity?.parent?.findEntity(named: boxNumber)?.findEntity(named: "circlePawn") == nil && currentEntity?.parent?.findEntity(named: boxNumber)?.findEntity(named: "crossPawn") == nil {
                        currentEntity = currentEntity?.parent?.findEntity(named: boxNumber)
                        let crossPawnCopy = (crossPawn?.clone(recursive: true))!
                        crossPawnCopy.isEnabled = true
                        currentEntity?.addChild(crossPawnCopy)
                        moveCount += 1
                        pawnTurn = 0
                        checkWin(currentEntity: currentEntity)
                        if isWon == true {
                            drawWinner(name: crossPawnCopy.name)
                        } else if isWon == false && moveCount == 9 {
                            drawWinner(name: "Draw")
                        }
                        madeMove = true
                    }
                }
            }
        }
    }
    
    func drawWinner(name: String) {
        let winSignCopy = winSign?.clone(recursive: true)
        let winSignTextEntity: Entity = (winSignCopy?.children[4].children[0].children[0])!
        var winSignComponent: ModelComponent = winSignTextEntity.components[ModelComponent] as! ModelComponent
        if name == "circlePawn" {
            winSignComponent.mesh = .generateText("Circle won!", extrusionDepth: 0.01, font: UIFont.systemFont(ofSize: 0.2), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping)
            winSignCopy?.children[4].children[0].children[0].components[Transform]?.translation = SIMD3<Float>(-0.4570729, -0.1103848, 0.0)
        } else if name == "crossPawn" {
            winSignComponent.mesh = .generateText("Cross won!", extrusionDepth: 0.01, font: UIFont.systemFont(ofSize: 0.2), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping)
            winSignCopy?.children[4].children[0].children[0].components[Transform]?.translation = SIMD3<Float>(-0.3970729, -0.1103848, 0.0)
        } else if name == "Draw" {
            winSignComponent.mesh = .generateText("It's a draw!", extrusionDepth: 0.01, font: UIFont.systemFont(ofSize: 0.2), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping)
            winSignCopy?.children[4].children[0].children[0].components[Transform]?.translation = SIMD3<Float>(-0.4570729, -0.1103848, 0.0)
        }
        winSignCopy?.children[4].children[0].children[0].components.set(winSignComponent)
        winSign?.parent?.addChild(winSignCopy!)
        winSignCopy?.isEnabled = true
    }
    
    func checkWin(currentEntity: Entity?) {
        let boxParent = currentEntity?.parent
        
        if currentEntity?.name == "Box1" {
            let pawnName = currentEntity?.children[1].name
            if boxParent?.findEntity(named: "Box2")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box3")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
            if boxParent?.findEntity(named: "Box4")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box7")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
            if boxParent?.findEntity(named: "Box5")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box9")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
        }
        
        if currentEntity?.name == "Box2" {
            let pawnName = currentEntity?.children[1].name
            if boxParent?.findEntity(named: "Box5")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box8")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
            if boxParent?.findEntity(named: "Box1")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box3")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
        }
        
        if currentEntity?.name == "Box3" {
            let pawnName = currentEntity?.children[1].name
            if boxParent?.findEntity(named: "Box2")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box1")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
            if boxParent?.findEntity(named: "Box5")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box7")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
            if boxParent?.findEntity(named: "Box6")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box9")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
        }
        
        if currentEntity?.name == "Box4" {
            let pawnName = currentEntity?.children[1].name
            if boxParent?.findEntity(named: "Box1")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box7")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
            if boxParent?.findEntity(named: "Box5")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box6")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
        }
        
        if currentEntity?.name == "Box5" {
            let pawnName = currentEntity?.children[1].name
            if boxParent?.findEntity(named: "Box1")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box9")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
            if boxParent?.findEntity(named: "Box3")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box7")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
            if boxParent?.findEntity(named: "Box4")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box6")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
            if boxParent?.findEntity(named: "Box2")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box8")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
        }
        
        if currentEntity?.name == "Box6" {
            let pawnName = currentEntity?.children[1].name
            if boxParent?.findEntity(named: "Box5")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box4")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
            if boxParent?.findEntity(named: "Box3")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box9")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
        }
        
        if currentEntity?.name == "Box7" {
            let pawnName = currentEntity?.children[1].name
            if boxParent?.findEntity(named: "Box1")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box4")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
            if boxParent?.findEntity(named: "Box8")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box9")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
            if boxParent?.findEntity(named: "Box5")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box3")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
        }
        
        if currentEntity?.name == "Box8" {
            let pawnName = currentEntity?.children[1].name
            if boxParent?.findEntity(named: "Box5")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box2")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
            if boxParent?.findEntity(named: "Box7")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box9")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
        }
        
        if currentEntity?.name == "Box9" {
            let pawnName = currentEntity?.children[1].name
            if boxParent?.findEntity(named: "Box8")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box7")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
            if boxParent?.findEntity(named: "Box6")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box3")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
            if boxParent?.findEntity(named: "Box5")?.findEntity(named: pawnName!) != nil && boxParent?.findEntity(named: "Box1")?.findEntity(named: pawnName!) != nil {
                isWon = true
            }
        }
    }
    
//        arView.scene.anchors.removeAll()
//        setupView()
//        pawnTurn = 0
//        moveCount = 0
//        isWon = false
//    }
    
    @IBAction func newGame(_ sender: Any) {
        arView.scene.anchors.removeAll()
        setupView()
        pawnTurn = 0
        moveCount = 0
        isWon = false
    }
}
