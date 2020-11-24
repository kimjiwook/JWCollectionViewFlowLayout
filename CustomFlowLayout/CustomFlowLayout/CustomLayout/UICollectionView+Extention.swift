//
//  UICollectionViewCell+Extention.swift
//  KLAGO
//
//  Created by JW_Macbook on 2020/09/01.
//  Copyright © 2020 JW_Macbook. All rights reserved.
//

import UIKit

public extension UICollectionViewCell {
    /// UICollectionView Cell 사이즈 세로모드 계산하기
    /// - Parameters:
    ///   - width: 최대 가로폭
    /// - Returns: 계산된 사이즈
    func autoLayoutVSize(width:CGFloat) -> CGSize {
        self.prepareForReuse()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let calculateView: UIView = self.contentView
        let targetSize = CGSize(width: width, height: 0)
        // Calculate the size (height) using Auto Layout
        let autoLayoutSize = calculateView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow)
        
        return autoLayoutSize
    }
}
