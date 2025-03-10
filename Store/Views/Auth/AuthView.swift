//
//  AuthView.swift
//  Store
//
//  Created by Don Arias Agokoli on 07/02/2025.
//

// MARK: - 技术要点
// 1. Apple登录集成
// - 使用 AuthenticationServices 框架实现 Sign in with Apple
// - 通过 SignInWithAppleButton 提供标准登录按钮
// - 处理授权结果和用户信息
//
// 2. 安全认证
// - 使用 CryptoKit 生成安全的随机nonce
// - 实现 SHA256 哈希加密
// - 防止重放攻击和确保请求合法性
//
// 3. 状态管理
// - 使用 @EnvironmentObject 注入认证视图模型
// - 通过 @State 管理本地nonce状态
// - 处理加载状态显示
//
// 4. 用户体验
// - 提供清晰的视觉反馈
// - 优化加载状态展示
// - 实现无缝的认证流程

// 导入SwiftUI框架，用于构建用户界面
import SwiftUI
// 导入Apple认证服务SwiftUI扩展，提供SignInWithAppleButton组件
import _AuthenticationServices_SwiftUI
// 导入加密工具包，用于生成安全哈希
import CryptoKit
// 导入Apple认证服务框架，处理授权流程
import AuthenticationServices
// 导入Firebase认证模块，用于处理登录后的用户管理
import FirebaseAuth

// 认证视图结构体，实现Apple登录界面
struct AuthView: View {
    // 从环境中获取认证视图模型，用于处理登录逻辑和状态管理
    @EnvironmentObject var authViewModel: AuthViewModel
    // 本地状态变量，存储随机生成的nonce值，用于防止重放攻击
    @State private var nonce: String?
    // 视图主体，定义UI布局和交互逻辑
    var body: some View {
        // 垂直堆栈布局，组织视图元素
        VStack {
            
            // 添加弹性空间，将内容推到底部
            Spacer()
            // 根据加载状态显示不同内容
            if authViewModel.isLoading {
                // 显示加载指示器
                ProgressView()
            } else {
                // 显示Apple登录按钮
                SignInWithAppleButton{ request in
                    // 生成安全随机nonce字符串
                    let nonce = AuthUtils.randomNonceString()
                    // 保存nonce到本地状态，用于后续验证
                    self.nonce = nonce
                    // 设置请求的权限范围，包括邮箱和全名
                    request.requestedScopes = [.email, .fullName]
                    // 将nonce进行SHA256哈希处理，增强安全性
                    request.nonce = AuthUtils.sha256(nonce)
                } onCompletion:{ result in
                    // 处理授权结果
                    switch result {
                    case .success(let authorization):
                        // 授权成功，调用视图模型的登录方法
                        authViewModel.signInWithApple(authorization, nonce)
                    case .failure(_):
                        // 授权失败，打印错误信息
                        print("error")
                        
                    }
                }.frame(height: 45) // 设置按钮高度为45
                    .clipShape(.capsule) // 应用胶囊形状裁剪
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)) // 设置内边距
                
            }
        }
        // 隐藏底部标签栏，保持界面简洁
        .toolbar(.hidden, for: .tabBar)
        // 为整个视图添加内边距
        .padding()
    }
}


