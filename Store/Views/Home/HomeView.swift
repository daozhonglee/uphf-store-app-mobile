//
//  Home.swift
//  market
//
//  Created by Don Arias Agokoli on 23/12/2024.
//

// MARK: - 技术要点
// 1. 视图结构
// - 使用VStack构建主页垂直布局
// - 集成配送地址、搜索栏、轮播图等组件
// - 实现滚动视图展示商品分类和列表
//
// 2. 状态管理
// - @EnvironmentObject注入认证状态
// - 实现用户登录状态的响应式更新
//
// 3. 导航系统
// - 使用NavigationLink实现页面跳转
// - 集成搜索功能的导航
//
// 4. 组件化设计
// - 拆分视图组件提高复用性
// - 优化视图层次结构
// - 实现模块化的页面布局

// 导入SwiftUI框架，用于构建用户界面
import SwiftUI

// 主页视图结构体
// 作为应用的主要入口页面，集成了多个功能组件
struct HomeView: View {
    // 使用@EnvironmentObject注入认证视图模型
    // 用于管理用户登录状态和相关操作
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // 视图主体，定义UI结构和布局
    var body: some View {
        // 使用垂直堆栈布局组织主页元素
        // spacing: 0 表示元素之间没有间距
        VStack(spacing: 0) {
            // 添加配送地址视图组件
            // 显示用户当前的配送地址信息
            DeliveryAddressView()
    
            // 创建到搜索页面的导航链接
            // 点击搜索栏时跳转到搜索页面
            NavigationLink(destination: SearchView()) {
                // 搜索栏组件，使用常量空字符串和空回调函数
                // 仅作为视觉元素，实际搜索功能在SearchView中实现
                SearchBar(text: .constant(""), onSearch: {})
            }
            // 为搜索栏添加水平内边距
            .padding(.horizontal)
            
            // 创建可滚动视图容器
            // 包含轮播图、分类和商品列表
            ScrollView {
                // 添加轮播图组件并设置内边距
                BannerView().padding()
                // 添加分类视图组件并设置垂直内边距
                CategoryView().padding(.vertical)
                // 添加商品视图组件并设置垂直内边距
                ProductView().padding(.vertical)
            }
        }
        
        // 视图出现时的生命周期回调
        // 可以在此处添加数据加载或状态更新逻辑
        .onAppear {
            // 注释掉的代码：检查用户是否已登录，如果已登录则获取客户信息
            // if(authViewModel.isLoggedIn){
            //     authViewModel.fetchCustomer()
            // }
        }
        
    }
}
