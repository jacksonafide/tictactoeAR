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
    }
    
    func randomPawn() {
        let number = Int.random(in: 0...1)
        if number == 0 {
            aiPawn = 0
        } else if number == 1 {
            aiPawn = 1
        }
    }
    
    func makeMove(entityType: String) {
        var entityCopy: Entity? = nil
        
        if entityType == "circlePawn" {
            entityCopy = (circlePawn?.clone(recursive: true))!
        } else if entityType == "crossPawn" {
            entityCopy = (crossPawn?.clone(recursive: true))!
        }
        
        if entityCopy != nil {
            entityCopy?.isEnabled = true
            currentEntity?.addChild(entityCopy!)
            moveCount += 1
            if entityType == "circlePawn" {
                pawnTurn = 1
            } else if entityType == "crossPawn" {
                pawnTurn = 0
            }
            checkWin(entityType: entityType)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isWon == false {
            guard let touchLocation = touches.first?.location(in: arView), let tappedEntity = arView.hitTest(touchLocation, query: .nearest, mask: .default).first?.entity else {
                return
            }
            
            currentEntity = tappedEntity
            
            if pawnTurn == 0 {
                if currentEntity?.findEntity(named: "crossPawn") == nil && currentEntity?.findEntity(named: "circlePawn") == nil {
                    makeMove(entityType: "circlePawn")
                    if isWon == false && gameType == 0 {
                        makeRandomMove()
                    }
                }
            } else if pawnTurn == 1 {
                if currentEntity?.findEntity(named: "circlePawn") == nil && currentEntity?.findEntity(named: "crossPawn") == nil {
                    makeMove(entityType: "crossPawn")
                    if isWon == false && gameType == 0 {
                        makeRandomMove()
                    }
                }
            }
        }
    }
    
    func makeRandomMove() {
        if pawnTurn == aiPawn && moveCount != 9 {
            var madeMove: Bool = false
            while madeMove == false {
                if aiPawn == 0 {
                    let boxNumber = "Box" + String(Int.random(in: 1...9))
                    if currentEntity?.parent?.findEntity(named: boxNumber)?.findEntity(named: "circlePawn") == nil && currentEntity?.parent?.findEntity(named: boxNumber)?.findEntity(named: "crossPawn") == nil {
                        currentEntity = currentEntity?.parent?.findEntity(named: boxNumber)
                        makeMove(entityType: "circlePawn")
                        madeMove = true
                    }
                } else if aiPawn == 1 {
                    let boxNumber = "Box" + String(Int.random(in: 1...9))
                    if currentEntity?.parent?.findEntity(named: boxNumber)?.findEntity(named: "circlePawn") == nil && currentEntity?.parent?.findEntity(named: boxNumber)?.findEntity(named: "crossPawn") == nil {
                        currentEntity = currentEntity?.parent?.findEntity(named: boxNumber)
                        makeMove(entityType: "crossPawn")
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
            winSignCopy?.children[4].children[0].children[0].components[Transform]?.translation = SIMD3<Float>(-0.4470729, -0.1103848, 0.0)
        } else if name == "draw" {
            winSignComponent.mesh = .generateText("It's a draw!", extrusionDepth: 0.01, font: UIFont.systemFont(ofSize: 0.2), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping)
            winSignCopy?.children[4].children[0].children[0].components[Transform]?.translation = SIMD3<Float>(-0.4570729, -0.1103848, 0.0)
        }
        winSignCopy?.children[4].children[0].children[0].components.set(winSignComponent)
        winSign?.parent?.addChild(winSignCopy!)
        winSignCopy?.isEnabled = true
    }
    
    func checkWin(entityType: String) {
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
        
        if isWon == true {
            drawWinner(name: entityType)
        } else if moveCount == 9 {
            drawWinner(name: "draw")
        }
    }
    
    @IBAction func newGame(_ sender: Any) {
        arView.scene.anchors.removeAll()
        setupView()
        pawnTurn = 0
        moveCount = 0
        isWon = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
