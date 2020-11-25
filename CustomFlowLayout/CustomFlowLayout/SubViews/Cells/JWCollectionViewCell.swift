//
//  JWCollectionViewCell.swift
//  CustomFlowLayout
//
//  Created by JW_Macbook on 2020/11/25.
//

import UIKit

class JWCollectionViewCell: UICollectionViewCell {
    //MARK:- UI 관련
    @IBOutlet weak var mainBackView: UIView!
    @IBOutlet weak var lbNumber: UILabel! // 카운트 표기
    @IBOutlet weak var lbContent: UILabel! // 내용 표기

    
    //MARK:- 내부변수
    var localVM:sampleVM? = nil
    
    /// 하일라이트일때 액션 체크중.
    override var isHighlighted: Bool {
        didSet {
            // 애니메이션 처리 해보기
            if isHighlighted {
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                    self.mainBackView.backgroundColor = .yellow
                    self.mainBackView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                })
            }
            else {
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                    self.mainBackView.backgroundColor = .white
                    self.mainBackView.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// #. 라운드, 테투리 처리
        self.mainBackView.layer.cornerRadius = 8
        self.mainBackView.clipsToBounds = true
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
