//
//  DetailViewController.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/03.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet weak var detailView: DetailView!
    private var detailItemManager : DetailItemManagerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        detailView.setDetailItemManager(detailItemManager: detailItemManager)
        detailView.setViewLayouts()
    }
    
    func setDetailItemManager(detailItemManager : DetailItemManagerProtocol) {
        self.detailItemManager = detailItemManager
    }
    
    func addObserverOfDetailViewDataIsReady() {
        NotificationCenter.default.addObserver(self, selector: #selector(viewDataIsReady), name: .DetailViewDataIsReady, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @objc func viewDataIsReady() {
        DispatchQueue.main.async {
            self.detailView.setViewData()
        }
    }

}
