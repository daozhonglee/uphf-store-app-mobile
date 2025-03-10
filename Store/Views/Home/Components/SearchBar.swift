//
//  SearchBar.swift
//  Store
//
//  Created by Don Arias Agokoli on 31/01/2025.
//

// MARK: - 技术要点
// 1. 搜索栏组件
// - 使用HStack构建水平布局的搜索栏
// - 集成系统图标和文本输入框
// - 实现简洁美观的搜索界面
//
// 2. 数据绑定
// - 使用@Binding实现双向数据绑定
// - 支持外部搜索文本的实时更新
// - 实现搜索回调函数的传递
//
// 3. 用户交互
// - 支持键盘搜索按钮触发搜索
// - 优化文本输入体验
// - 提供清晰的视觉反馈
//
// 4. 样式定制
// - 统一的圆角和背景设置
// - 响应式的内边距调整
// - 符合应用整体设计风格

// 导入SwiftUI框架，用于构建用户界面
import SwiftUI

// 搜索栏视图组件
// 提供可复用的搜索输入界面，支持文本绑定和搜索回调
struct SearchBar: View {
    // 使用@Binding创建与父视图的双向数据绑定，实现搜索文本的共享
    // 当用户输入文本时，父视图中的绑定变量也会同步更新
    @Binding var text: String
    // 搜索回调函数，当用户触发搜索时被调用
    // 允许父视图定义搜索操作的具体实现
    var onSearch: () -> Void
    
    // 视图主体，定义UI结构和布局
    var body: some View {
        // 使用水平堆栈布局组织搜索栏元素
        // 将搜索图标和文本输入框水平排列
        HStack {
            // 添加搜索放大镜图标
            // 使用SF Symbols系统图标库中的放大镜图标
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray) // 设置图标颜色为灰色
            // 创建文本输入框，绑定到text属性，并设置提交动作
            // 法语提示文本："搜索商品"
            TextField("Rechercher un produit", text: $text, onCommit:{
                onSearch() // 当用户按下键盘上的搜索按钮时触发搜索回调
            })
            .multilineTextAlignment(.leading) // 设置文本左对齐
        }
        .padding() // 为整个HStack添加内边距
        .background(Color(.systemGray6)) // 设置浅灰色背景
        .cornerRadius(10) // 添加圆角效果，提升视觉体验
    }
}
