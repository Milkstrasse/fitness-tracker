//
//  FocusSystem.swift
//  FitnessTracker
//
//  Created by Janice Hablützel on 27.08.23.
//

import Foundation
import SwiftUI
import UIKit

//https://www.vbutko.com/articles/how-to-manage-swiftui-focus-state-in-ios14-and-before/
struct FocusUIKitTextField: UIViewRepresentable {
    @Binding var text: String

    var isFirstResponder: Bool = false
    let numbersOnly: Bool
    
    func makeUIView(context: UIViewRepresentableContext<FocusUIKitTextField>) -> UITextField {
        let textField = TextFieldWithPadding(frame: .zero)
        textField.delegate = context.coordinator
        textField.font = UIFont(name: "Museo Sans Rounded 900", size: 16)
        
        if numbersOnly {
            textField.keyboardType = .numberPad
            textField.attributedPlaceholder = NSAttributedString(
                string: "5",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "MainText")?.withAlphaComponent(0.5) ?? UIColor.red]
            )
        } else {
            textField.attributedPlaceholder = NSAttributedString(
                string: "TITLE",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "MainText")?.withAlphaComponent(0.5) ?? UIColor.red]
            )
        }
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<FocusUIKitTextField>) {
        uiView.text = text.uppercased()

        if isFirstResponder && context.coordinator.didBecomeFirstResponder != true {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
            context.coordinator.didResignFirstResponder = false
        } else if !isFirstResponder && context.coordinator.didResignFirstResponder != true {
            uiView.resignFirstResponder()
            context.coordinator.didResignFirstResponder = true
            context.coordinator.didBecomeFirstResponder = false
        }
    }
    
    func makeCoordinator() -> FocusUIKitTextField.Coordinator {
        return Coordinator(text: $text)
    }
}

extension FocusUIKitTextField {
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        var didBecomeFirstResponder: Bool? = nil
        var didResignFirstResponder: Bool? = nil
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.text = textField.text ?? ""
            }
        }
    }
}

//https://www.advancedswift.com/uitextfield-with-padding-swift/
class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 15,
        bottom: 0,
        right: 0
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}

