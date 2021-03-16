//
//  ViewController.swift
//  ticTacToeAR
//
//  Created by Jacek Chojnacki on 15/03/2021.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    @IBOutlet weak var newGameButton: UIButton!
    
    var currentEntity: Entity?
    var blackPawn: Entity?
    var redPawn: Entity?
    var colorTurn: Int = 0
    var winSign: Entity?
    var isWon: Bool = false
    var moveCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        let boxAnchor = try! Experience.loadBox()
        
        blackPawn = boxAnchor.blackPawn
        redPawn = boxAnchor.redPawn
        
        blackPawn?.isEnabled = false
        redPawn?.isEnabled = false
        
        winSign = boxAnchor.winSign
        winSign?.isEnabled = false
        
        arView.scene.anchors.append(boxAnchor)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isWon == false {
            guard let touchLocation = touches.first?.location(in: arView), let tappedEntity = arView.hitTest(touchLocation, query: .nearest, mask: .default).first?.entity else {
                return
            }
            
            currentEntity = tappedEntity
            
            if colorTurn == 0 {
                if currentEntity?.findEntity(named: "redPawn") == nil && currentEntity?.findEntity(named: "blackPawn") == nil{
                    let blackPawnCopy = (blackPawn?.clone(recursive: true))!
                    blackPawnCopy.isEnabled = true
                    currentEntity?.addChild(blackPawnCopy)
                    moveCount += 1
                    colorTurn = 1
                    checkWin(currentEntity: currentEntity)
                    if isWon == true {
                        drawWinner(name: blackPawnCopy.name)
                    } else if isWon == false && moveCount == 9 {
                        drawWinner(name: "Draw")
                    }
                }
            } else if colorTurn == 1 {
                if currentEntity?.findEntity(named: "blackPawn") == nil && currentEntity?.findEntity(named: "redPawn") == nil{
                    let redPawnCopy = (redPawn?.clone(recursive: true))!
                    redPawnCopy.isEnabled = true
                    currentEntity?.addChild(redPawnCopy)
                    moveCount += 1
                    colorTurn = 0
                    checkWin(currentEntity: currentEntity)
                    if isWon == true {
                        drawWinner(name: redPawnCopy.name)
                    } else if isWon == false && moveCount == 9 {
                        drawWinner(name: "Draw")
                    }
                }
            }
        }
    }
    
    func drawWinner(name: String) {
        let winSignCopy = winSign?.clone(recursive: true)
        let winSignTextEntity: Entity = (winSignCopy?.children[4].children[0].children[0])!
        var winSignComponent: ModelComponent = winSignTextEntity.components[ModelComponent] as! ModelComponent
        if name == "blackPawn" {
            winSignComponent.mesh = .generateText("Black won!", extrusionDepth: 0.01, font: UIFont.systemFont(ofSize: 0.2), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping)
            winSignCopy?.children[4].children[0].children[0].components[Transform]?.translation = SIMD3<Float>(-0.4570729, -0.1103848, 0.0)
        } else if name == "redPawn" {
            winSignComponent.mesh = .generateText("Red won!", extrusionDepth: 0.01, font: UIFont.systemFont(ofSize: 0.2), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping)
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
    
    @IBAction func newGame(_ sender: UIButton) {
        arView.scene.anchors.removeAll()
        setupView()
        colorTurn = 0
        moveCount = 0
        isWon = false
    }
}
