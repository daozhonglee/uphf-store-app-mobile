//
//  StoreApp.swift
//  Store
//
//  Created by Don Arias Agokoli on 23/12/2024.
//

// MARK: - 技术要点
// 1. SwiftUI应用程序入口
// - @main 标记表示这是应用程序的入口点
// - 使用 SwiftUI 的 App 协议定义应用程序结构
//
// 2. Firebase集成
// - 使用 FirebaseCore 进行 Firebase 服务的初始化
// - 在 init() 中调用 FirebaseApp.configure() 初始化 Firebase
//
// 3. Stripe支付集成
// - 导入 StripeApplePay 用于处理 Apple Pay 支付
// - 在 AppDelegate 中配置 Stripe API Key
//
// 4. 依赖注入
// - 使用 @StateObject 管理视图模型的生命周期
// - 通过 environmentObject 实现依赖注入
//
// 5. UIKit 集成
// - 使用 UIApplicationDelegate 处理应用程序生命周期事件
// - @UIApplicationDelegateAdaptor 将 UIKit 的 AppDelegate 与 SwiftUI 集成

// 导入必要的框架
import SwiftUI          // SwiftUI框架，用于构建用户界面
import FirebaseCore     // Firebase核心功能
import StripeApplePay   // Stripe支付功能

// MARK: - AppDelegate
// UIKit 应用程序代理类
// 负责处理应用程序级别的事件和配置
class AppDelegate: NSObject, UIApplicationDelegate {
    // 应用程序启动完成时调用的方法
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // 配置 Stripe API Key
        // 初始化 Stripe 支付服务的公钥
        StripeAPI.defaultPublishableKey = "pk_test_oKhSR5nslBRnBZpjO6KuzZeX"
        
        return true
    }
}

// MARK: - 主应用程序结构
// 应用程序的主要入口点
@main
struct StoreApp: App {
    // 将 UIKit 的 AppDelegate 与 SwiftUI 应用程序集成
    // 使用 @UIApplicationDelegateAdaptor 属性包装器关联 AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // 创建身份验证视图模型的状态对象
    // @State 用于在 SwiftUI 中管理值类型的状态
    @State var authViewModel: AuthViewModel
    
    // 初始化方法
    // 在应用程序启动时调用
    init(){
        // 配置 Firebase
        // 初始化 Firebase 服务，必须在使用任何 Firebase 功能之前调用
        FirebaseApp.configure()
        
        // 初始化身份验证视图模型
        // 创建一个新的 AuthViewModel 实例
        self.authViewModel = AuthViewModel()
    }
    
    // 定义应用程序的根视图
    // 返回应用程序的主要场景配置
    var body: some Scene {
        WindowGroup {
            // 设置 ContentView 作为根视图
            ContentView()
                // 将 authViewModel 注入到视图层次结构中
                // 使其可以被所有子视图访问
                .environmentObject(authViewModel)
        }
    }
}
