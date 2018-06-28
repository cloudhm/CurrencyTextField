//
//  CurrencyTextField.swift
//  InputTextField
//
//  Created by cloud on 2018/6/26.
//  Copyright © 2018 Yedao Inc. All rights reserved.
//

import UIKit
import Foundation
public extension NumberFormatter {
    func formatString(from text: String) -> String? {
        if let decimial = Decimal(string: text) {
            let divisor = Decimal(sign: .plus, exponent: maximumFractionDigits, significand: 1)
            var (lhs, rhs) = (decimial, divisor)
            var result = Decimal()
            NSDecimalDivide(&result, &lhs, &rhs, .up)
            return string(from: NSDecimalNumber(decimal: result))
        }
        return nil
    }
}
public class CurrencyTextField : UITextField, UITextFieldDelegate {
    public var numberFormatter : NumberFormatter?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        keyboardType = .numberPad
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        keyboardType = .numberPad
    }
    
    // MARK: UITextFieldDelegate
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if numberFormatter == nil {
            let canonical = NSLocale.canonicalLocaleIdentifier(from: "en_US@currency=USD")
            let locale = Locale(identifier: canonical)
            numberFormatter = NumberFormatter()
            numberFormatter?.locale = locale
            // `$.00` -> `$0.00`
            numberFormatter?.minimumIntegerDigits = 1
            numberFormatter?.maximumFractionDigits = 2
            numberFormatter?.minimumFractionDigits = 2
            numberFormatter?.groupingSeparator = locale.groupingSeparator
            numberFormatter?.decimalSeparator = locale.decimalSeparator
            numberFormatter?.numberStyle = .decimal
        }
        if let formatter = numberFormatter, let txt = textField.text {
            var result = NSString(string: txt).replacingCharacters(in: range, with: string)
            if result.hasPrefix(formatter.currencySymbol ?? "$") == false { return false }
            result = NSString(string: result).substring(from: formatter.currencySymbol.count)
            result = result.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            if let res = formatter.formatString(from: result) {
                let resultText = formatter.currencySymbol + res
                if string.isEmpty {
                    // remove operation
                    if range.length == 1 {
                        let removeText = NSString(string: txt).substring(with: range)
                        if removeText == formatter.groupingSeparator || removeText == formatter.decimalSeparator {
                            let newRange : NSRange = NSRange(location: range.location - 1, length: 2)
                            return self.textField(textField, shouldChangeCharactersIn: newRange, replacementString: string)
                        } else {
                            updateTextField(textField, by: resultText)
                        }
                    } else {
                        updateTextField(textField, by: resultText)
                    }
                } else {
                    // insert operation
                    // 1. verify insert content, number type
                    if let _ = UInt(string) {
                        updateTextField(textField, by: resultText)
                    }
                }
            }
        }
        return false
    }
    private func updateTextField(_ textField : UITextField, by updatedContent : String) {
        if let txt = textField.text {
            let start = selectedTextRange?.start
            let previousLength = txt.count
            let currentLength = updatedContent.count
            let delta = currentLength - previousLength
            text = updatedContent
            if let s = start {
                // reset insertion point postion
                // https://blog.csdn.net/u011113204/article/details/52527390
                if let position = position(from: s, offset: delta) {
                    selectedTextRange = textRange(from: position, to: position)
                }
            }
        }
    }
}
