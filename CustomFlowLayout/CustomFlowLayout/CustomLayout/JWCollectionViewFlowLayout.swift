//
//  JwCollectionViewLayout.swift
//  KLAGO
//
//  Created by JW_Macbook on 2020/02/19.
//  Copyright © 2020 JW_Macbook. All rights reserved.
//
// 2020. 02. 18 Kimjiwook
// 공통으로 사용될 CollectionViewLayout 입니다.

import UIKit

/// DataSource
@objc protocol JwCollectionViewLayoutDataSource: AnyObject {
    /// 1. (필수) Cell 높이값 전달받는 DataSource
    /// - Parameters:
    ///   - collectionView: collectionView
    ///   - indexPath: indexPath
    func jwCollectionView(_ collectionView: UICollectionView, heightAtIndexPath indexPath: IndexPath) -> CGFloat
    /// 2. (옵션) 해더뷰 있으면 값 전달받기 DataSource
    /// - Parameter collectionView: UICollectionView
    /// - Parameter section: 세션 정보
    @objc optional func jwCollectionView(_ collectionView: UICollectionView, headerSize section: Int) -> CGFloat
}

class JwCollectionViewLayout: UICollectionViewFlowLayout {
    
    // 캐시의 구분값
    enum jwCollectionElement: String {
        case sectionHeader
        case sectionFooter
        case cell

        var id: String {
            return self.rawValue
        }

        var kind: String {
            return "Kind\(self.rawValue.capitalized)"
        }
    }
    
    
    // 1. (필수) DataSource
    weak var dataSource: JwCollectionViewLayoutDataSource?
    
    // 2. (옵션) 가로, 세로 방향에 따른 아이템표현 갯수
    // ex) Scroll Vertical : Column 표현갯수, Scroll Horizontal : row 표현갯수
    var numberColumnAndRow = 1
    var cellPadding: CGFloat = 4 // 기본 패딩값
    // 2020. 02. 21 Kimjiwook
    // 주말생각.. (왼쪽, 오른쪽) 패딩값, (위, 아래) 패딩값 2가지 종류 로 받으면 생각보다 표현할 수 있는게 좋을듯.
    var paddingHeight: CGFloat = 4
    var paddingWidth: CGFloat = 4
    
    // 3. 캐시 Array
    private var cache = [jwCollectionElement: [IndexPath: UICollectionViewLayoutAttributes]]()
    
    // 4. Content 높이, 너비 저장용.
    // ex) Scroll Vertical : contentWidth == CollectionView Width , Scroll Horizontal : contentHeight == CollectionView Height
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat = 0
    
    // 5. Content Size 반환
    override var collectionViewContentSize: CGSize {
        //return CGSize(width: contentWidth, height: self.collectionView!.bounds.height)
        // 2020. 02. 27 Kimjiwook
        // 만약에 CollectionView Height 보다 낮으면 맞춰줄 필요 있음.
        // self.scrollDirection == .vertical <--- 확인하고 width인지 height 인지 판단해주기.
        
        if self.scrollDirection == .vertical && (self.collectionView!.bounds.height >= contentHeight){
            contentHeight = self.collectionView!.bounds.height
        } else if self.scrollDirection == .horizontal && (self.collectionView!.bounds.width >= contentWidth) {
            contentWidth = self.collectionView!.bounds.width
        }
        
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    /// 캐시 초기화
    private func prepareCache() {
        cache.removeAll(keepingCapacity: true)
        cache[.sectionHeader] = [IndexPath: UICollectionViewLayoutAttributes]()
        cache[.sectionFooter] = [IndexPath: UICollectionViewLayoutAttributes]()
        cache[.cell] = [IndexPath: UICollectionViewLayoutAttributes]()
    }
    
    /// Cell 별 위치값 꾸며주는 부분
    override func prepare() {
        
        // 1) 초기화
        prepareCache()
        
        // 2) 꾸며주기
        if self.scrollDirection == .vertical {
            // 세로방향 꾸며주기.
            self.layoutItemVertical()
        } else {
            self.layoutItemHorizontal()
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
      
        for (_, elementInfos) in cache {
            for (_, attributes) in elementInfos {
                if attributes.frame.intersects(rect) {
                  visibleLayoutAttributes.append(attributes)
                }
            }
        }
        
        return visibleLayoutAttributes
    }
    
    // Cell
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[.cell]?[indexPath]
    }
    
    // Header, Footer
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return cache[.sectionHeader]?[indexPath]
        case UICollectionView.elementKindSectionFooter:
            return cache[.sectionFooter]?[indexPath]
        default:
            return nil
        }
    }
    
    
    ///MARK:- 계산로직
    
    /// 1. 세로방향 계산로직
    func layoutItemVertical() {
        
        // 세로방향
        contentHeight = 0
        contentWidth = self.collectionView!.bounds.width
        
        // Cell가로길이 : 전체길이 - (가로간격 * 갯수+1) / 갯수
        let columnWidth = CGFloat(contentWidth - (paddingWidth * CGFloat(numberColumnAndRow + 1))) / CGFloat(numberColumnAndRow)
        var xOffset: [CGFloat] = []
        for column in 0..<numberColumnAndRow {
            // x 좌표 : (컬럼 * Cell길이) + ((컬럼+1) * 가로간격)
            xOffset.append((CGFloat(column) * columnWidth) + (CGFloat(column + 1) * paddingWidth))
        }
        var column = 0
        // Y 좌표는 배열생성만 해놓기
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberColumnAndRow)
        
        // 초기 yOffset 간격값 넣어주기. (column 갯수만큼 yOffset 생성되어있음.)
        for i in 0...xOffset.count-1 {
            yOffset[i] += paddingHeight
        }
        
        // 3)
        // 2중 포문 (setion, item)
        for section in 0..<collectionView!.numberOfSections {
            
            // 세션 들어올때 높이값 변동 (해더 높이값이 있을때 그려주기)
            if let headerHeight = dataSource?.jwCollectionView?(collectionView!, headerSize: section), 0 < headerHeight {
                // 1. 해더 정보 넣어주기 (없을때 예외처리)
                let indexPath = IndexPath(item: 0, section: section)
                let kind = UICollectionView.elementKindSectionHeader
                column = 0 // 초기화 처리

                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
                
                // 해더 위치 잡기.
                let frame = CGRect(x: 0,
                                   y: yOffset.first!,
                                   width: contentWidth,
                                   height: headerHeight)
                attributes.frame = frame //insetFrame
                cache[.sectionHeader]?[attributes.indexPath] = attributes
                
                // Cell 영역 그리기 전에 위치값 조정 (조정하기) 여러개 고려하기
                // yOffset 값들중 가장 높은 값으로 통일시켜주기.
                var maxValue:CGFloat = 0.0
                for i in 0...numberColumnAndRow-1 {
                    yOffset[i] += headerHeight + paddingHeight
                    
                    if maxValue <= yOffset[i] {
                        maxValue = yOffset[i]
                    }
                }
                
                // 해당 열 최대값으로 치환해 주기.
                for i in 0...numberColumnAndRow-1 {
                    yOffset[i] = maxValue
                }

            }
            
            // Cell 영역 계산
            let itemCount = collectionView!.numberOfItems(inSection: section)
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)
                
                // 4) 높이계산입니다
                let cellHeight = dataSource?.jwCollectionView(collectionView!, heightAtIndexPath: indexPath) ?? 60
                //let photoHeight = self.estimatedItemSize.height
                
                let height = cellHeight
                
                // 기존 Y 값 + 높이 간격
                // yOffset[column] = yOffset[column] + paddingHeight
                
                
                let frame = CGRect(x: xOffset[column],
                                   y: yOffset[column],
                                   width: columnWidth,
                                   height: height)
                
                
                // inset 작업을 하지 않기 위함.
                //let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding / 2)
                
                // inset 정보를 이렇게 나눠서 맞춰줘야지 모든 간격이 맞을듯.
                // let insetFrame1 = UIEdgeInsets.init(top: cellPadding, left: cellPadding, bottom: cellPadding, right: cellPadding)
                
                
                // 5
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame //insetFrame
                cache[.cell]?[indexPath] = attributes
                
                // 6
                contentHeight = max(contentHeight, frame.maxY)
                
                // 기존 Y 값 + 높이 간격
                yOffset[column] = yOffset[column] + height + paddingHeight
                column = column < (numberColumnAndRow - 1) ? (column + 1) : 0
            }
        }
        
        
        
        
        
        // 7
        // 마지막여백을 위해서 contentHeight + 여백 더해주기.
         contentHeight = contentHeight + paddingHeight
    }
    
    
    /// 2. 가로방향 계산로직
    func layoutItemHorizontal() {
        // 가로방향 꾸며주기.
        contentHeight = self.collectionView!.bounds.height
        contentWidth = 0
        
        // Cell가로길이 : 전체길이 - (세로간격 * 갯수+1) / 갯수
        let columnHeight = CGFloat(contentHeight - (paddingHeight * CGFloat(numberColumnAndRow + 1))) / CGFloat(numberColumnAndRow)
        var yOffset: [CGFloat] = []
        for row in 0..<numberColumnAndRow {
            // y 좌표 : (컬럼 * Cell길이) + ((컬럼+1) * 세로간격)
            yOffset.append((CGFloat(row) * columnHeight) + (CGFloat(row + 1) * paddingHeight))
        }
        var row = 0
        // X 좌표는 배열생성만 해놓기
        var xOffset: [CGFloat] = .init(repeating: 0, count: numberColumnAndRow)
        
        // 초기 xOffset 간격값 넣어주기. (column 갯수만큼 xOffset 생성되어있음.)
        for i in 0...xOffset.count-1 {
            xOffset[i] += paddingWidth
        }
        
        // 3)
        // 2중 포문 (setion, item)
        for section in 0..<collectionView!.numberOfSections {
            // 세션 들어올때 높이값 변동 (해더 높이값이 있을때 그려주기)
            if let headerWidth = dataSource?.jwCollectionView?(collectionView!, headerSize: section), 0 < headerWidth {
                // 1. 해더 정보 넣어주기 (없을때 예외처리)
                let indexPath = IndexPath(item: 0, section: section)
                let kind = UICollectionView.elementKindSectionHeader
                row = 0 // 초기화

                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)

                let frame = CGRect(x: xOffset.first!,
                                   y: 0,
                                   width: headerWidth,
                                   height: contentHeight)
                attributes.frame = frame //insetFrame
                cache[.sectionHeader]?[attributes.indexPath] = attributes

                
                // Cell 영역 그리기 전에 위치값 조정 (조정하기) 여러개 고려하기
                // yOffset 값들중 가장 높은 값으로 통일시켜주기.
                var maxValue:CGFloat = 0.0
                for i in 0...numberColumnAndRow-1 {
                    xOffset[i] += headerWidth + paddingWidth
                    
                    if maxValue <= xOffset[i] {
                        maxValue = xOffset[i]
                    }
                }
                
                // 해당 열 최대값으로 치환해 주기.
                for i in 0...numberColumnAndRow-1 {
                    xOffset[i] = maxValue
                }
            }
            
            // Cell 영역 계산
            let itemCount = collectionView!.numberOfItems(inSection: section)
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)
                
                // 4) 높이계산입니다
                let cellWidth = dataSource?.jwCollectionView(collectionView!, heightAtIndexPath: indexPath) ?? 100
                
                //            // 첫번째 의 경우 패딩값의 X 좌표값을 추가해 주어서 맞춰주기.
                //            if 0.0 == xOffset[row] {
                //                xOffset[row] = cellPadding / 2
                //            }
                
                let width = cellPadding * 2 + cellWidth
                let frame = CGRect(x: xOffset[row],
                                   y: yOffset[row],
                                   width: width,
                                   height: columnHeight)
                
                // let insetFrame = frame.insetBy(dx: cellPadding / 2, dy: cellPadding)
                
                // 5
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame // insetFrame
                cache[.cell]?[indexPath] = attributes
                
                // 6
                contentWidth = max(frame.maxX, contentWidth)
                
                // 기존 X 값 + 가로 간격
                xOffset[row] = xOffset[row] + width + paddingWidth
                row = row < (numberColumnAndRow - 1) ? (row + 1) : 0
            }
        }
        
        // 7
        // 마지막여백을 위해서 contentWidth + 여백 더해주기.
         contentWidth = contentWidth + paddingWidth
    }
}
