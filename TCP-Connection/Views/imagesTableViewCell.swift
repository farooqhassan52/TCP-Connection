//
//  imagesTableViewCell.swift
//  TCP-Connection
//
//  Created by Rana Farooq Hassan on 13/07/2021.
//

import Foundation
import UIKit

enum MessageSender {
  case ourself
  case someoneElse
}
class imagesTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLbl: UILabel!
    var messageSender: MessageSender = .ourself
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func apply(message: Message) {
      usernameLbl.text = message.recieverUsername
     // messageLabel.text = message.message
      messageSender = message.messageSender
      setNeedsLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
