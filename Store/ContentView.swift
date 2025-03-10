//
//  ContentView.swift
//  Store
//
//  Created by Don Arias Agokoli on 23/12/2024.
//

// MARK: - 技术要点
// 1. SwiftUI视图结构
// - 使用 View 协议定义主视图
// - 采用声明式UI编程范式
//
// 2. 状态管理
// - @AppStorage 用于持久化存储用户偏好设置
// - 使用 UserDefaults 存储引导页显示状态
//
// 3. 条件渲染
// - 使用 if-else 语句进行视图的条件渲染
// - 根据 hasSeenOnboarding 状态决定显示引导页或主页
//
// 4. 视图组织
// - OnboardingView 处理首次使用的引导流程
// - MainTabView 包含应用的主要功能模块
//
// 5. 预览支持
// - 使用 #Preview 宏支持 SwiftUI 预览功能
// - 便于开发时实时查看UI效果

import SwiftUI

struct ContentView: View {
    // 使用 @AppStorage 持久化存储是否显示引导页
    // 这个值会被存储在 UserDefaults 中
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
       
    // 视图主体
    // 根据 hasSeenOnboarding 状态决定显示内容
    var body: some View {
        if !hasSeenOnboarding {
            // 首次使用时显示引导页
            OnboardingView()
        } else {
            // 已经查看过引导页，显示主页面
            MainTabView()
        }
    }
    
    // 初始化方法
    // 用于进行一些初始化配置
    init(){
        // 字体调试代码（已注释）
        // 用于列出系统所有可用字体
//        for family in UIFont.familyNames {
//            print(family)
//            
//            for name in UIFont.fontNames(forFamilyName: family) {
//                print(name)
//            }
//        }
    }
}

// SwiftUI 预览
// 使用新的预览宏语法
#Preview {
    ContentView()
}
