//
//  GarmentAddViewController.swift
//  LululemonAssignment
//
//  Created by Dinesh Danda on 4/14/20.
//  Copyright © 2020 Dinesh Danda. All rights reserved.
//

import UIKit

protocol AddGarment {
    func addGarment(name: String)
}

class GarmentAddViewController: UIViewController {
    
    @IBOutlet weak var garmentTF: UITextField!
    var delegate: AddGarment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func didPressSaveButton(_ sender: UIButton) {
        if garmentTF.text != "" {
            delegate?.addGarment(name: garmentTF.text!)
            navigationController?.popViewController(animated: true)
        }
    }
}
