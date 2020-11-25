//
//  TitleCell.swift
//  CustomFlowLayout
//
//  Created by JW_Macbook on 2020/11/25.
//

import UIKit

class TitleCell: UICollectionViewCell {

    //MARK: - UI 관련
    @IBOutlet weak var mainBackView: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    
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
        // Initialization code
        
        /// #. 라운드, 테투리 처리
        self.mainBackView.layer.cornerRadius = 8
        self.mainBackView.clipsToBounds = true
    }

    
    /// 1. Cell 꾸미는 로직
    /// - Parameter title: 표시될 타이틀
    func configurationCell(title:String) {
        // 1. 타이틀 정보 넣어주기
        self.lbTitle.text = title
    }
    
}
