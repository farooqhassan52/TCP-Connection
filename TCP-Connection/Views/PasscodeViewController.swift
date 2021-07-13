//
//  PasscodeViewController.swift
//  TCP-Connection
//
//  Created by Rana Farooq Hassan on 12/07/2021.
//

import Foundation
import UIKit
import Network

class PasscodeViewController: UITableViewController {

    @IBOutlet weak var passcodeField: UITextField!
    var browseResult: NWBrowser.Result?
    var peerListViewController: PeerListViewController?

    var hasJoinedChat = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if let browseResult = browseResult,
            case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = browseResult.endpoint {
            title = "Join \(name)"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if hasJoinedChat {
            navigationController?.popToRootViewController(animated: false)
            hasJoinedChat = false
        }
    }

    func joinPressed() {
        hasJoinedChat = true
        if let passcode = passcodeField.text,
            let browseResult = browseResult,
            let peerListViewController = peerListViewController {
            sharedConnection = PeerConnection(endpoint: browseResult.endpoint,
                                              interface: browseResult.interfaces.first,
                                              passcode: passcode,
                                              delegate: peerListViewController)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            joinPressed()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
