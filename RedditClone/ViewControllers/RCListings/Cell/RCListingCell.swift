//
//  RCListingCell.swift
//  RedditClone
//
//  Created by Karan Shah on 5/17/17.
//  Copyright © 2017 Karan Shah. All rights reserved.
//

import Foundation

private let HORIZONTAL_PADDING = CGFloat(20)
private let VERTICAL_PADDING = CGFloat(20)

class RCListingCell: UITableViewCell {
    
    let thumbnailImageView = UIImageView(frame: .zero)
    let title = UILabel()
    let seperatorView = UIView(frame: .zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.title.numberOfLines = 0
        self.title.font = UIFont.systemFont(ofSize: 15)
        self.title.backgroundColor = UIColor.clear
        self.title.textColor = UIColor.black
        
        self.thumbnailImageView.contentMode = .scaleAspectFill
        self.thumbnailImageView.clipsToBounds = true
        
        self.seperatorView.backgroundColor = UIColor.gray
        
        self.contentView.addSubview(self.title)
        self.contentView.addSubview(self.thumbnailImageView)
        self.contentView.addSubview(self.seperatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(listing: RCListingModel) {
        self.thumbnailImageView.frame.size = CGSize(width: listing.thumbnailWidth, height: listing.thumbnailHeight)
        if listing.thumbnailImageURL() != nil {
            self.thumbnailImageView.setImageWith(listing.thumbnailImageURL()!)
        }
        self.title.text = listing.title
        
        self.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        let text = NSString(string: self.title.text!)
        let maxLabelWidth = self.contentView.frame.width - 3*HORIZONTAL_PADDING - self.thumbnailImageView.frame.width
        let maxLabelHeight = ceilf(Float(text.boundingRect(with: CGSize(width: maxLabelWidth,
                                                                        height: CGFloat(Float.greatestFiniteMagnitude)),
                                                           options: .usesLineFragmentOrigin,
                                                           attributes: [NSFontAttributeName : self.title.font],
                                                           context: nil).size.height))
        
        self.thumbnailImageView.snp.remakeConstraints { make in
            _ = make.top.equalTo(self.contentView).offset(VERTICAL_PADDING)
            _ = make.right.equalTo(self.contentView).offset(-HORIZONTAL_PADDING)
            _ = make.width.equalTo(self.thumbnailImageView.frame.width)
            _ = make.height.equalTo(self.thumbnailImageView.frame.height).priority(999)
            if CGFloat(maxLabelHeight) < self.thumbnailImageView.frame.height {
                _ = make.bottom.equalTo(self.contentView).offset(-VERTICAL_PADDING)
            }
        }
        
        self.title.snp.remakeConstraints { make in
            _ = make.top.equalTo(self.thumbnailImageView)
            _ = make.right.equalTo(self.thumbnailImageView.snp.left).offset(-HORIZONTAL_PADDING)
            _ = make.width.equalTo(maxLabelWidth)
            _ = make.height.equalTo(maxLabelHeight).priority(999)
            if CGFloat(maxLabelHeight) > self.thumbnailImageView.frame.height {
                _ = make.bottom.equalTo(self.contentView).offset(-VERTICAL_PADDING)
            }
        }
        
        self.seperatorView.snp.remakeConstraints { make in
            _ = make.left.equalTo(self.contentView)
            _ = make.right.equalTo(self.contentView)
            _ = make.bottom.equalTo(self.contentView)
            _ = make.height.equalTo(0.5)
        }
        
        super.updateConstraints()
    }
}
