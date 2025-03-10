//
//  OnboardingView.swift
//  market
//
//  Created by Don Arias Agokoli on 23/12/2024.
//

// MARK: - 技术要点
// 1. 引导页设计
// - 使用TabView实现滑动切换效果
// - 自定义页面指示器样式
// - 实现最后一页的完成按钮
//
// 2. 状态管理
// - 使用@AppStorage持久化存储引导页显示状态
// - @State管理当前页面索引
//
// 3. 用户体验
// - 清晰的视觉引导
// - 简洁的操作流程
// - 响应式布局适配

import SwiftUI

// 引导页数据模型
// 定义每个引导页的内容结构
struct OnboardingPage: Identifiable {
    let id = UUID()                // 唯一标识符，用于ForEach循环
    let image: String              // 图片资源名称
    let title: String              // 页面标题
    let description: String        // 页面描述文本
}

// 引导页主视图
// 用于首次启动应用时显示的引导页面
struct OnboardingView: View {
    // 使用@AppStorage持久化存储用户是否已查看引导页
    // 存储在UserDefaults中，应用重启后仍然有效
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    // 跟踪当前显示的页面索引
    @State private var currentPage = 0
    
    // 定义引导页内容数组
    // 包含三个页面：欢迎页、促销页和支付安全页
    private let pages: [OnboardingPage] = [
        OnboardingPage(image: "basket",
                       title: "Bienvenue sur notre boutique",
                       description: "Découvrez notre sélection de produits"),  // 欢迎页："欢迎来到我们的商店，发现我们的产品选择"
        OnboardingPage(image: "discount",
                       title: "Promotions exclusives",
                       description: "Profitez de nos offres spéciales"),       // 促销页："独家促销，享受我们的特别优惠"
        OnboardingPage(image: "payment",
                       title: "Paiement sécurisé",
                       description: "Payez en toute sécurité")                // 支付页："安全支付，完全安心地付款"
    ]
    
    // 视图主体
    // 构建引导页的UI结构和交互逻辑
    var body: some View {
        // 使用TabView创建可滑动的页面容器
        // 绑定currentPage状态变量实现页面切换
        TabView(selection: $currentPage) {
            // 遍历pages数组创建每个引导页
            ForEach(pages.indices, id: \.self) { index in
                // 每个页面的垂直布局容器
                VStack(spacing:20){
                    // 显示页面图片
                    Image(pages[index].image)
                        .resizable()                // 使图片可调整大小
                        .scaledToFit()              // 保持图片比例
                        .frame(width: 250, height: 267)  // 设置图片尺寸
                    
                    // 显示页面标题
                    Text(pages[index].title)
                        .fontWeight(.heavy)         // 设置粗体
                        .font(.system(size: 24))    // 设置字体大小
                    
                    // 显示页面描述文本
                    Text(pages[index].description)
                        .fontWeight(.light)         // 设置细体
                        .font(.system(size: 14))    // 设置字体大小
                        .padding(.bottom,15)        // 底部添加间距
                        .multilineTextAlignment(.center)  // 多行文本居中对齐
                    
                    // 仅在最后一页显示开始按钮
                    if index == pages.count - 1 {  
                        Button{
                            // 点击按钮时将hasSeenOnboarding设为true
                            // 这将触发ContentView中的条件渲染，显示主应用界面
                            hasSeenOnboarding = true
                            
                        }label: {
                            // 按钮内容：文本和图标的水平排列
                            HStack{
                                Text("Start")                      // 开始按钮文本
                                Image(systemName: "arrow.forward.circle")  // 前进箭头图标
                            }
                            .padding(.horizontal,25)              // 水平内边距
                            .padding(.vertical,12)                // 垂直内边距
                            .background(
                                Capsule().strokeBorder(lineWidth: 2)  // 胶囊形状边框
                            )
                            .foregroundColor(AppColors.primary)    // 使用应用主题色
                            
                        }.buttonStyle(.plain)  // 使用朴素按钮样式，移除默认按钮效果
                            
                    }}
                
                // 为每个页面设置标签，用于TabView的选择功能
                .tag(index)
            }
        }
        // 设置TabView样式为分页样式，支持滑动切换
        .tabViewStyle(PageTabViewStyle())
        // 设置页面指示器样式，始终显示在背景中
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}
