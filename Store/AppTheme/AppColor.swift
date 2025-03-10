//
//  AppColor.swift
//  Store
//
//  Created by Don Arias Agokoli on 23/12/2024.
//

// MARK: - 技术要点
// 1. 颜色系统设计
// - 定义应用程序的标准化颜色系统
// - 使用语义化命名规范
// - 支持品牌标识和视觉一致性
//
// 2. 颜色层级
// - 主色调系统（primary）
// - 灰度等级（900-100）
// - 功能色（成功、错误等）
//
// 3. 颜色转换
// - 支持十六进制颜色值转换
// - 提供RGB和透明度控制
// - 实现字符串和整数格式的颜色定义
//
// 4. 扩展性设计
// - Color扩展支持多种初始化方式
// - 便于主题定制和动态调整
// - 优化代码复用和维护性

import SwiftUI

// 应用程序颜色定义结构体
struct AppColors {
    // 主题色
    static let primary = Color(hex: "67C4A7")
    
    // 灰度系统（从深到浅）
    static let primary900 = Color(hex: 0x1A1A1A)
    static let primary800 = Color(hex: 0x333333)
    static let primary700 = Color(hex: 0x4D4D4D)
    
    // 主要灰度（设计中的蓝色突出显示）
    static let primary600 = Color(hex: 0x666666)
    static let primary500 = Color(hex: 0x808080)
    static let primary400 = Color(hex: 0x999999)
    
    // 浅灰度
    static let primary300 = Color(hex: 0xB3B3B3)
    static let primary200 = Color(hex: 0xCCCCCC)
    static let primary100 = Color(hex: 0xE6E6E6)
    static let white = Color(hex: 0xFFFFFF)
    
    // 功能色
    static let success = Color(hex: 0x0C9409)  // 成功状态（绿色）
    static let error = Color(hex: 0xED1010)    // 错误状态（红色）
}

// 颜色扩展：支持十六进制整数初始化
extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

// 颜色扩展：支持十六进制字符串初始化
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        
        Scanner(string: hex).scanHexInt64(&int)
        
        let r = Double((int & 0xFF0000) >> 16) / 255.0
        let g = Double((int & 0x00FF00) >> 8) / 255.0
        let b = Double(int & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
