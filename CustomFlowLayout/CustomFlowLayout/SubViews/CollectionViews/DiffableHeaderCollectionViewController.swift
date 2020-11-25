//
//  DiffableHeaderCollectionViewController.swift
//  CustomFlowLayout
//
//  Created by JW_Macbook on 2020/11/25.
//

import UIKit

class DiffableHeaderCollectionViewController: UIViewController {

    //MARK: - 생성자
    public class func instanse() -> DiffableHeaderCollectionViewController {
        let desc = DiffableHeaderCollectionViewController.init(nibName: "DiffableHeaderCollectionViewController", bundle: nil)
        return desc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
