//
//  ViewController.swift
//  MyColorozedApp
//
//  Created by Феликс Антонович on 18.11.2024.
//

import UIKit

protocol SettingViewControllerDelegate: AnyObject {
    func setBackgroundColor(color: UIColor)
}

final class ColorViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingViewController else { return }
        
        settingsVC.delegate = self
        settingsVC.backgroundColor = view.backgroundColor
    }

}

// MARK: - SettingViewControllerDelegate
extension ColorViewController: SettingViewControllerDelegate {
    func setBackgroundColor(color: UIColor) {
        view.backgroundColor = color
    }
    
    
    
}

