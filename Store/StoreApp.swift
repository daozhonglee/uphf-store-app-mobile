//
//  StoreApp.swift
//  Store
//
//  Created by Don Arias Agokoli on 23/12/2024.
//

// SwiftUI 框架，用于构建用户界面
import SwiftUI
// Firebase 核心模块，用于初始化 Firebase 服务
import FirebaseCore
// Stripe Apple Pay 模块，用于处理 Apple Pay 支付
import StripeApplePay

// AppDelegate 类，遵循 NSObject 和 UIApplicationDelegate 协议，用于处理应用程序级别的事件
class AppDelegate: NSObject, UIApplicationDelegate {
    // 应用程序启动时调用的方法
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // 设置 Stripe API 的公钥，用于支付功能
        StripeAPI.defaultPublishableKey = "pk_test_oKhSR5nslBRnBZpjO6KuzZeX"
        
        return true
    }
}

// @main 标记这是应用程序的入口点
@main
struct StoreApp: App {
    // 使用 @UIApplicationDelegateAdaptor 将 AppDelegate 与 SwiftUI 生命周期集成
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    // 使用 @State 管理 AuthViewModel 的状态
    @State var authViewModel: AuthViewModel
    
    // 初始化方法
    init(){
        // 配置 Firebase
        FirebaseApp.configure()
        // 初始化认证视图模型
        self.authViewModel = AuthViewModel()
    }
    
    // 定义应用的场景结构
    var body: some Scene {
        // 创建窗口组
        WindowGroup {
            // 设置根视图为 ContentView
            ContentView()
                // 将 authViewModel 注入到环境中，使其可以被子视图访问
                .environmentObject(authViewModel)
            // Injection de l'AuthViewModel dans l'environnement
        }
    }
}
