//
//  ViewController.swift
//  ticTacToeAR
//
//  Created by Jacek Chojnacki on 20/03/2021.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ARViewController {
            let arVC = segue.destination as? ARViewController
            if segue.identifier == "aiSegue" {
                arVC?.gameType = 0
            } else if segue.identifier == "playerSegue" {
                arVC?.gameType = 1
            }
        }
    }
}
