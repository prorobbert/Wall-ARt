//
//  ARContainerView.swift
//  Wall AR-t
//
//  Created by Robbert Ruiter on 26/06/2024.
//

import SwiftUI

struct ARContainerView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let arViewController = ARViewController()
        arViewController.setup()
        return arViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // nothing
    }
}
