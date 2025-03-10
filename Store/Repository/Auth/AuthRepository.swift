//
//  AuthRepository.swift
//  Store
//
//  Created by Don Arias Agokoli on 07/02/2025.
//

// MARK: - 技术要点
// 1. 身份验证接口定义
// - 定义统一的认证仓储接口
// - 支持Apple登录认证流程
// - 实现用户数据的存取操作
//
// 2. Firebase集成
// - 与Firebase Auth服务集成
// - 管理用户认证状态
// - 处理用户数据的持久化
//
// 3. 错误处理
// - 使用Result类型处理异步操作结果
// - 定义统一的错误处理机制
// - 提供清晰的错误信息
//
// 4. 异步操作
// - 使用async/await处理异步认证流程
// - 支持异步数据获取和状态更新
//
// 5. 安全性
// - 实现安全的用户认证流程
// - 保护用户敏感信息
// - 遵循最佳安全实践

// 导入Apple认证服务框架，用于处理Sign in with Apple功能
import AuthenticationServices
// 导入Firebase认证模块，用于用户身份验证和管理
import FirebaseAuth

// 认证仓储协议，定义应用程序认证功能的接口
// 通过协议定义统一的认证操作，支持不同的实现方式
protocol AuthRepository {
    // 使用Apple ID进行登录的方法
    // 参数:
    // - authorization: Apple授权结果对象
    // - nonce: 安全随机字符串，用于防止重放攻击
    // - completion: 完成回调，返回登录结果(成功返回User对象，失败返回错误)
    func signInWithApple(authorization: ASAuthorization, nonce:String?, completion: @escaping (Result<User, Error>) -> Void)
    
    // 保存用户信息到数据库
    // 参数:
    // - user: Firebase用户对象，包含用户基本信息
    // - completion: 完成回调，返回操作结果(成功或失败)
    func saveCustomer(user: User, completion: @escaping (Result<Void, Error>) -> Void)
    
    // 根据用户ID获取详细的客户信息
    // 参数:
    // - id: 用户唯一标识符
    // 返回: 客户对象，包含详细的用户信息
    // 异常: 如果获取失败则抛出错误
    func getCustomer(_ id:String) async throws -> Customer
    
    // 用户登出方法
    // 清除当前用户的登录状态和会话信息
    // 异常: 如果登出过程中出现错误则抛出异常
    func logout() async throws
}
