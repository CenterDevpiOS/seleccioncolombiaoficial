//
//  SCMenuViewController.swift
//  Seleccion Colombia App
//
//  Created by orlando arzola on 6/11/17.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import UIKit

class SCMenuViewController: UIViewController {

    @IBOutlet weak var menuImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        self.menuImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        
        self.menuImageView.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closeMenu() {
        dismiss(animated: true, completion: nil)
        
    }
    
}
