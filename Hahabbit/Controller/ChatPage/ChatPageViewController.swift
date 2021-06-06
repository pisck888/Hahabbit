//
//  ChatPageViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/30.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase
import Kingfisher
import PopupDialog

class ChatPageViewController: MessagesViewController {

  private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd a HH:mm"
    return formatter
  }()
  let viewModel = ProfileViewModel()
  var habitID: String?
  var members: [String]?
  var currentUser: User? {
    didSet {
      loadChat()
    }
  }
  var messages: [Message] = [] {
    didSet {
      messagesCollectionView.reloadData()
      messagesCollectionView.scrollToLastItem(animated: true)
    }
  }
  let db = Firestore.firestore()
  override func viewDidLoad() {
    super.viewDidLoad()
    messagesCollectionView.backgroundColor = .systemGray6

    viewModel.currentUserViewModel.bind { user in
      self.currentUser = user
    }

    viewModel.tappedUserViewModel.bind { user in
      if let user = user {
        self.showProfilePopup(user: user)
      }
    }

    viewModel.fetchCurrentUser()

    setupChatViewAndInputBar()
  }

  override func viewDidAppear(_ animated: Bool) {
    loadChat()
  }


  func setupChatViewAndInputBar() {
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
    scrollsToLastItemOnKeyboardBeginsEditing = true
    maintainPositionOnKeyboardFrameChanged = true
    messageInputBar.delegate = self
    messagesCollectionView.messageCellDelegate = self
    configureInputBarItems()
  }

  func loadChat() {
    guard let id = habitID else { return }
    db.collection("chats")
      .whereField("id", isEqualTo: id)
      .getDocuments { querySnapshot, error in
        if let err = error {
          print(err)
        } else {
          guard let queryCount = querySnapshot?.documents.count else {
            return
          }
          if queryCount == 0 {
            self.createNewChat()
          } else {
            self.db.collection("chats")
              .document(id)
              .collection("thread")
              .order(by: "created", descending: false)
              .addSnapshotListener { querySnapshot, error in
                if let err = error {
                  print(err)
                } else {
                  guard let documents = querySnapshot?.documents else { return }
                  let messagesArray = documents.compactMap {
                    return Message(dictionary: $0.data())
                  }
                  self.messages = messagesArray.filter {
                    !((self.currentUser?.blacklist.contains($0.senderID))!)
                  }
                }
              }
          }
        }
      }
  }

  func createNewChat() {
    guard let id = habitID else { return }
    let data: [String: Any] = [
      "id": id,
      "members": members ?? []
    ]
    db.collection("chats")
      .document(id)
      .setData(data, merge: true)
  }

  private func save(_ message: Message) {
    guard let id = habitID else { return }
    // Preparing the data as per our firestore collection
    let data: [String: Any] = [
      "content": message.content,
      "created": message.created,
      "id": message.id,
      "senderID": message.senderID,
      "senderName": message.senderName
    ]
    // Writing it to the thread using the saved document reference we saved in load chat function
    db.collection("chats")
      .document(id)
      .collection("thread")
      .addDocument(data: data) { error in
        if let error = error {
          print("Error Sending message: \(error)")
          return
        }
      }
  }

  func configureInputBarItems() {
    messageInputBar.sendButton.image = UIImage(named: "arrowCircleRight")
    messageInputBar.sendButton.title = nil
  }
}

extension ChatPageViewController: MessagesDataSource {

  func currentSender() -> SenderType {
    ChatUser(senderId: currentUser?.id ?? "", displayName: currentUser?.name ?? "")
  }

  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    messages[indexPath.section]

  }

  func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
    messages.count
  }

  func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
    let dateString = formatter.string(from: message.sentDate)
    return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
  }

  func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
    NSAttributedString(string: message.sender.displayName, attributes: [.font: UIFont.systemFont(ofSize: 12)])
  }


}

extension ChatPageViewController: MessagesLayoutDelegate {
  func messageTopLabelHeight(
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView
  ) -> CGFloat {
    18
  }

  func messageBottomLabelHeight(
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView
  ) -> CGFloat {
    18
  }
}

extension ChatPageViewController: MessagesDisplayDelegate {
  // set avatar
  func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    db.collection("users")
      .whereField("id", isEqualTo: message.sender.senderId)
      .getDocuments { querySnapshot, error in
        guard let user = querySnapshot?.documents[0].data() else { return }
        guard let url = URL(string: user["image"] as? String ?? "") else { return }
        avatarView.kf.indicatorType = .activity
        avatarView.kf.setImage(with: url)
      }
  }

  // set bubbleTail
  func messageStyle(
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView
  ) -> MessageStyle {
    let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
    return .bubbleTail(tail, .curved)
  }

  func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
    switch message.sender.senderId {

    case UserManager.shared.currentUser:
      return .darkGray
    default:
      return .white
    }
  }

}

extension ChatPageViewController: InputBarAccessoryViewDelegate {
  func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    guard let user = currentUser else { return }
    let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: user.id, senderName: user.name)
    // calling function to insert and save message
    save(message)
    inputBar.inputTextView.text = ""
    inputBar.inputTextView.placeholder = "Aa"
  }
}


extension ChatPageViewController: MessageCellDelegate {
  @objc(didTapBackgroundIn:) func didTapBackground(in cell: MessageCollectionViewCell) {
    messageInputBar.inputTextView.resignFirstResponder()
  }

  func didTapAvatar(in cell: MessageCollectionViewCell) {

    let indexPath = messagesCollectionView.indexPath(for: cell)!
    let message = messageForItem(at: indexPath, in: messagesCollectionView)
    print(message.sender.senderId)

    viewModel.fetchTappedUser(id: message.sender.senderId)
  }

  func showProfilePopup(user: User) {
    let url = URL(string: user.image)
    let imageView = UIImageView()
    let placeholder = UIImage(named: "avatar")
    imageView.kf.indicatorType = .activity
    imageView.kf.setImage(with: url, placeholder: placeholder) { result in
      switch result {
      case .success(let value):
        let popup = PopupDialog(
          title: user.name,
          message: user.title,
          image: value.image
        )
        let containerAppearance = PopupDialogContainerView.appearance()

        let buttonOne = DestructiveButton(title: "封鎖") {
          UserManager.shared.blockUser(id: user.id)
        }

        let buttonTwo = CancelButton(title: "Close") {
        }
        if user.id != UserManager.shared.currentUser {
          popup.addButtons([buttonOne, buttonTwo])
        } else {
          popup.addButton(buttonTwo)
        }
        popup.transitionStyle = .zoomIn
        containerAppearance.cornerRadius = 10

        // Present dialog
        self.present(popup, animated: true, completion: nil)

      case .failure(let error):
        print(error.errorDescription as Any)
      }
    }
  }
}
