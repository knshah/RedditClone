//
//  RCListingViewController.swift
//  RedditClone
//
//  Created by Karan Shah on 5/17/17.
//  Copyright © 2017 Karan Shah. All rights reserved.
//

import Foundation
import SnapKit

class RCListingViewController: UITableViewController {
    
    let listingCellIdentifier = "listingCell"
    let listingService = RCListingService()
    var currentListingsCount = 0
    
    init() {
        super.init(style: .plain)
        self.title = "All Listings"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150
        self.tableView.tableFooterView = RCTableFooterView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 40))
        
        // register cells
        self.tableView.register(RCListingCell.self, forCellReuseIdentifier: self.listingCellIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getNextListings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Private methods
    private func getNextListings() {
        self.currentListingsCount = self.listingService.listings.count
        self.listingService.getNextListing(ofKind: "hot") { (success, errorMessage) in
            if success {
                self.tableView.reloadData()
            }
            else {
                // show error
                let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
                self.navigationController?.show(alert, sender: nil)
            }
            
            if self.currentListingsCount == self.listingService.listings.count {
                self.tableView.tableFooterView = nil
            }
        }
    }
    
    // MARK: - UITableView data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listingService.listings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.listingCellIdentifier) as! RCListingCell
        cell.configure(listing: self.listingService.listings[indexPath.row])
        return cell
    }
    
    // MARK: UITableView delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.listingService.listings.count - 1 {
            self.getNextListings()
        }
    }
}

class RCTableFooterView: UIView {
    
    let label = UILabel()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let leftDummyView = UIView(frame: .zero)
    let rightDummyView = UIView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.label.font = UIFont.systemFont(ofSize: 14)
        self.label.textColor = UIColor.gray
        self.label.text = "Loading ..."
        self.label.sizeToFit()
        
        self.activityIndicator.startAnimating()
        
        self.addSubview(self.label)
        self.addSubview(self.activityIndicator)
        self.addSubview(self.leftDummyView)
        self.addSubview(self.rightDummyView)
        
        self.configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        self.activityIndicator.snp.makeConstraints { make in
            _ = make.centerY.equalTo(self)
            _ = make.width.equalTo(self.activityIndicator.frame.width)
            _ = make.height.equalTo(self.activityIndicator.frame.height)
        }
        
        self.label.snp.makeConstraints { make in
            _ = make.left.equalTo(self.activityIndicator.snp.right).offset(10)
            _ = make.centerY.equalTo(self)
            _ = make.width.equalTo(self.label.frame.width)
            _ = make.height.equalTo(self.label.frame.height)
        }
        
        self.leftDummyView.snp.makeConstraints { make in
            _ = make.left.equalTo(self)
            _ = make.right.equalTo(self.activityIndicator.snp.left)
            _ = make.width.equalTo(self.rightDummyView)
        }
        
        self.rightDummyView.snp.makeConstraints { make in
            _ = make.right.equalTo(self)
            _ = make.left.equalTo(self.label.snp.right)
            _ = make.width.equalTo(self.leftDummyView)
        }
    }
}
