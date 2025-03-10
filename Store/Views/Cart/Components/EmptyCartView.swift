//
//  EmptyCartView.swift
//  Store
//
//  Created by Don Arias Agokoli on 31/01/2025.
//

// MARK: - 技术要点
// 1. 视图结构
// - 使用VStack构建垂直布局
// - 集成系统图标和文本组件
// - 实现简洁的空购物车提示界面
//
// 2. 用户体验
// - 清晰的视觉反馈
// - 友好的提示信息
// - 合理的间距和布局
//
// 3. 本地化支持
// - 支持多语言文本显示
// - 适配不同语言的布局
// - 维护统一的文本样式
//
// 4. 样式定制
// - 自定义图标大小和颜色
// - 统一的文本样式设置
// - 响应式的padding调整

// 导入SwiftUI框架，用于构建用户界面
import SwiftUI

// 空购物车视图组件
// 当购物车中没有商品时显示的提示界面
struct EmptyCartView: View {
    // 视图主体，定义UI结构和布局
    var body: some View {
        // 使用垂直堆栈布局组织视图元素，设置元素间距为20
        VStack(spacing: 20) {
            // 显示购物车图标
            // 使用系统提供的SF Symbols图标集
            Image(systemName: "cart")
                .font(.system(size: 60)) // 设置图标大小为60pt
                .foregroundColor(.gray) // 设置图标颜色为灰色
            
            // 显示空购物车主标题
            // 法语文本："您的购物车是空的"
            Text("Votre panier est vide")
                .font(.title2) // 使用二级标题字体
                .bold() // 应用粗体样式
            
            // 显示空购物车副标题/提示文本
            // 法语文本："将商品添加到购物车开始购物"
            Text("Ajoutez des articles à votre panier pour commencer vos achats")
                .multilineTextAlignment(.center) // 多行文本居中对齐
                .foregroundColor(.gray) // 设置文本颜色为灰色
        }
        .padding() // 为整个VStack添加内边距
    }
}
