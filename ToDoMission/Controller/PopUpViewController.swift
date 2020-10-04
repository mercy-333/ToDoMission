//
//  PopUpViewController.swift
//  ToDoMission
//
//  Created by Konta on 2020/10/04.
//  Copyright © 2020 Masakazu Konno. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    



    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
