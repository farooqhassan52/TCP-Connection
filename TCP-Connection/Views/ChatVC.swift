//
//  ChatVC.swift
//  TCP-Connection
//
//  Created by Rana Farooq Hassan on 13/07/2021.
//

import Foundation
import UIKit
import Network

class ChatVC: UIViewController{

   
    @IBOutlet weak var imagesTableView: UITableView!
    var username = ""
    var imagePicker = UIImagePickerController()
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesTableView.delegate = self
        imagesTableView.dataSource = self
        
        if let connection = sharedConnection {
            // Take over being the connection delegate from the main view controller.
            connection.delegate = self
//            handleTurn(connection.initiatedConnection)
        }

    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
     
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
        self.discount()
    }
    
    func discount(){
        if let sharedConnection = sharedConnection {
            sharedConnection.cancel()
        }
        sharedConnection = nil
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.discount()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func attachmentBtnTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
             
               imagePicker.delegate = self
               imagePicker.sourceType = .savedPhotosAlbum
               imagePicker.allowsEditing = false

               present(imagePicker, animated: true, completion: nil)
           }
        
    }
   
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ChatVC: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as! imagesTableViewCell
    let message = messages[indexPath.row]
    cell.usernameLbl.text = message.recieverUsername
 
    let newString = message.message

    let newimg = convertBase64StringToImage(imageBase64String: newString)
 
    cell.img.image =  newimg

    return cell

  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
  
  func insertNewMessageCell(_ message: Message) {
    messages.append(message)
    let indexPath = IndexPath(row: messages.count - 1, section: 0)
    imagesTableView.beginUpdates()
    imagesTableView.insertRows(at: [indexPath], with: .bottom)
    imagesTableView.endUpdates()
    imagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
  }
}

extension ChatVC: UIImagePickerControllerDelegate , UINavigationControllerDelegate  {

    
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
      
        let encoded = convertImageToBase64String(img: image)
     

        imagePicker.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
           // self.chatRoom.send(message: encoded )
            let message = Message.init(message: encoded, messageSender: .ourself, username: "")
            sharedConnection?.sendImage(encoded)
            self.insertNewMessageCell(message)
        }
   }
}
        

extension ChatVC : PeerConnectionDelegate{
    func connectionReady() {
        // Ignore, since the chat was already started in the main view controller.
    }
    func displayAdvertiseError(_ error: NWError) {
        // Ignore, since the chat is already in progress.
    }

    func connectionFailed() {
        discount()
        self.dismiss(animated: true, completion: nil)
    }

    func receivedMessage(content: Data?, message: NWProtocolFramer.Message) {
        guard let content = content else {
            return
        }
        switch message.messageType {
        case .invalid:
            print("Received invalid message")
        case .text:
            handleTextMessage(content, message)
        case .image:
            handleImage(content, message)
        }
    }

    func handleTextMessage(_ content: Data, _ message: NWProtocolFramer.Message) {
        if let msg = String(data: content, encoding: .utf8) {
           print(msg)
        }
    }

    func handleImage(_ content: Data, _ message: NWProtocolFramer.Message) {
        
        if let str = String(data: content, encoding: .utf8) {
            let msg = Message.init(message: str, messageSender: .someoneElse, username: "")
            insertNewMessageCell(msg)
        }
    }
}

extension ChatVC {
func convertBase64StringToImage (imageBase64String:String) -> UIImage? {
    let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
    if imageData == nil
    {
        return nil
    }
    
    let image = UIImage(data: imageData!)
    return image
}
}
