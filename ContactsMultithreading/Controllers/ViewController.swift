//
//  ViewController.swift
//  ContactsMultithreading
//
//  Created by user on 25.03.2021.
//

import UIKit

class ViewController: UIViewController {
    private var concurrencyOption: ConcurrencyOption = ConcurrencyOption.operationQueue
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func makeGCD(_ sender: Any) {
        concurrencyOption = ConcurrencyOption.grandCentralDispatch
    }
    
    @IBAction func makeOperation(_ sender: Any) {
        concurrencyOption = ConcurrencyOption.operationQueue
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let viewController = segue.destination as? TableViewController else {return }
        if segue.identifier == "gcdSegue" {
            viewController.concurrencyOption = concurrencyOption
        }
        else if segue.identifier == "operationSegue" {
            viewController.concurrencyOption = concurrencyOption
        }
    }
}

