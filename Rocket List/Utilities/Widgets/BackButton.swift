//
//  BackButton.swift
//  Rocket List
//
//  Created by Mada Bramantyo on 14/02/23.
//

import UIKit
import SnapKit

class BackButton: UIView {
    
    private var callback: (() -> ())?
    
    private let chevronBackIV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(chevronBackIV)
        
        chevronBackIV.image = .init(systemName: "chevron.backward")?
            .withRenderingMode(.alwaysTemplate)
        chevronBackIV.tintColor = .black
        chevronBackIV.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        
        backgroundColor = .white
        layer.cornerRadius = CornerSize.small
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.25
        
        addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(onTap(_:))
        ))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onTap(_ gesture: UITapGestureRecognizer) {
        self.callback?()
    }
    
    func setCallback(_ callback: @escaping () -> ()) {
        self.callback = callback
    }
}
