//
//  JWCollectionViewSample.swift
//  CustomFlowLayout
//
//  Created by JW_Macbook on 2020/11/25.
//
/*
 Sample CollectionView 예제
 */

import UIKit

class JWCollectionViewSample: UIViewController {

    //MARK:- UI 관련
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    
    //MARK:- 내부 변수관련
    var disPlayData:[String] = [
        "기본형 (Defalut) Delegate 방식",
        "해더형 (Header) Delegate 방식",
        "기본형 (Defalut) Diffable 방식",
        "해더형 (Header) Diffable 방식",
    ]
    let cellId:String = "TitleCell"
    /// 컬렉션 뷰 나누는 갯수
    private var colAndRow = 1
    
    
    
    
    //MARK: - 생성자
    public class func instanse() -> JWCollectionViewSample {
        let desc = JWCollectionViewSample.init(nibName: "JWCollectionViewSample", bundle: nil)
        return desc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDatas()
    }
    
    func initDatas() {
        // #. 디자인가이드
        self.view.backgroundColor = .lightGray
        self.title = "FlowLayout Sample"
        
        // 1. collectionViewLayout 설정
        
        // #. 재활용 등록 및 생성 부분
        mainCollectionView.register(UINib.init(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
        
        // 1) 레이아웃 구성
        if let layout: JwCollectionViewLayout = mainCollectionView.collectionViewLayout as? JwCollectionViewLayout {
            layout.dataSource = self as JwCollectionViewLayoutDataSource
            layout.numberColumnAndRow = colAndRow
            layout.paddingHeight = 8
            layout.paddingWidth = 18
            layout.scrollDirection = .vertical
        }
        
        // 2) CollectionView 셋팅
        mainCollectionView.delegate = self as UICollectionViewDelegate
        mainCollectionView.dataSource = self as UICollectionViewDataSource
        mainCollectionView.isPagingEnabled = false
        mainCollectionView.backgroundColor = .clear
    }
}

extension JWCollectionViewSample:UICollectionViewDataSource, UICollectionViewDelegate, JwCollectionViewLayoutDataSource {
    func jwCollectionView(_ collectionView: UICollectionView, heightAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // Section의 개수.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.disPlayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let title:String = self.disPlayData[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TitleCell
        // 데이터 가공
        cell.configurationCell(title:title)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let desc = DefaultHeaderCollectionViewController.instanse()
            self.navigationController?.pushViewController(desc, animated: true)
        case 2:
            let desc = DiffableCollectionViewController.instanse()
            self.navigationController?.pushViewController(desc, animated: true)
        case 3:
            let desc = DiffableHeaderCollectionViewController.instanse()
            self.navigationController?.pushViewController(desc, animated: true)
        default:
            let desc = DefaultCollectionView.instanse()
            self.navigationController?.pushViewController(desc, animated: true)
        }
    }
}
