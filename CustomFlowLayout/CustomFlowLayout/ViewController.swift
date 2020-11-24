//
//  ViewController.swift
//  CustomFlowLayout
//
//  Created by JW_Macbook on 2020/11/24.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- UI 관련
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    //MARK:- 내부 변수관련
    var disPlayData:[sampleVM] = [sampleVM]()
    
    let cellId:String = "SampleCollectionViewCell"
    /// 컬렉션 뷰 나누는 갯수
    private var colAndRow = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDatas()
    }

    func initDatas() {
        // #. 디자인가이드
        self.view.backgroundColor = .lightGray
        
        // 1. 데이터 셋팅
        self.disPlayData = self.getVMs()
        
        // 2. collectionViewLayout 설정
        
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


extension ViewController:UICollectionViewDataSource, UICollectionViewDelegate, JwCollectionViewLayoutDataSource {
    func jwCollectionView(_ collectionView: UICollectionView, heightAtIndexPath indexPath: IndexPath) -> CGFloat {
        let vm:sampleVM = self.disPlayData[indexPath.row]
        
        // 높이값 계산한적 있으면 재활용 하기
        if vm.cellSize == .zero {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SampleCollectionViewCell
            // 데이터 가공
            cell.configurationCell(vm: vm)
            
            // 높이 계산로직
            let targetWidth:CGFloat = collectionView.frame.size.width / CGFloat(colAndRow)
            let autoLayoutSize = cell.autoLayoutVSize(width: targetWidth)
            vm.cellSize = autoLayoutSize
        }
        
        return vm.cellSize.height
    }
    
    // Section의 개수.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.disPlayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let vm:sampleVM = self.disPlayData[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SampleCollectionViewCell
        // 데이터 가공
        cell.configurationCell(vm: vm)
        
        return cell
    }
}



extension ViewController {
    /// 1. ViewModel 가져오기 (샘플용)
    /// - Returns: [sampleVM]
    func getVMs() -> [sampleVM] {
        var result = [sampleVM]()
        
        // 반복해서 만들어 주기
        for i in 1 ... 100 {
            let vm = sampleVM()
            vm.docId = "\(i)"
            
            if 0 == i % 3 {
                vm.content = "여러줄을 나오게 하는 테스트도 진행중입니다. 한번에 여러줄을 복사해서 넣겠습니다. 여러줄을 나오게 하는 테스트도 진행중입니다. 한번에 여러줄을 복사해서 넣겠습니다. 여러줄을 나오게 하는 테스트도 진행중입니다. 한번에 여러줄을 복사해서 넣겠습니다. 여러줄을 나오게 하는 테스트도 진행중입니다. 한번에 여러줄을 복사해서 넣겠습니다."
            }
            
            else if 1 == i % 3 {
                vm.content = "CollectionViewFlowLayout 테스트 진행중입니다."
            }
            
            else {
                vm.content = "안녕하세요 물먹고하자입니다. 오늘은 CollectionViewFlowLayout Sample 만드는 중입니다."
            }
            
            // 생성한값 넣어주기
            result.append(vm)
        }
        
        
        return result
    }
}
