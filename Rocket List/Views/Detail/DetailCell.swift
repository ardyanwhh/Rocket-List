//
//  DetailCell.swift
//  Rocket List
//
//  Created by Mada Bramantyo on 15/02/23.
//

import UIKit
import SnapKit

class DetailCell: UICollectionViewCell {
    
    var data: [String]! {
        didSet {
            titleLabel.text = data[0]
            subtitleLabel.text = data[1] + "."
        }
    }
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [titleLabel, subtitleLabel].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.font = Fonts.semiBold(size: FontSize.body)
        titleLabel.textColor = .black
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.horizontalEdges.equalTo(self)
        }
        
        subtitleLabel.font = Fonts.regular(size: FontSize.subheadline)
        subtitleLabel.textColor = .black
        subtitleLabel.numberOfLines = .zero
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(Spaces.conate)
            make.horizontalEdges.equalTo(self)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
