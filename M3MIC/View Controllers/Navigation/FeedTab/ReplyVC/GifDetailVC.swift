//
//  GifDetailVC.swift
//  M3MIC
//
//  Created by Brian Hersh on 7/15/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

protocol GifDetailVCDelegate: class {
    func reloadTableView()
}

class GifDetailVC: UIViewController {
    
    var post: Post?
    
    @IBOutlet weak var gifTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewIfNeeded()
        viewSetup()
    }
}

extension GifDetailVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ReplyController.shared.replies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gifCell") as? GifDetailCell
        let reply = ReplyController.shared.replies[indexPath.row]
        cell?.replyImage.image = reply.image
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}

// MARK: - Navigation
extension GifDetailVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateReplyVC" {
            let indexPath = gifTableView.indexPathForSelectedRow
            let destinationVC = segue.destination as? CreateReplyVC
            let reply = ReplyController.shared.replies[(indexPath?.row)!]
            destinationVC?.reply = reply
            
            let post = self.post
            destinationVC?.post = post
        }
    }
}
