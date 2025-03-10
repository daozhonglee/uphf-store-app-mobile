//
//  CartSummary.swift
//  Store
//
//  Created by Don Arias Agokoli on 31/01/2025.
//

// MARK: - 技术要点
// 1. 视图结构
// - 使用VStack和HStack构建布局
// - 实现总价和操作按钮的组合
// - 优化视图层次和组件复用
//
// 2. 状态管理
// - @EnvironmentObject注入认证状态
// - 响应式更新订单总额
// - 处理登录状态切换
//
// 3. 交互设计
// - 通过闭包处理订单和登录事件
// - 实现条件渲染的按钮状态
// - 优化用户操作流程
//
// 4. 样式定制
// - 自定义按钮样式和颜色
// - 统一的字体和间距设置
// - 响应式的布局适配

// 导入SwiftUI框架，提供构建用户界面所需的组件和功能
import SwiftUI

// 购物车摘要视图组件
// 显示购物车总价和操作按钮，根据用户登录状态显示不同的按钮
struct CartSummary: View {
    // 从环境中获取认证视图模型，用于检查用户登录状态
    @EnvironmentObject var authViewModel: AuthViewModel
    // 购物车总价，由父视图传入
    let total: Double
    
    // 定义两个闭包用于处理不同的用户操作
    // 下单操作的闭包，当用户点击下单按钮时调用
    var onOrder: () -> Void
    // 未登录状态下的操作闭包，当用户未登录点击按钮时调用
    var onNotLoggedIn: () -> Void
    
    // 视图主体，定义UI结构和布局
    var body: some View {
        
        // 使用垂直堆栈布局组织视图元素
        VStack {
            // 水平堆栈显示总价标签和金额
            HStack {
                // 显示"Total"标签
                Text("Total")
                    .font(.headline) // 使用标题字体样式
                Spacer() // 添加弹性空间，将两个Text推向两端
                // 显示格式化的总价金额，保留两位小数
                Text("\(String(format: "%.2f", total)) €")
                    .font(.title2) // 使用较大的字体
                    .bold() // 应用粗体样式
            }
            .padding() // 为HStack添加内边距
            
            // 根据用户登录状态显示不同的按钮
            if authViewModel.authState == .signedIn {
                // 用户已登录时显示下单按钮
                Button(action: {
                    onOrder() // 调用下单闭包函数
                }) {
                    // 按钮外观设置
                    Text("Commander") // 按钮文本"下单"
                        .font(.headline) // 使用标题字体
                        .foregroundColor(.white) // 文本颜色设为白色
                        .frame(maxWidth: .infinity) // 按钮宽度占满可用空间
                        .padding() // 添加内边距
                        .background(Color(hex: "67C4A7")) // 设置背景色为绿色
                        .cornerRadius(10) // 应用圆角
                }
                .padding() // 为按钮添加外边距
            } else {
                // 用户未登录时显示登录按钮
                Button(action: {
                    onNotLoggedIn() // 调用未登录状态的闭包函数
                }) {
                    // 按钮外观设置
                    Text("Se connecter pour commander") // 按钮文本"登录以下单"
                        .font(.headline) // 使用标题字体
                        .foregroundColor(.white) // 文本颜色设为白色
                        .frame(maxWidth: .infinity) // 按钮宽度占满可用空间
                        .padding() // 添加内边距
                        .background(Color(hex: "67C4A7")) // 设置背景色为绿色
                        .cornerRadius(10) // 应用圆角
                }
                .padding() // 为按钮添加外边距
            }
        }
    }
}

