//
//  FirebaseAuthRepository.swift
//  Store
//
//  Created by Don Arias Agokoli on 07/02/2025.
//

// MARK: - 技术要点
// 1. Firebase身份验证集成
// - 实现AuthRepository接口
// - 集成Firebase Authentication服务
// - 支持多种认证方式(邮箱、第三方登录)
//
// 2. 用户状态管理
// - 监听用户认证状态变化
// - 维护用户会话信息
// - 处理用户登录登出流程
//
// 3. Firestore数据库操作
// - 用户数据的CRUD操作
// - 使用异步函数处理数据库操作
// - 实现数据模型映射
//
// 4. 安全性考虑
// - 实现安全的身份验证流程
// - 保护用户敏感信息
// - 处理认证错误和异常
//
// 5. Stripe集成
// - 与支付系统集成
// - 管理用户支付信息
// - 处理支付相关操作

// 导入所需的框架
import FirebaseAuth          // Firebase认证服务
import AuthenticationServices // Apple登录服务
import Foundation           // 基础功能
import CryptoKit            // 加密功能
import FirebaseFirestore    // Firebase数据库
import SwiftUICore          // UI核心组件

// FirebaseAuthRepository类实现AuthRepository接口
// 提供基于Firebase的用户认证和数据管理功能
class FirebaseAuthRepository: AuthRepository {
   
    // Stripe支付仓储，用于处理支付相关操作
    private let stripeRepository: StripeRepository
    // Firestore数据库实例，用于存储和检索用户数据
    private let db = Firestore.firestore()
    // 用户集合名称，指定存储用户数据的Firestore集合
    private let collection = "users"
    
    // 当前用户对象，存储已登录用户的信息
    var user: User?
    // Firebase认证状态监听器句柄，用于监听用户登录状态变化
    private var authenticationStateHandle: AuthStateDidChangeListenerHandle?
    
    // 初始化方法，注入Stripe仓储依赖
    // 参数:
    // - repository: Stripe仓储实现，默认使用StripeRepositoryImpl
    init(repository: StripeRepository = StripeRepositoryImpl()) {
        self.stripeRepository = repository
        // 初始化完成后可以设置认证状态监听器
    }
    
  

    
    // 根据分类ID获取产品列表
    // 参数:
    // - categoryId: 分类ID
    // 返回: 产品数组
    func getProductByCategory(_ categoryId:String) async throws -> [Product] {
        // 异步查询Firestore数据库中符合条件的文档
        let snapshot = try await db.collection(collection).whereField("category", isEqualTo: categoryId).getDocuments()
        // 将文档数据映射为Product对象数组
        return try snapshot.documents.map { document in
            let product = try document.data(as: Product.self)
            return product
        }
    }
    
    // 根据用户ID获取客户信息
    // 参数:
    // - id: 用户ID
    // 返回: 客户对象
    func getCustomer(_ id: String) async throws -> Customer {
        // 异步获取指定ID的用户文档
        let documentSnapshot = try await db.collection(self.collection).document(id).getDocument()
        
        // 检查文档是否存在，不存在则抛出错误
        guard documentSnapshot.exists else {
            throw NSError(domain: "FirestoreError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Customer not found"])
        }
        
        // 将文档数据解码为Customer对象
        let customer = try documentSnapshot.data(as: Customer.self)
        print(".FirebaseAuthRepository.swift: getCustomer(): \(String(describing: customer))")
        return customer
    }
    
    // 保存或更新用户信息到Firestore
    // 参数:
    // - user: Firebase用户对象
    // - completion: 完成回调，返回成功或失败结果
    func saveCustomer(user: User, completion: @escaping (Result<Void, any Error>) -> Void) {
        
        // 查询用户文档是否已存在
        db.collection(self.collection).document(user.uid).getDocument { document, error in
            // 处理查询错误
            if let error = error as NSError? {
                completion(.failure(error))
            }
            else {
                // 如果文档存在，更新用户信息
                if document?.data() != nil {
                //let id = document.documentID
                  do {
                      //let id = document.documentID
                      //let data = document.data()
                      print("doc exist to get user==>\(String(describing: document))")
                     // print("doc id =>\(id)")
                     // print("doc data =>\(String(describing: data))")
                      // 更新用户文档中的姓名和邮箱字段
                      self.db.collection(self.collection).document(user.uid).updateData(
                          [
                              "name": user.displayName ?? "",
                              "email": user.email ?? ""
                          ]) { error in
                              // 处理更新结果
                              if let error = error {
                                  completion(.failure(error))
                              } else {
                                  completion(.success(()))
                              }
                          }
                  }
                  
              } else {
                  // 如果文档不存在，创建新的支付客户ID并保存用户信息
                  self.stripeRepository.createCustomerPaymentId { result in
                      switch result {
                      case .success(let id):
                          // 创建新的用户文档，包含用户ID、支付ID、姓名和邮箱
                          self.db.collection(self.collection).document(user.uid).setData(
                              [
                                  "id": user.uid,
                                  "paymentId": id,
                                  "name": user.displayName ?? "",
                                  "email": user.email ?? "",
                              ]) { error in
                                  // 处理创建结果
                                  if let error = error {
                                      completion(.failure(error))
                                  } else {
                                      completion(.success(()))
                                  }
                              }
                      case .failure( let error):
                          // 处理支付ID创建失败
                          completion(.failure(error))
                          
                          
                      }
                      
                  }
              }
            }
          }
        
        
        // 以下是早期实现版本的代码，已被优化替代
        // 保留作为参考和历史记录
        // 功能与当前实现相同，但代码结构略有不同
//        db.collection(self.collection).document(user.uid).getDocument { document, error in
//        
//            if (error as NSError?) != nil {
//                print("error get user==>\(String(describing: error))")
//            
//            }
//            else {
//                print("try to get user==>\(String(describing: document))")
//                if document != nil {
//                    do {
//                        print("doc exist to get user==>\(String(describing: document))")
//                        self.db.collection(self.collection).document(user.uid).updateData(
//                            [
//                                "name": user.displayName ?? "",
//                                "email": user.email ?? ""
//                            ]) { error in
//                                if let error = error {
//                                    completion(.failure(error))
//                                } else {
//                                    completion(.success(()))
//                                }
//                            }
//                    }
//                
//                }else {
//                    self.stripeRepository.createCustomerPaymentId { result in
//                        switch result {
//                        case .success(let id):
//                            // 添加用户到Firestore
//                            self.db.collection(self.collection).document(user.uid).setData(
//                                [
//                                    "id": user.uid,
//                                    "paymentId": id,
//                                    "name": user.displayName ?? "",
//                                    "email": user.email ?? "",
//                                ]) { error in
//                                    if let error = error {
//                                        completion(.failure(error))
//                                    } else {
//                                        completion(.success(()))
//                                    }
//                                }
//                        case .failure( let error):
//                            completion(.failure(error))
//                            
//                            
//                        }
//                        
//                    }
//                }
//            }
//        }
        
    }
    
    
    // 使用Apple ID进行登录认证
    // 参数:
    // - authorization: Apple授权对象
    // - nonce: 安全随机数，用于防止重放攻击
    // - completion: 完成回调，返回用户对象或错误
    func signInWithApple(authorization: ASAuthorization, nonce:String?, completion: @escaping (Result<User, any Error>) -> Void) {
        // 尝试获取Apple ID凭证
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // 验证nonce是否存在
            guard let nonce  else {
                completion(.failure(NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid nonce"])))
                return
            }
            // 获取Apple ID令牌
            guard let appleIDToken = appleIDCredential.identityToken else {
                completion(.failure(NSError(domain: "AuthError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch identity token"])))
                return
                
            }
            // 将令牌转换为字符串
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                completion(.failure(NSError(domain: "AuthError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Unable to serialize token string from data"])))
                return
                
            }
            // 创建Firebase凭证，包含用户全名
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            
            // 使用Firebase进行登录
            Auth.auth().signIn(with: credential) { (authResult, error) in
                // 处理登录错误
                if (error != nil) {
                    // 如果错误代码是MissingOrInvalidNonce，确保发送给Apple的是SHA256哈希的nonce
                    completion(.failure(NSError(domain: "AuthError", code: 4, userInfo: [NSLocalizedDescriptionKey:error?.localizedDescription as Any])))
                    return
                }
                
                // 用户已成功使用Apple ID登录Firebase
                if let user = authResult?.user {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "AuthError", code: 5, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                }
                // 注释掉的代码是早期实现版本
                // completion(.success((authResult!.user)))
            }
            return
        }
        // 如果无法获取Apple ID凭证，返回授权失败错误
        completion(.failure(NSError(domain: "AuthError", code: 5, userInfo: [NSLocalizedDescriptionKey:"Authorization failed"])))
    }
    
    // 用户登出
    // 异步方法，清除当前用户的登录状态
    func logout() async throws {
        // 获取Firebase认证实例
        let firebaseAuth = Auth.auth()
        do {
            // 尝试登出当前用户
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            // 处理登出错误
            print("Error signing out: %@", signOutError)
        }
    }
}
