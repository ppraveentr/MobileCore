//
//  FTSampleTableViewController.swift
//  MobileCoreSample
//
//  Created by Praveen Prabhakar on 20/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

class SampleTableViewController: UIViewController, TableViewControllerProtocol {
    
    @IBOutlet var footerView: UIView!
    
    var tableStyle: UITableView.Style {
        .plain
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup MobileCore
        setupCoreView()
        // Setup TableView
        setupTableView()
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.setTableHeaderView(view: footerView)
        footerView.setNeedsDisplay()
        footerView.layoutIfNeeded()
    }
}

extension SampleTableViewController: UITableViewDelegate, UITableViewDataSource {
    // For calculating TableCell height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "FT.kCellIdentifier")
        cell.textLabel?.text = indexPath.description
        cell.textLabel?.textColor = .blue
        return cell
    }
}
