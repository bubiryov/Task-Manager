//
//  GADBannerViewController.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 03.08.2023.
//

import Foundation
import SwiftUI
import GoogleMobileAds

struct GADBannerViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        let viewController = UIViewController()
        
        let testID = "ca-app-pub-3940256099942544/2934735716"
        view.adUnitID = testID
        view.rootViewController = viewController
        
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        
        view.load(GADRequest())
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
