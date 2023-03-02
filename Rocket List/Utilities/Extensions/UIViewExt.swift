//
//  UIViewExt.swift
//  Rocket List
//
//  Created by Mada Bramantyo on 14/02/23.
//

import UIKit
import SkeletonView

extension UIView {
    func showSkeleton() {
        isSkeletonable = true
        showAnimatedGradientSkeleton(
            usingGradient: .init(
                baseColor: .lightGray.withAlphaComponent(0.3),
                secondaryColor: .lightGray.withAlphaComponent(0.6)
            ),
            animation: nil, transition: .crossDissolve(0.15)
        )
    }
}
