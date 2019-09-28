//
//  FTSampleTableViewController.swift
//  FTMobileCoreSample
//
//  Created by Praveen Prabhakar on 20/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

class FTSampleTableViewController: FTBaseViewController, FTTableViewControllerProtocal {
    
    @IBOutlet var headerView: UIView!
    
    var tableStyle: UITableView.Style {
        return .grouped
    }
    
    override func loadView() {
        super.loadView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = headerView
        headerView.setNeedsDisplay()
    }
}

extension FTSampleTableViewController: UITableViewDelegate, UITableViewDataSource {
    // For calculating TableCell height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "FT.kCellIdentifier")
        cell.textLabel?.text = indexPath.description
        cell.textLabel?.textColor = .blue
        return cell
    }
}
