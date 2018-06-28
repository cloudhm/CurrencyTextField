//
//  ViewController.swift
//  CurrencyTextField
//
//  Created by cloud on 2018/6/27.
//  Copyright © 2018 Yedao Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: CurrencyTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = "$0.00"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

