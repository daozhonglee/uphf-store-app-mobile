//
//  AuthViewModel.swift
//  Store
//
//  Created by Don Arias Agokoli on 07/02/2025.
//

// MARK: - 技术要点
// 1. 身份验证状态管理
// - 使用@MainActor确保UI更新在主线程执行
// - 实现ObservableObject支持状态绑定
// - 管理登录状态和用户信息
//
// 2. Firebase集成
// - 集成FirebaseAuth实现身份验证
// - 使用Firestore存储用户数据
// - 处理认证状态变化监听
//
// 3. Apple登录集成
// - 支持Sign in with Apple功能
// - 处理授权回调和用户信息
//
// 4. 错误处理
// - 实现统一的错误提示机制
// - 处理网络和认证错误
//
// 5. 状态同步
// - 在视图层和数据层之间同步认证状态
// - 管理用户会话生命周期

// 导入所需的框架
import Foundation
import FirebaseAuth          // Firebase认证服务
import AuthenticationServices // Apple登录支持
import SwiftUICore           // UI核心组件
import FirebaseFirestore     // Firebase数据库

// @MainActor确保所有UI更新操作都在主线程执行
// 这是Swift并发编程中的重要特性，可以避免多线程导致的UI更新问题
@MainActor
// 实现ObservableObject协议，支持SwiftUI的数据绑定机制
class AuthViewModel: ObservableObject {
    
    // 认证状态枚举，定义用户的登录状态
    // signedIn: 用户已登录
    // signedOut: 用户未登录
    enum AuthState{
        case signedIn  // 已登录状态
        case signedOut // 未登录状态
    }
    
    // 加载状态标志，用于显示加载指示器
    // 在进行异步操作时设置为true，完成后设置为false
    @Published var isLoading = false
    
    // 当前登录用户的客户信息
    // 包含用户ID、姓名、邮箱等详细信息
    @Published var customer:Customer?
    
    // 控制是否导航到认证视图的状态
    // 当需要用户登录时设置为true
    @Published var navigateToAuthView = false
    
    // 是否显示警告框的状态
    // 用于显示错误信息或操作结果
    @Published var showAlert = false
    
    // 警告消息内容
    // 显示给用户的具体提示信息
    @Published var alertMessage = ""
    
    // 认证仓储接口，用于处理认证相关操作
    // 通过依赖注入方式注入，支持不同的实现方式
    private var authRepository: AuthRepository
    
    // 当前认证状态，默认为未登录
    // 用于跟踪用户的登录状态变化
    var authState: AuthState = .signedOut
    
    // Firebase用户对象，包含用户的基本信息
    // 如UID、邮箱、显示名称等
    var user: User? = nil
    
    // Firebase认证状态监听器句柄
    // 用于监听用户登录状态的变化
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    // Firestore数据库实例
    // 用于访问用户数据集合
    private let db = Firestore.firestore()
    
    // 用户数据集合名称
    // 在Firestore中存储用户信息的集合
    private let collection = "users"
    
    // 初始化方法，支持依赖注入
    // 默认使用FirebaseAuthRepository作为认证仓储
    // 在初始化时配置认证状态监听器并检查当前认证状态
    init(repository: AuthRepository = FirebaseAuthRepository()) {
        self.authRepository = repository
        configureAuthStateListener() // 配置认证状态监听器
        checkAuthState()            // 检查当前认证状态
        //self.isLoggedIn = authRepository.isUserLoggedIn()
    }
    
    // 配置Firebase认证状态监听器
    // 监听用户登录状态的变化，并相应更新视图模型状态
    // 当用户登录或登出时自动触发回调
    private func configureAuthStateListener() {
        // 添加Firebase认证状态变化监听器
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            // 使用弱引用避免循环引用
            guard let self = self else { return }
            
            // 根据用户对象是否存在判断登录状态
            if let user = user {
                // 用户已登录，更新状态并获取用户详细信息
                self.authState = .signedIn
                fetchCustomer(user.uid) // 获取用户详细信息
            } else {
                // 用户未登录，更新状态为登出
                self.authState = .signedOut
            }
            
            // 打印认证状态变化日志
            print("Auth State changed: \(self.authState)")
        }
    }
    
    /// 检查当前认证状态
    /// 在应用启动或恢复时调用，确定用户是否已登录
    /// 如果用户已登录，获取用户信息并更新状态
    func checkAuthState() {
        // 检查Firebase当前是否有登录用户
        if let currentUser = Auth.auth().currentUser {
            // 存储用户对象
            self.user = currentUser
            // 获取用户的详细客户信息
            fetchCustomer(currentUser.uid)
            // 更新认证状态为已登录
            self.authState = .signedIn
        } else {
            // 无登录用户，设置状态为未登录
            self.authState = .signedOut
        }
    }
    
    /// 使用Apple ID登录
    /// - Parameters:
    ///   - authorization: Apple授权结果
    ///   - nonce: 安全随机字符串，用于防止重放攻击
    /// 处理Apple登录流程并保存用户信息
    func signInWithApple(_ authorization: ASAuthorization, _ nonce: String?) {
        // 设置加载状态，显示加载指示器
        isLoading = true
        // 创建异步任务处理登录流程
        Task {
            // 调用仓储层的Apple登录方法
            authRepository.signInWithApple(authorization: authorization, nonce: nonce){ result in
                switch result {
                case .success(let user):
                    // 登录成功，保存用户信息到数据库
                    self.authRepository.saveCustomer(user: user){ response in
                        switch response {
                        case .success:
                            // 用户信息保存成功，重新配置认证状态监听器
                            self.configureAuthStateListener()
                        case .failure(let error):
                            // 用户信息保存失败，显示错误信息
                            self.navigateToAuthView = false
                            self.isLoading = false
                            self.showAlert = true
                            self.alertMessage = error.localizedDescription
                        }
                    }
                    break
                case .failure(_):
                    // 登录失败处理
                    break
                }
            }
        }
    }
    
    /// 获取用户详细信息
    /// - Parameter userId: 用户唯一标识符
    /// 从数据库获取用户的详细客户信息
    /// 更新视图模型中的客户信息状态
    func fetchCustomer(_ userId:String) {
        // 创建异步任务获取用户信息
        Task { [weak self] in
            // 使用弱引用避免循环引用
            guard let self = self else { return }
            do {
                // 从仓储层异步获取用户详细信息
                let details = try await self.authRepository.getCustomer(userId)
                // 在主线程更新UI状态
                await MainActor.run {
                    // 更新客户信息
                    self.customer = details
                    // 关闭加载指示器
                    self.isLoading = false
                    // 不再需要导航到认证视图
                    self.navigateToAuthView = false
                }
            } catch {
                // 获取用户信息失败，打印错误日志
                print("Failed to fetch user details: \(error)")
                // 在主线程更新错误信息
                await MainActor.run {
                    self.alertMessage = "Failed to fetch user details"
                }
            }
        }
        
        
        
        //        // Mettre isLoading à true avant de commencer la tâche
        //        self.isLoading = true
        //
        //        Task {
        //            do {
        //                // Vérifiez si l'utilisateur est connecté
        //                guard let currentUser = Auth.auth().currentUser else {
        //                    throw NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
        //                }
        //
        //                // Récupérer le client
        //                self.customer = try await self.authRepository.getCustomer(currentUser.uid)
        //                self.isLoading = false
        //                self.navigateToAuthView = false
        //                self.isLoggedIn = true
        //            } catch {
        //                // Gérer les erreurs
        //                DispatchQueue.main.async {
        //                    self.showAlert = true
        //                    self.alertMessage = error.localizedDescription
        //                    self.isLoading = false // Assurez-vous de mettre isLoading à false en cas d'erreur
        //                }
        //            }
        //        }
    }
    
    
    /// 用户登出
    /// 调用认证仓储的登出方法，清除当前用户会话
    /// 更新UI状态并处理可能的错误
    func logout() {
        Task {
            do {
                // 异步调用登出方法
                try await authRepository.logout()
                // 关闭加载指示器
                self.isLoading = false
                // 认证状态会通过监听器自动更新
            } catch {
                // 登出失败，打印错误信息
                print("Failed to sign in with Apple: \(error)")
            }
        }
    }
    
    // 注释掉的方法，原用于检查用户是否已登录
    // 现在使用更完善的authState枚举和监听器代替
//    func isUserLoggedIn() {
//        self.isLoggedIn = Auth.auth().currentUser != nil
//    }
    
}



