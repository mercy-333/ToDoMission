//
//  PopUpViewController.swift
//  ToDoMission
//
//  Created by Konta on 2020/10/04.
//  Copyright © 2020 Masakazu Konno. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var gohoubiLabel: UILabel!
    @IBOutlet weak var clearLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    var rewardGetStr:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        gohoubiLabel.layer.borderWidth = 1.0
        gohoubiLabel.layer.borderColor = UIColor.black.cgColor
        gohoubiLabel.layer.cornerRadius = 10.0
        gohoubiLabel.clipsToBounds = true
        
        clearLabel.font = UIFont(name: "Mukasi-Mukasi", size: 30)
        
        backView.layer.cornerRadius = 10.0
        
        gohoubiLabel.text = rewardGetStr
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
