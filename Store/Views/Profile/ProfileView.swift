//
//  ProfileView.swift
//  market
//
//  Created by Don Arias Agokoli
//

// MARK: - 技术要点
// 1. 用户状态管理
// - 使用@EnvironmentObject注入认证状态
// - 处理登录和登出状态切换
// - 维护用户会话状态
//
// 2. 导航功能
// - 实现订单历史查看
// - 集成页面间导航
// - 处理导航状态管理
//
// 3. UI布局设计
// - 使用Form构建设置列表
// - 实现响应式布局
// - 提供清晰的视觉反馈
//
// 4. 交互处理
// - 实现登出功能
// - 处理用户操作响应
// - 提供操作确认机制
//
// 5. 状态同步
// - 与全局认证状态同步
// - 处理状态变化的UI更新
// - 确保数据一致性

import SwiftUI

struct ProfileView: View {
    
    // 从环境中获取认证视图模型
    // 用于管理用户登录状态和相关操作
    @EnvironmentObject var authViewModel: AuthViewModel
    // 跟踪是否显示订单信息
    // 控制导航到订单页面的状态
    @State private var isOderInfo = false
    
    // 视图主体，定义UI结构和布局
    var body: some View {
        
        // 使用垂直堆栈布局组织视图元素
        VStack {
            
            // 根据认证状态显示不同内容
            // 使用switch语句处理不同的登录状态
            switch authViewModel.authState {
            case .signedIn:
                // 用户已登录状态下的界面
                // 显示订单历史和登出选项
                
                // 使用Form创建设置列表
                // 包含用户可访问的功能选项
                Form {
                    
                    // 创建到订单页面的导航链接
                    // 点击后跳转到订单历史页面
                    NavigationLink(destination: OrderView()){
                        // 水平布局显示订单文本
                        // 法语文本："我的订单"
                        HStack{
                            Text("Mes commandes")
                        }.onTapGesture {
                            // 点击时设置订单信息状态为true
                            // 触发导航到订单页面
                            self.isOderInfo = true
                        }
                    }
                    
                }
                
                // 添加弹性空间
                // 将上方内容和下方按钮分开
                Spacer()
                
                // 登出按钮
                // 点击后调用认证视图模型的登出方法
                Button(action: {
                    
                    // 执行登出操作
                    // 清除用户会话并更新UI状态
                    authViewModel.logout()
                    
                }) {
                    // 按钮外观设置
                    // 法语文本："退出登录"
                    Text("Déconnexion")
                        .foregroundColor(.red) // 文本颜色设为红色
                        .padding() // 添加内边距
                        .background(Color.gray.opacity(0.2)) // 设置半透明灰色背景
                        .cornerRadius(8) // 应用圆角
                    
                }
                .padding() // 为按钮添加外边距
                
                
            case.signedOut:
                // 用户未登录状态下的界面
                // 显示登录提示和按钮
                
                // 添加弹性空间
                // 将内容垂直居中
                Spacer()
                
                // 登录按钮
                // 点击后显示认证视图
                Button(action: {
                    // 设置导航到认证视图的状态为true
                    // 触发模态弹出认证页面
                    authViewModel.navigateToAuthView = true
                    
                }) {
                    
                    // 按钮外观设置
                    // 法语文本："登录以访问个人资料"
                    Text("Connecter vous pour accéder au profil")
                        .foregroundColor(.red) // 文本颜色设为红色
                        .padding() // 添加内边距
                        .background(Color.gray.opacity(0.2)) // 设置半透明灰色背景
                        .cornerRadius(8) // 应用圆角
                    
                    
                }
                .padding() // 为按钮添加外边距
            }
            
        }
        // 添加模态弹出认证视图
        // 当navigateToAuthView为true时显示
        .sheet(isPresented: $authViewModel.navigateToAuthView, content: {
            // 显示认证视图并设置高度为屏幕的15%
            // 创建小型登录表单弹窗
            AuthView().presentationDetents([.fraction(0.15)])
        })
        // 视图出现时的处理
        // 可以在此添加数据加载或状态更新逻辑
        .onAppear {
            
            
        }.navigationTitle("Mon Profil") // 设置导航栏标题为"我的个人资料"
        
    }
    
}


