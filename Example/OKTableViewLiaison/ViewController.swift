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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refreshSections), for: .valueChanged)
        tableView.addSubview(refreshControl)

        liaison.paginationDelegate = self
        liaison.liaise(tableView: tableView)
        
        let sections = Post.randomPosts()
            .map { return PostTableViewSection(post: $0, width: view.frame.width) }
        
        liaison.append(sections: sections)
    }
    
    @objc private func refreshSections() {
        let sections = Post.randomPosts()
            .map { return PostTableViewSection(post: $0, width: view.frame.width) }
        
        liaison.clearSections(replacedBy: sections, animated: false)
        refreshControl.endRefreshing()
    }
    
}

extension ViewController: OKTableViewLiaisonPaginationDelegate {
    
    func isPaginationEnabled() -> Bool {
        return liaison.sections.count < 6
    }
    
    func paginationStarted(indexPath: IndexPath) {
        
        liaison.scroll(to: indexPath)
        
        let sections = Post.paginatedPosts()
            .map { return PostTableViewSection(post: $0, width: view.frame.width) }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.liaison.append(sections: sections)
        }
    }
    
    func paginationEnded(indexPath: IndexPath) {
        
    }
}
