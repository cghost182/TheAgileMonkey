//
//  UIViewControllerExtension.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 18/01/21.
//

import UIKit

extension UIViewController {
    func showSpinner() {
        DispatchQueue.main.async { [weak self] in
            let spinner = UIActivityIndicatorView()
            spinner.style = .medium
            spinner.startAnimating()
            
            guard let view = self?.view else { return }
            
            view.addSubview(spinner)
            spinner.center = view.center
        }
    }
    
    func hideSpinner() {
        DispatchQueue.main.async { [weak self] in
            self?.view.subviews.forEach({ if $0.isKind(of: UIActivityIndicatorView.self) {
                $0.removeFromSuperview()
            } })
        }
    }
}

class BaseViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}
