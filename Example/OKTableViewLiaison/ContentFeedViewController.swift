//
//  ContentFeedViewController.swift
//  OKTableViewLiaison
//
//  Created by Dylan Shine on 04/11/2018.
//  Copyright © 2018 OkCupid. All rights reserved.
//

import UIKit
import OKTableViewLiaison

final class ContentFeedViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private let liaison = OKTableViewLiaison()
    private let refreshControl = UIRefreshControl()
    
    private var initialSections: [PostTableViewSection] {
        return Post.initialPosts()
            .map { PostTableViewSectionFactory.section(for: $0, width: tableView.frame.width) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refreshSections), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        liaison.paginationDelegate = self
        liaison.liaise(tableView: tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        liaison.append(sections: initialSections, animated: false)
    }
    
    @objc private func refreshSections() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.liaison.clearSections(replacedBy: self.initialSections, animated: false)
            self.refreshControl.endRefreshing()
        }
    }
    
}

extension ContentFeedViewController: OKTableViewLiaisonPaginationDelegate {
    
    func isPaginationEnabled() -> Bool {
        return liaison.sections.count < 8
    }
    
    func paginationStarted(indexPath: IndexPath) {
        
        liaison.scroll(to: indexPath)
        
        let sections = Post.paginatedPosts()
            .map { PostTableViewSectionFactory.section(for: $0, width: tableView.frame.width) }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.liaison.append(sections: sections)
        }
    }
    
    func paginationEnded(indexPath: IndexPath) {
        
    }
}
