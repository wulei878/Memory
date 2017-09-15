//
//  XGConstaints.swift
//  XGCG
//
//  Created by Sean on 15/4/12.
//  Copyright (c) 2015年 Sean. All rights reserved.
//

import UIKit

extension UIColor {
	class func color(_ hexColor: Int) -> UIColor {
		return UIColor.colorWithAlpha(hexColor, alpha: 1.0)
	}

	class func colorWithAlpha(_ hexColor: Int, alpha: CGFloat) -> UIColor {
		let red = CGFloat((hexColor & 0xff0000) >> 16) / 255.0
		let green = CGFloat((hexColor & 0x00ff00) >> 8) / 255.0
		let blue = CGFloat(hexColor & 0x0000ff) / 255.0
		return UIColor(red: red, green: green, blue: blue, alpha: alpha)
	}

	class func RGBColor(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
		return UIColor(red: red, green: green, blue: blue, alpha: 1)
	}

	class func RGBColorWithAlpha(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
		return UIColor(red: red, green: green, blue: blue, alpha: alpha)
	}
}

extension UIImage {
	class func imageWithColor(_ color: UIColor) -> UIImage {
		let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()!
		context.setFillColor(color.cgColor)
		context.fill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image!
	}
}

extension UIImageView {
	func clipsToRound() {
		clipsWithCornerRadius(frame.size.height / 2)
	}

	func clipsWithCornerRadius(_ cornerRadius: CGFloat) {
		clipsToBounds = true
		backgroundColor = UIColor.clear
		layer.cornerRadius = cornerRadius
		layer.borderWidth = 1.0
		layer.borderColor = UIColor.white.cgColor
	}
}

extension UIButton {
	class func roundCornerButtons(_ backgroundColor: UIColor, buttons: [UIButton]) {
		for button: UIButton in buttons {
			button.roundCornerButton(backgroundColor)
		}
	}

	func roundCornerButton(_ backgroundColor: UIColor) {
		layer.masksToBounds = true
		layer.cornerRadius = frame.height / 2
		setBackgroundImage(UIImage.imageWithColor(backgroundColor), for: UIControlState())
	}

	class func verticalCenterButtonsWithSpacing(_ spacing: CGFloat, buttons: [UIButton]) {
		for button: UIButton in buttons {
			button.verticalCenterButtonWithSpacing(spacing)
		}
	}

	func verticalCenterButtonWithSpacing(_ spacing: CGFloat) {
		titleEdgeInsets = UIEdgeInsetsMake(currentImage!.size.height + spacing, -currentImage!.size.width, 0.0, 0.0)
        titleLabel!.sizeToFit()
		imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, titleLabel!.frame.size.height + spacing, -titleLabel!.frame.width)
	}

	class func horizontalCenterButtonsWithSpacing(_ spacing: CGFloat, buttons: [UIButton]) {
		for button: UIButton in buttons {
			button.horizontalCenterButtonWithSpacing(spacing)
		}
	}

	func horizontalCenterButtonWithSpacing(_ spacing: CGFloat) {
		titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0.0, 0.0)
		imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0, spacing)
	}
    
    func titleFirstHorizontalCenterButtonWithSpacing(_ spacing: CGFloat) {
        titleLabel!.sizeToFit()
        titleEdgeInsets = UIEdgeInsetsMake(0.0, -currentImage!.size.width-spacing, 0, spacing)
        imageEdgeInsets = UIEdgeInsetsMake(0, titleLabel!.frame.size.width + spacing, 0.0, -titleLabel!.frame.width-spacing)
    }

	func setBackgroundColor(_ color: UIColor, forState state: UIControlState) {
		setBackgroundImage(UIImage.imageWithColor(color), for: state)
	}
    
    func setCommonButton() {
        setTitleColor(UIColor.white, for: .normal)
        setBackgroundColor(UIColor.color(0xF58B35), forState: .normal)
        layer.cornerRadius = 4
        clipsToBounds = true
    }
}

extension Date {
	func dateToTimeInterval() -> TimeInterval {
		return timeIntervalSince1970
	}

	static func timeIntervalToDate(_ time: TimeInterval) -> Date {
		return Date(timeIntervalSince1970: time)
	}

	static func secondIntervalToDate(_ time: TimeInterval) -> Date {
		return Date(timeIntervalSince1970: time)
	}

	static func secondIntervalToTimeString(_ time: TimeInterval, format: String) -> String {
		return Date.dateToTimeString(secondIntervalToDate(time), format: format)
	}

	static func dateToTimeString(_ date: Date, format: String) -> String {
		let dateFormtter = DateFormatter()
		dateFormtter.dateFormat = format
		return dateFormtter.string(from: date)
	}

	static func timeStringToDate(_ time: String, format: String) -> Date {
		let dateFormtter = DateFormatter()
		dateFormtter.dateFormat = format
		return dateFormtter.date(from: time)!
	}

	static func localTime(_ date: Date) -> Date {
		let dateFormtter = DateFormatter()
		dateFormtter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let sec = 8 * 60 * 60
		dateFormtter.timeZone = TimeZone.autoupdatingCurrent
		return date.addingTimeInterval(TimeInterval(sec))
	}

	static func startTimeOfDate(_ date: Date) -> Date {
		let dateFormtter = DateFormatter()
		dateFormtter.dateFormat = "yyyy-MM-dd 00:00:00"
		let dateStr = dateFormtter.string(from: date)
		return Date.localTime(dateFormtter.date(from: dateStr)!)
	}
}

struct BARegexHelper {
	var regex: NSRegularExpression?

	init(pattern: String) {
		do {
			try regex = NSRegularExpression(pattern: pattern, options: .caseInsensitive)
		} catch _ {
		}
	}

	func match(_ input: String) -> Bool {
		if let matches = regex?.matches(in: input,
			options: .reportCompletion,
			range: NSMakeRange(0, input.characters.count)) {
				return matches.count > 0
		} else {
				return false
		}
	}
}

extension String {
    func toInt() -> Int {
        var int: Int?
        if let doubleValue = Int(self) {
            int = Int(doubleValue)
        }
        if int == nil
        {
            return 0
        }
        return int!
    }
}

public extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

func += <KeyType, ValueType> (left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
	for (k, v) in right {
		left.updateValue(v, forKey: k)
	}
}

func DebugLog(_ msg: String) {
	#if DEBUG
		NSLog(msg)
	#endif
}

/// 角度转弧度.
///
/// - parameter angle: 角度
/// - returns:  弧度
func transToRadian(_ angle: CGFloat) -> CGFloat {
	return angle * CGFloat(Double.pi) / 180
}

/// 根据角度，半径计算X坐标.
///
/// - parameter radius: 半径
/// - parameter rangle: 角度
/// - returns:  X坐标
func parseToX(_ radius: CGFloat, angle: CGFloat) -> CGFloat {
	let tempRadian = transToRadian(angle)
	return radius * cos(tempRadian)
}

/// 根据角度，半径计算Y坐标.
///
/// - parameter radius: 半径
/// - parameter rangle: 角度
/// - returns:  Y坐标
func parseToY(_ radius: CGFloat, angle: CGFloat) -> CGFloat {
	let tempRadian = transToRadian(angle)
	return radius * sin(tempRadian)
}

/// 根据开始颜色和最终颜色，再加上百分比，计算渐变色值.
///
/// - parameter fraction: 当前颜色百分比，0-1
/// - parameter startValue: 开始色值
/// - parameter endValue: 结束色值
/// - returns:  当前渐变色值
func evaluate(_ fraction: CGFloat, startValue: Int, endValue: Int) -> Int {
	let startA = (startValue >> 24) & 0xff
	let startR = (startValue >> 16) & 0xff
	let startG = (startValue >> 8) & 0xff
	let startB = startValue & 0xff
	let endA = (endValue >> 24) & 0xff
	let endR = (endValue >> 16) & 0xff
	let endG = (endValue >> 8) & 0xff
	let endB = endValue & 0xff
	let resultA = Int(CGFloat(startA) + fraction * CGFloat(endA - startA)) << 24
	let resultR = Int(CGFloat(startR) + fraction * CGFloat(endR - startR)) << 16
	let resultG = Int(CGFloat(startG) + fraction * CGFloat(endG - startG)) << 8
	let resultB = Int(CGFloat(startB) + fraction * CGFloat(endB - startB))
	return resultA | resultR | resultG | resultB
}
