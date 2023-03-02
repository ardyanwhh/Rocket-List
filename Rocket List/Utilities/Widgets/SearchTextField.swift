//
//  SearchTextField.swift
//  Rocket List
//
//  Created by Mada Bramantyo on 14/02/23.
//

import UIKit

class SearchTextField: UITextField {
    
    private let magnifierIV = UIImageView()
    
    private let padding = UIEdgeInsets(
        top: 0, left: 48, bottom: 0, right: Spaces.conate
    )
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(magnifierIV)
        
        magnifierIV.image = .init(systemName: "magnifyingglass")?
            .withRenderingMode(.automatic)
        magnifierIV.tintColor = .accent
        magnifierIV.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self)
                .offset(Spaces.conate)
        }
        
        textColor = .black
        font = Fonts.regular(size: FontSize.subheadline)
        attributedPlaceholder = NSAttributedString(
            string: "Search...", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.accent.withAlphaComponent(0.5)
            ]
        )
        
        backgroundColor = .accent.withAlphaComponent(0.1)
        layer.cornerRadius = CornerSize.small
        layer.shadowColor = UIColor.accent.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
