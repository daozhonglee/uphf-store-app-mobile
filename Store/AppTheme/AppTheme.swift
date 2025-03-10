//
//  AppTheme.swift
//  Store
//
//  Created by Don Arias Agokoli on 23/12/2024.
//

// MARK: - 技术要点
// 1. 主题管理
// - 定义应用程序的全局主题样式
// - 统一管理颜色、字体、间距等UI元素
// - 支持主题切换和自定义
//
// 2. 颜色系统
// - 使用语义化命名的颜色变量
// - 支持深色模式适配
// - 提供品牌标准色和辅助色
//
// 3. 字体系统
// - 定义统一的字体家族
// - 支持动态字体大小
// - 提供预定义的文本样式

import SwiftUI

// 应用程序主题配置结构体
struct AppTheme {
    // MARK: - 颜色定义
    
    // 主要颜色
    static let primaryColor = Color("Primary")       // 品牌主色
    static let secondaryColor = Color("Secondary") // 次要颜色
    static let accentColor = Color("Accent")      // 强调色
    
    // 背景颜色
    static let backgroundColor = Color("Background")    // 主背景色
    static let surfaceColor = Color("Surface")        // 表面背景色
    static let cardColor = Color("Card")             // 卡片背景色
    
    // 文本颜色
    static let textPrimary = Color("TextPrimary")     // 主要文本色
    static let textSecondary = Color("TextSecondary") // 次要文本色
    static let textHint = Color("TextHint")          // 提示文本色
    
    // 状态颜色
    static let success = Color("Success")    // 成功状态色
    static let warning = Color("Warning")    // 警告状态色
    static let error = Color("Error")       // 错误状态色
    static let info = Color("Info")         // 信息状态色
    
    // MARK: - 字体定义
    
    // 标题字体
    static let titleLarge = Font.custom("GeneralSans-Bold", size: 24)
    static let titleMedium = Font.custom("GeneralSans-Semibold", size: 20)
    static let titleSmall = Font.custom("GeneralSans-Medium", size: 16)
    
    // 正文字体
    static let bodyLarge = Font.custom("GeneralSans-Regular", size: 16)
    static let bodyMedium = Font.custom("GeneralSans-Regular", size: 14)
    static let bodySmall = Font.custom("GeneralSans-Regular", size: 12)
    
    // MARK: - 间距定义
    
    // 基础间距
    static let spacingXS: CGFloat = 4    // 超小间距
    static let spacingS: CGFloat = 8     // 小间距
    static let spacingM: CGFloat = 16    // 中等间距
    static let spacingL: CGFloat = 24    // 大间距
    static let spacingXL: CGFloat = 32   // 超大间距
    
    // 内边距
    static let paddingS: CGFloat = 8     // 小内边距
    static let paddingM: CGFloat = 16    // 中等内边距
    static let paddingL: CGFloat = 24    // 大内边距
    
    // MARK: - 圆角定义
    
    // 圆角大小
    static let cornerRadiusS: CGFloat = 4   // 小圆角
    static let cornerRadiusM: CGFloat = 8   // 中等圆角
    static let cornerRadiusL: CGFloat = 16  // 大圆角
    
    // MARK: - 阴影定义
    
    // 卡片阴影
    static let cardShadow = Shadow(
        color: Color.black.opacity(0.1),
        radius: 10,
        x: 0,
        y: 4
    )
    
    // 浮动按钮阴影
    static let fabShadow = Shadow(
        color: Color.black.opacity(0.2),
        radius: 15,
        x: 0,
        y: 8
    )
}

// MARK: - 辅助类型

// 阴影配置结构体
struct Shadow {
    let color: Color    // 阴影颜色
    let radius: CGFloat // 阴影半径
    let x: CGFloat     // 水平偏移
    let y: CGFloat     // 垂直偏移
}

// Extension to define custom fonts
extension Font {
    static let generalSans = "GeneralSansVariable-Bold_Regular"
    
    static func customFont(_ name: String? = nil, size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName = name ?? generalSans
        return .custom(fontName, size: size).weight(weight)
    }
    
}
    // Theme structure to hold all styling information
    struct AppTheme {
        // Colors
        static let accent = Color("AccentColor", bundle: nil)
        static let foreground = Color(.black)
        
//        GeneralSansVariable-Bold_Regular
//        GeneralSansVariable-Bold_Extralight
//        GeneralSansVariable-Bold_Light
//        GeneralSansVariable-Bold_Medium
//        GeneralSansVariable-Bold_Semibold
//        GeneralSansVariable-Bold
        
        // Text Styles
        struct TextStyle {
            
            static func header1(fontName: String? = nil) -> TextStyle {
                TextStyle(
                    font: Font.customFont("GeneralSansVariable-Bold_Semibold", size: 64, weight: .semibold),
                    foregroundColor: foreground
                )
            }
            
            static func header2(fontName: String? = nil) -> TextStyle {
                TextStyle(
                    font: Font.customFont("GeneralSansVariable-Bold_Semibold", size: 32, weight: .semibold),
                    foregroundColor: foreground
                )
            }
            
            static func header3(fontName: String? = nil) -> TextStyle {
                TextStyle(
                    font: Font.customFont("GeneralSansVariable-Bold_Semibold", size: 24, weight: .semibold),
                    foregroundColor: foreground
                )
            }   
            static func header4(fontName: String? = nil) -> TextStyle {
                TextStyle(
                    font: Font.customFont("GeneralSansVariable-Bold_Medium", size: 20, weight: .medium),
                    foregroundColor: foreground
                )
            }
            
            static func body1(fontName: String? = nil) -> TextStyle {
                TextStyle(
                    font: Font.customFont("GeneralSansVariable-Bold_Regular", size: 16, weight: .regular),
                    foregroundColor: foreground
                )
            }
            
            static func body2(fontName: String? = nil) -> TextStyle {
                TextStyle(
                    font: Font.customFont("GeneralSansVariable-Bold_Regular", size: 14, weight: .regular),
                    foregroundColor: foreground
                )
            }
            static func body3(fontName: String? = nil) -> TextStyle {
                TextStyle(
                    font: Font.customFont("GeneralSansVariable-Bold_Regular", size: 12, weight: .regular),
                    foregroundColor: foreground
                )
            }
           
           
            
            static func button(fontName: String? = nil) -> TextStyle {
                TextStyle(
                    font: Font.customFont(fontName, size: 15, weight: .medium),
                    foregroundColor: foreground
                )
            }
            
        
          
            let font: Font
            let foregroundColor: Color
        }
    }

    // View modifier to apply text styles
    struct StyledText: ViewModifier {
        let style: AppTheme.TextStyle
        
        func body(content: Content) -> some View {
            content
                .font(style.font)
                .foregroundColor(style.foregroundColor)
        }
    }

    // Extension to make it easier to apply text styles
    extension View {
        func textStyle(_ style: AppTheme.TextStyle) -> some View {
            modifier(StyledText(style: style))
        }
    }
