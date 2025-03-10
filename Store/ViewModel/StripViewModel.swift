//
//  StripViewModel.swift
//  Store
//
//  Created by Don Arias Agokoli on 16/02/2025.
//

// MARK: - 技术要点
// 1. 状态管理
// - 使用@MainActor确保UI更新在主线程执行
// - 采用@Published属性包装器实现数据绑定
// - 管理支付相关状态和错误信息
//
// 2. 支付流程
// - 处理Stripe客户ID创建
// - 管理支付意图生成
// - 实现异步支付操作
//
// 3. 依赖注入
// - 通过构造函数注入StripeRepository
// - 支持单元测试和模块解耦
// - 遵循SOLID设计原则

// 导入Foundation框架，提供基础功能支持
import Foundation

/// Stripe支付视图模型
/// 负责处理与Stripe支付相关的业务逻辑和状态管理
/// 作为视图层和数据层之间的桥梁，提供支付操作接口
// @MainActor注解确保所有UI更新操作都在主线程执行，避免多线程UI更新问题
@MainActor
// 实现ObservableObject协议，支持SwiftUI的数据绑定机制
class StripViewModel: ObservableObject {
    /// 客户ID，使用@Published实现数据绑定
    /// 当ID变化时自动通知UI更新
    @Published var customerId: String = ""
    
    /// 错误信息，用于向用户展示支付过程中的错误
    /// 使用@Published实现数据绑定，支持实时更新
    @Published var errorMessage: String = ""
    
    /// Stripe支付仓储接口，通过依赖注入方式注入
    /// 支持不同的实现方式，便于单元测试和模块解耦
    private var stripeRepository: StripeRepository
    
    /// 初始化方法，支持依赖注入
    /// - Parameter repository: Stripe支付仓储实现，默认使用StripeRepositoryImpl
    init(repository: StripeRepository = StripeRepositoryImpl()) {
        self.stripeRepository = repository
        
    }
    
    /// 创建Stripe客户支付ID
    /// - Parameter completion: 异步回调，返回客户ID或错误
    /// - 通过StripeRepository调用Stripe API创建客户
    /// - 在主线程中处理回调结果，确保UI更新安全
    func createCustomerPaymentId(completion: @escaping (Result<String, any Error>) -> Void) {
        stripeRepository.createCustomerPaymentId { result in
            switch result {
            case .success(let id):
                DispatchQueue.main.async {
                    //self.customerId = id
                    completion(.success(id))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                    //                       self.errorMessage = "Error creating customer: \(error.localizedDescription)"
                }
            }
        }
    }
    
    /// 创建支付意图
    /// - Parameters:
    ///   - postData: 支付参数，包含金额、货币、客户ID等信息
    ///   - completion: 异步回调，返回客户端密钥或错误
    /// - 通过StripeRepository调用Stripe API创建支付意图
    /// - 在主线程中处理回调结果，确保UI更新安全
    func createPaymentIntent(postData: PaymentParameters, completion: @escaping (Result<String, any Error>) -> Void){
       
        stripeRepository.createPaymentIntent(postData: postData) { result in
            switch result {
            case .success(let id):
                DispatchQueue.main.async {
                    //self.paymentIntentId = id
                    completion(.success(id))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Error creating payment intent: \(error.localizedDescription)"
                    completion(.failure(error))
                }
            }
        }
    }
}
