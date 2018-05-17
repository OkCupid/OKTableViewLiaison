//
//  ViewController.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 04/11/2018.
//  Copyright © 2018 OkCupid. All rights reserved.
//

import UIKit
import OKTableViewLiaison

class ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private let liaison = OKTableViewLiaison()
    private let refreshControl = UIRefreshControl()
    
    private var initialSections: [OKAnyTableViewSection] {
        return Post.initialPosts()
            .map(section(for:))
    }
    
    private func section(for post: Post) -> PostTableViewSection {
        
        let rows: [OKAnyTableViewRow] = [ImageContentTableViewRow(image: post.content, width: tableView.frame.width),
                                         ActionButtonsTableViewRow(),
                                         TextTableViewRow.likesRow(numberOfLikes: post.numberOfLikes),
                                         TextTableViewRow.captionRow(user: post.user.username, caption: post.caption),
                                         TextTableViewRow.commentRow(commentCount: post.numberOfComments),
                                         TextTableViewRow.timeRow(numberOfSeconds: post.timePosted)]
        
        return PostTableViewSection(user: post.user, rows: rows)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refreshSections), for: .valueChanged)
        tableView.addSubview(refreshControl)

        liaison.paginationDelegate = self
        liaison.liaise(tableView: tableView)
        
        liaison.append(sections: initialSections)
    }
    
    @objc private func refreshSections() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.liaison.clearSections(replacedBy: self.initialSections, animated: false)
            self.refreshControl.endRefreshing()
        }
    }
    
}

extension ViewController: OKTableViewLiaisonPaginationDelegate {
    
    func isPaginationEnabled() -> Bool {
        return liaison.sections.count < 8
    }
    
    func paginationStarted(indexPath: IndexPath) {
        
        liaison.scroll(to: indexPath)
        
        let sections = Post.paginatedPosts()
            .map(section(for:))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.liaison.append(sections: sections)
        }
    }
    
    func paginationEnded(indexPath: IndexPath) {
        
    }
}
