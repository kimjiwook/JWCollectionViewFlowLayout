//
//  SampleCollectionViewCell.swift
//  CustomFlowLayout
//
//  Created by JW_Macbook on 2020/11/24.
//

import UIKit

class SampleCollectionViewCell: UICollectionViewCell {

    //MARK:- UI 관련
    @IBOutlet weak var lbNumber: UILabel! // 카운트 표기
    @IBOutlet weak var lbContent: UILabel! // 내용 표기

    
    //MARK:- 내부변수
    var localVM:sampleVM? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    /// 1. Cell 꾸미는 로직
    /// - Parameter vm: sampleVM
    func configurationCell(vm:sampleVM) {
        // 1. 넘버 ID 넣어주기
        self.lbNumber.text = vm.docId
        
        // 2. 내용 넣어주기
        self.lbContent.numberOfLines = 0
        self.lbContent.text = vm.content
    }
}
