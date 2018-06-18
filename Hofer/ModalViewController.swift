//
//  ModalViewController.swift
//  HalfModalPresentationController
//
//  Created by Martin Normark on 17/01/16.
//  Copyright © 2016 martinnormark. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController, HalfModalPresentable, UITableViewDelegate, UITableViewDataSource {
    
    var node:Node!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func maximizeButtonTapped(sender: AnyObject) {
        maximizeToFullScreen()
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        if let delegate = navigationController?.transitioningDelegate as? HalfModalTransitioningDelegate {
            delegate.interactiveDismiss = false
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = node.title.capitalized
        tableView.delegate = self
        tableView.dataSource = self
        
//        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return node.values?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
//        cell.
        
        cell.textLabel?.text = node.values![indexPath.row].split(separator: ":").first!.trimmingCharacters(in: .whitespaces)
        
        cell.detailTextLabel?.text = node.values![indexPath.row].split(separator: ":").last!.trimmingCharacters(in: .whitespaces)
        
        return cell
    }
    
    
}
