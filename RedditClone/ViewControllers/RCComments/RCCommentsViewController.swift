//
//  RCCommentsViewController.swift
//  RedditClone
//
//  Created by Karan Shah on 5/18/17.
//  Copyright © 2017 Karan Shah. All rights reserved.
//

import Foundation

class RCCommentsViewController: UITableViewController {
    
    let commentsService = RCListingCommentsService()
    let commentCellIdentifier = "commentCell"
    let listingArticle: RCListingModel
    
    init(listing: RCListingModel) {
        listingArticle = listing
        super.init(style: .plain)
        self.title = "Comments"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        // register cells
        self.tableView.register(RCCommentCell.self, forCellReuseIdentifier: self.commentCellIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getComments()
    }
    
    // MARK:  Private methods
    private func getComments() {
        self.commentsService.getComments(subreddit: listingArticle.subreddit, article: listingArticle.articleId) { (success, errorMessage) in
            if success {
                self.tableView.reloadData()
            }
            else {
                // show error
                let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
                self.navigationController?.show(alert, sender: nil)
            }
        }
    }
    
    // MARK: - UITableView data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentsService.comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.commentCellIdentifier) as! RCCommentCell
        cell.configure(comment: self.commentsService.comments[indexPath.row])
        return cell
    }
    
    // MARK: UITableView delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
