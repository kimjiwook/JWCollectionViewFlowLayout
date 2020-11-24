//
//  ViewController.swift
//  CustomFlowLayout
//
//  Created by JW_Macbook on 2020/11/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
