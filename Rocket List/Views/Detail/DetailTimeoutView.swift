//
//  DetailTimeoutView.swift
//  Rocket List
//
//  Created by Mada Bramantyo on 15/02/23.
//

import UIKit
import SnapKit

class DetailTimeoutView: UIView {
    
    private var callback: (() -> ())?

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private lazy var titleVSV: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Spaces.xSmall
        
        [titleLabel, subtitleLabel].forEach {
            stack.addArrangedSubview($0)
        }
        
        titleLabel.text = "Timeout Connection"
        titleLabel.font = Fonts.medium(size: FontSize.footnote)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        subtitleLabel.text = "Tap to retry."
        subtitleLabel.font = Fonts.regular(size: FontSize.caption)
        subtitleLabel.textColor = .black
        subtitleLabel.textAlignment = .center
        
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleVSV)
        
        titleVSV.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        
        backgroundColor = .white
        layer.cornerRadius = CornerSize.small
        
        addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(onTap(_:))
        ))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onTap(_ gesture: UITapGestureRecognizer) {
        callback?()
    }
    
    func setCallback(callback: @escaping () -> ()) {
        self.callback = callback
    }
}
