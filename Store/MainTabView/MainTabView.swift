//
//  MainTabView.swift
//  market
//
//  Created by Don Arias Agokoli on 23/12/2024.
//

// MARK: - 技术要点
// 1. 导航架构
// - 使用 TabView 实现底部标签栏导航
// - 自定义 TabbedNavView 实现标签页导航栈管理
// - 支持标签页切换和状态保持
//
// 2. 状态管理
// - 使用 ObservableObject 实现标签状态监控
// - @StateObject 管理选中标签的状态
// - @EnvironmentObject 实现跨视图状态共享
//
// 3. 自定义导航
// - 实现标签页重置功能
// - 处理导航栈的清理和重建
// - 优化导航体验和性能
//
// 4. 界面定制
// - 自定义标签栏图标和文本
// - 配置主题色和视觉样式
// - 实现响应式布局
import SwiftUI

// 标签页监控类
// 使用ObservableObject协议实现可观察对象
// 用于跨视图共享和监控当前选中的标签页
class TabMonitor: ObservableObject {
    // 使用@Published发布选中标签的变化
    // 默认选中第一个标签（首页）
    @Published var selectedTab = 1
}


// 主标签视图
// 实现应用的主要导航结构
struct MainTabView: View {
    // 使用@StateObject创建标签监控实例
    // 管理标签页的选择状态
    @StateObject private var tabMonitor = TabMonitor()
    // 使用@State跟踪选中的标签
    // 用于备用的导航实现（当前未使用）
    @State private var selectedTab = "home"
    
    
    // 视图主体，定义UI结构和布局
    var body: some View {
        
        // 创建标签视图，绑定选中标签到tabMonitor
        // 实现底部标签栏导航
        TabView(selection: $tabMonitor.selectedTab) {
            
            // 首页标签
            // 使用自定义TabbedNavView包装HomeView
            // 实现导航栈管理和状态保持
            TabbedNavView(tag: 1) {
                
                    HomeView()
                
                
            }
            // 设置标签项图标和文本
            // 法语文本："首页"
            .tabItem {  Label("Accueil", image: "home") }
            .tag(1)
            
            
            
            // 搜索标签
            // 使用自定义TabbedNavView包装SearchView
            TabbedNavView(tag: 2) {
                
                    SearchView()
                
                
            }
            // 设置标签项图标和文本
            // 法语文本："搜索"
            .tabItem { Label("Rechercher", image: "search") }
            .tag(2)
            
            
            // 购物车标签
            // 使用自定义TabbedNavView包装CartView
            TabbedNavView(tag: 3) {
                
                    CartView()
                
            }
            // 设置标签项图标和文本
            // 法语文本："购物车"
            .tabItem { Label("Panier", image: "cart") }
            .tag(4)
            
            
            
            // 个人资料标签
            // 使用自定义TabbedNavView包装ProfileView
            TabbedNavView(tag: 4) {
                
                
                    ProfileView()
                
                
            }
            // 设置标签项图标和文本
            // 法语文本："您"
            .tabItem { Label("Vous", image: "user") }
            .tag(3)
            
            
            
        } // 设置标签栏强调色为应用主题色
        .accentColor(AppColors.primary)
        // 将tabMonitor注入环境，使其在子视图中可用
        .environmentObject(tabMonitor)
        
        
        
        
        // 注释掉的备用实现
        // 使用基本TabView和NavigationStack的替代方案
        //        TabView (selection: $selectedTab) {
        //
        //            NavigationStack{
        //                HomeView()
        //            }
        //            .tabItem {
        //                Label("Accueil", image: "home")
        //            }
        //
        //            NavigationStack{
        //                SearchView()
        //            }
        //            .tabItem {
        //                Label("Rechercher", image: "search")
        //            }
        //            NavigationStack{
        //                CartView()
        //            }
        //            .tabItem {
        //                Label("Panier", image: "cart")
        //            }
        //
        //            NavigationStack{
        //                ProfileView()
        //            }
        //            .tabItem {
        //                Label("Vous", image: "user")
        //            }
        //        }
        //        .accentColor(AppColors.primary)
        
    }
}

// 自定义标签导航视图
// 实现标签页内的导航栈管理
// 支持导航状态保持和重置功能
struct TabbedNavView: View {
    // 从环境中获取标签监控对象
    // 用于响应标签选择变化
    @EnvironmentObject var tabMonitor: TabMonitor
    
    // 当前标签的标识
    // 用于判断是否为当前选中的标签
    private var tag: Int
    // 包装的内容视图
    // 使用AnyView类型擦除保存任意视图类型
    private var content: AnyView
    
    // 初始化方法
    // 接收标签标识和内容视图构建器
    init(
        tag: Int,
        @ViewBuilder _ content: () -> any View
    ) {
        self.tag = tag
        // 将内容转换为AnyView类型
        // 允许存储任意类型的视图
        self.content = AnyView(content())
    }
    
    // 视图ID状态
    // 用于触发导航栈重置
    @State private var id = 1
    // 选中状态
    // 跟踪当前标签是否被选中
    @State private var selected = false
    
    // 视图主体，定义UI结构和布局
    var body: some View {
        // 创建导航栈
        // 管理标签内的页面导航
        NavigationStack {
            // 显示内容视图
            // 绑定ID用于重置导航栈
            content
                .id(id)
                // 监听标签选择变化
                // 处理标签切换和重置逻辑
                .onReceive(tabMonitor.$selectedTab) { selection in
                    if selection != tag {
                        // 当切换到其他标签时
                        // 重置选中状态
                        selected = false
                    } else {
                        // 当选中当前标签时
                        if selected {
                            // 如果已经选中，则通过改变ID触发导航栈重置
                            // 实现点击当前标签返回根视图的功能
                            id *= -1 //id change causes pop to root
                        }
                        
                        // 设置选中状态为true
                        selected = true
                    }
                } //.onReceive
        } //NavigationView
        // 设置导航视图样式为堆栈样式
        .navigationViewStyle(.stack)
    } //body
} //TabbedNavView
