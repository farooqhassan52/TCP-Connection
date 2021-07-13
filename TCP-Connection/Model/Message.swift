//
//  Message.swift
//  TCP-Connection
//
//  Created by Rana Farooq Hassan on 13/07/2021.
//

import Foundation

struct Message {
  var message: String = ""
  let recieverUsername: String
  let messageSender: MessageSender
  
  init(message: String, messageSender: MessageSender, username: String) {
    self.message = message
    self.messageSender = messageSender
    self.recieverUsername = username
  }
}
