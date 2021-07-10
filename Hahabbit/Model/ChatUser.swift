//
//  ChatUser.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/30.
//

import Foundation
import MessageKit

struct ChatUser: SenderType, Equatable {
  var senderId: String
  var displayName: String
}
