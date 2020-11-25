//
//  DefaultCollectionView.swift
//  CustomFlowLayout
//
//  Created by JW_Macbook on 2020/11/25.
//

import UIKit

class DefaultCollectionView: UIViewController {

    //MARK: - 생성자
    public class func instanse() -> DefaultCollectionView {
        let desc = DefaultCollectionView.init(nibName: "DefaultCollectionView", bundle: nil)
        return desc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
