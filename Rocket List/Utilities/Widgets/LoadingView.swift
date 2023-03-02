//
//  LoadingView.swift
//  Rocket List
//
//  Created by Mada Bramantyo on 15/02/23.
//

import UIKit

class LoadingView: UIView {
    
    private let spinner = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(spinner)
        
        spinner.color = .black.withAlphaComponent(0.5)
        spinner.startAnimating()
        spinner.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        
        backgroundColor = .white
        layer.cornerRadius = CornerSize.small
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
