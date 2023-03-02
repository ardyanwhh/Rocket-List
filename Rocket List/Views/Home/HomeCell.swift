//
//  HomeCell.swift
//  Rocket List
//
//  Created by Mada Bramantyo on 15/02/23.
//

import UIKit
import SnapKit

class HomeCell: UICollectionViewCell {
    
    var data: Rocket.Response! {
        didSet {
            titleLabel.text = data.name
            contentIV.image = .init(named: Assets.icRocket)?
                .withRenderingMode(.alwaysTemplate)
            
            if let desc = data.desc {
                subtitleLabel.text = desc
                titleVSV.spacing = Spaces.smallest
            } else {
                subtitleLabel.text = nil
                titleVSV.spacing = 0
            }
        }
    }
    
    private let contentIV = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let detailIV = UIImageView()
    
    private lazy var titleVSV: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        
        [titleLabel, subtitleLabel].forEach {
            stack.addArrangedSubview($0)
            $0.textColor = .accent
        }
        
        titleLabel.font = Fonts.medium(size: FontSize.subheadline)
        subtitleLabel.font = Fonts.regular(size: FontSize.footnote)
        
        return stack
    }()
    
    override var isHighlighted: Bool {
        didSet {
            titleLabel.textColor = isHighlighted ? .white : .accent
            subtitleLabel.textColor = isHighlighted ? .white : .accent
            contentIV.tintColor = isHighlighted ? .white : .accent
            detailIV.tintColor = isHighlighted ? .white : .accent
            backgroundColor = isHighlighted ? .accent
            : .accent.withAlphaComponent(0.1)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [contentIV, titleVSV, detailIV].forEach {
            contentView.addSubview($0)
        }
        
        contentIV.tintColor = .accent
        contentIV.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(Spaces.conate)
            make.height.width.equalTo(40)
        }
        
        titleVSV.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(contentIV.snp_trailingMargin)
                .offset(Spaces.medium)
            make.width.equalTo(self.frame.width / 1.6)
        }
        
        detailIV.image = .init(systemName: "arrow.right")
        detailIV.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).offset(-Spaces.conate)
        }
        
        layer.cornerRadius = CornerSize.small
        backgroundColor = .accent.withAlphaComponent(0.1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
