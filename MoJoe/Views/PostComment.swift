//
//  PostComment.swift
//  MoJoe
//
//  Created by Daniel Grant on 9/11/19.
//  Copyright © 2019 Daniel Grant. All rights reserved.
//

import UIKit

class PostComment: UITableViewCell {

    @IBOutlet private weak var commentLabel: UILabel!
    

    func setCommentCell(comment: Comment) {
        commentLabel.text = comment.comment
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

}
