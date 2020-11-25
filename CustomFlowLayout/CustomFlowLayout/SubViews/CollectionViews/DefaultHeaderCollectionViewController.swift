//
//  DefaultHeaderCollectionViewController.swift
//  CustomFlowLayout
//
//  Created by JW_Macbook on 2020/11/25.
//

import UIKit

class DefaultHeaderCollectionViewController: UIViewController {

    
    //MARK: - 생성자
    public class func instanse() -> DefaultHeaderCollectionViewController {
        let desc = DefaultHeaderCollectionViewController.init(nibName: "DefaultHeaderCollectionViewController", bundle: nil)
        return desc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
