//
//  WidgetSize.swift
//  Rocket List
//
//  Created by Mada Bramantyo on 14/02/23.
//

import UIKit

class WidgetSize {
    static let rectangleHeight = 48.0
    static let largeRectangleHeight = 56.0
    
    private static let window = UIApplication.shared.windows.first
    static let topSafeArea = window?.safeAreaInsets.top
    static let bottomSafeArea = window?.safeAreaInsets.bottom
}
