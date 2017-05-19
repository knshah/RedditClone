//
//  RCCommentCell.swift
//  RedditClone
//
//  Created by Karan Shah on 5/18/17.
//  Copyright © 2017 Karan Shah. All rights reserved.
//

import Foundation

private let MAX_REPLY_DEPTH = 6
private let VERTICLE_SEPERATOR_WIDTH = CGFloat(0.5)
private let HORIZONTAL_PADDING = CGFloat(20)

class RCCommentCell: UITableViewCell {
    
    var verticleSeperators = [UIView]()
    var authorLabel = UILabel()
    var bodyLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.authorLabel.font = UIFont.systemFont(ofSize: 12)
        self.authorLabel.textColor = UIColor.gray
        
        self.bodyLabel.font = UIFont.systemFont(ofSize: 14)
        self.bodyLabel.textColor = UIColor.black
        self.bodyLabel.numberOfLines = 0
        
        self.contentView.addSubview(self.authorLabel)
        self.contentView.addSubview(self.bodyLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(comment: RCCommentModel) {
        let depth = min(MAX_REPLY_DEPTH, comment.depth)
        self.verticleSeperators.forEach { view in
            view.removeFromSuperview()
        }
        self.verticleSeperators.removeAll()
        var numOfSeperator = 0
        while numOfSeperator < depth {
            let seperatorView = UIView()
            seperatorView.backgroundColor = UIColor.lightGray
            self.contentView.addSubview(seperatorView)
            self.verticleSeperators.append(seperatorView)
            numOfSeperator += 1
        }
        
        self.authorLabel.text = comment.author
        self.authorLabel.sizeToFit()
        
        self.bodyLabel.text = comment.body
        let maxLabelWidth = self.contentView.frame.width - CGFloat(2*HORIZONTAL_PADDING) - CGFloat(depth)*HORIZONTAL_PADDING
        let maxLabelHeight = ceilf(Float(NSString(string: comment.body).boundingRect(with: CGSize(width: maxLabelWidth,
                                                                                                  height: CGFloat(Float.greatestFiniteMagnitude)),
                                                                                     options: .usesLineFragmentOrigin,
                                                                                     attributes: [NSFontAttributeName : self.bodyLabel.font],
                                                                                     context: nil).size.height))
        self.bodyLabel.frame.size = CGSize(width: maxLabelWidth, height: CGFloat(maxLabelHeight))
        self.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        
        var prevSeperatorView: UIView? = nil
        self.verticleSeperators.forEach { view in
            view.snp.remakeConstraints({ make in
                _ = make.top.equalTo(self.contentView)
                _ = make.bottom.equalTo(self.contentView)
                if prevSeperatorView == nil {
                    _ = make.left.equalTo(self.contentView).offset(HORIZONTAL_PADDING)
                }
                else {
                    _ = make.left.equalTo(prevSeperatorView!.snp.right).offset(HORIZONTAL_PADDING)
                }
                _ = make.width.equalTo(VERTICLE_SEPERATOR_WIDTH)
            })
            prevSeperatorView = view
        }
        
        self.authorLabel.snp.remakeConstraints { make in
            _ = make.top.equalTo(self.contentView).offset(10)
            if prevSeperatorView == nil {
                _ = make.left.equalTo(self.contentView).offset(HORIZONTAL_PADDING)
            }
            else {
                _ = make.left.equalTo(prevSeperatorView!.snp.right).offset(HORIZONTAL_PADDING)
            }
            _ = make.width.equalTo(self.authorLabel.frame.width)
            _ = make.height.equalTo(self.authorLabel.frame.height)
        }
        
        self.bodyLabel.snp.remakeConstraints { make in
            _ = make.top.equalTo(self.authorLabel.snp.bottom).offset(5)
            _ = make.left.equalTo(self.authorLabel)
            _ = make.bottom.equalTo(self.contentView).offset(-20)
            _ = make.width.equalTo(self.bodyLabel.frame.width)
            _ = make.height.equalTo(self.bodyLabel.frame.height).priority(999)
        }
        
        super.updateConstraints()
    }
}
