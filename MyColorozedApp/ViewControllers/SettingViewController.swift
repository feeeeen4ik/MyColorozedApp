//
//  SettingViewController.swift
//  MyColorozedApp
//
//  Created by Феликс Антонович on 18.11.2024.
//

import UIKit

final class SettingViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet var colorViewOutlet: UIView!
    
    @IBOutlet var redValueOutlet: UILabel!
    @IBOutlet var greenValueOutlet: UILabel!
    @IBOutlet var blueValueOutlet: UILabel!
    
    @IBOutlet var redSliderOutlet: UISlider!
    @IBOutlet var greenSliderOutlet: UISlider!
    @IBOutlet var blueSliderOutlet: UISlider!
    
    @IBOutlet var redTextFieldOutlet: UITextField!
    @IBOutlet var greenTextFieldOutlet: UITextField!
    @IBOutlet var blueTextFieldOutlet: UITextField!
    
    // MARK: - Public properties
    var backgroundColor: UIColor!
    unowned var delegate: SettingViewControllerDelegate!
    
    // MARK: - Life view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorViewOutlet.layer.cornerRadius = 15
        colorViewOutlet.backgroundColor = backgroundColor
        
        redSliderOutlet.tintColor = .red
        greenSliderOutlet.tintColor = .green
        blueSliderOutlet.tintColor = .blue
        
        setValue(for: redSliderOutlet, greenSliderOutlet, blueSliderOutlet)
        setValue(for: redValueOutlet, greenValueOutlet, blueValueOutlet)
        setValue(for: redTextFieldOutlet, greenTextFieldOutlet, blueTextFieldOutlet)
        
    }
    
    // MARK: - IB Actions
    @IBAction func rgbSlidersAction(_ sender: UISlider) {
        switch sender {
        case redSliderOutlet:
            setValue(for: redValueOutlet)
            setValue(for: redTextFieldOutlet)
        case greenSliderOutlet:
            setValue(for: greenValueOutlet)
            setValue(for: greenTextFieldOutlet)
        default:
            setValue(for: blueValueOutlet)
            setValue(for: blueTextFieldOutlet)
        }
        setViewColor()
    }
    
    
    @IBAction func doneButtonAction() {
        delegate.setBackgroundColor(color: colorViewOutlet.backgroundColor ?? .white)
        dismiss(animated: true)
    }
    

}

// MARK: - Privet methods
private extension SettingViewController {
    
    func setViewColor() {
        colorViewOutlet.backgroundColor = UIColor(
            red: CGFloat(redSliderOutlet.value),
            green: CGFloat(greenSliderOutlet.value),
            blue: CGFloat(blueSliderOutlet.value),
            alpha: CGFloat(1)
        )
    }
    
    func setValue(for colorSliders: UISlider...) {
        let ciColor = CIColor(color: backgroundColor)
        colorSliders.forEach { colorSlider in
            switch colorSlider{
            case redSliderOutlet: colorSlider.value = Float(ciColor.red)
            case greenSliderOutlet: colorSlider.value = Float(ciColor.green)
            default: colorSlider.value = Float(ciColor.blue)
            }
        }
    }
    
    func setValue(for colorValue: UILabel...) {
        colorValue.forEach { colorValue in
            switch colorValue {
            case redValueOutlet: colorValue.text = string(from: redSliderOutlet)
            case greenValueOutlet: colorValue.text = string(from: greenSliderOutlet)
            default: colorValue.text = string(from: blueSliderOutlet)
            }
        }
    }
    
    func setValue(for colorTextFields: UITextField...) {
        colorTextFields.forEach { textField in
            switch textField {
            case redTextFieldOutlet: textField.text = string(from: redSliderOutlet)
            case greenTextFieldOutlet: textField.text = string(from: greenSliderOutlet)
            default: textField.text = string(from: blueSliderOutlet)
            }
        }
    }
    
    func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    func showAlert(withTitle title: String, andMessage message: String, textField: UITextField? = nil ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            textField?.text = "0.50"
            textField?.becomeFirstResponder()
        }
    }
}

// MARK: - UITextFieldDelegate
extension SettingViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            showAlert(withTitle: "Wrong format!", andMessage: "Please input correct value")
            return
        }
        
        guard let currentValue = Float(text), (0...1).contains(currentValue) else {
            showAlert(withTitle: "Wrong format!", andMessage: "Please input correct value")
            return
        }
        
        switch textField {
        case redTextFieldOutlet:
            redSliderOutlet.setValue(currentValue, animated: true)
            setValue(for: redValueOutlet)
        case greenTextFieldOutlet:
            greenSliderOutlet.setValue(currentValue, animated: true)
            setValue(for: greenValueOutlet)
        default:
            blueSliderOutlet.setValue(currentValue, animated: true)
            setValue(for: blueValueOutlet)
        }
        
        setViewColor()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyBoardToolbar = UIToolbar()
        keyBoardToolbar.sizeToFit()
        textField.inputAccessoryView = keyBoardToolbar
        
        let doneBarButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: textField,
            action: #selector(resignFirstResponder)
        )
        
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        keyBoardToolbar.items = [flexBarButton, doneBarButton]
    }
}
