//
//  MainViewController.swift
//  Rocket List
//
//  Created by Mada Bramantyo on 14/02/23.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = HomeViewController()

        view.addSubview(vc.view)
        addChild(vc)
        vc.didMove(toParent: self)
    }


}

