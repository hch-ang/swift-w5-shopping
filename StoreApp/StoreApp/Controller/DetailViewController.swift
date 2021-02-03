//
//  DetailViewController.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/03.
//

import UIKit

class DetailViewController: UIViewController {
    private var storeDomain : String = ""
    private var productId : String = ""
    @IBOutlet weak var detailView: DetailView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(viewDataIsReady), name: .DetailViewDataIsReady, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func setStoreDomain(storeDomain : String) {
        self.storeDomain = storeDomain
    }
    
    func setProductId(productId : Int) {
        self.productId = String(productId)
    }
    
    @objc func viewDataIsReady() {
        detailView.setViewData()
    }

}
