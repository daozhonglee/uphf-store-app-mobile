//
//  StripViewModel.swift
//  Store
//
//  Created by Don Arias Agokoli on 16/02/2025.
//

// 导入基础框架
import Foundation

// @MainActor 标记确保所有属性更新在主线程执行
@MainActor
class StripViewModel: ObservableObject {
    // @Published 属性包装器使属性变化可被观察
    @Published var customerId: String = "" // 存储 Stripe 客户 ID
    @Published var errorMessage: String = "" // 存储错误信息
    private var stripeRepository: StripeRepository // Stripe 仓储层实例
    
    // 初始化方法，通过依赖注入方式接收 StripeRepository 实例
    init(repository: StripeRepository = StripeRepositoryImpl()) {
        self.stripeRepository = repository
        
    }
    
    // 创建客户支付 ID 的方法
    func createCustomerPaymentId(completion: @escaping (Result<String, any Error>) -> Void) {
        // 调用仓储层创建客户
        stripeRepository.createCustomerPaymentId { result in
            switch result {
            case .success(let id):
                // 在主线程更新 UI
                DispatchQueue.main.async {
                    //self.customerId = id
                    completion(.success(id))
                }
            case .failure(let error):
                // 在主线程处理错误
                DispatchQueue.main.async {
                    completion(.failure(error))
                    //                       self.errorMessage = "Error creating customer: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // 创建支付意向的方法
    func createPaymentIntent(postData: PaymentParameters, completion: @escaping (Result<String, any Error>) -> Void){
       
        // 调用仓储层创建支付意向
        stripeRepository.createPaymentIntent(postData: postData) { result in
            switch result {
            case .success(let id):
                // 在主线程更新 UI
                DispatchQueue.main.async {
                    //self.paymentIntentId = id
                    completion(.success(id))
                }
            case .failure(let error):
                // 在主线程处理错误
                DispatchQueue.main.async {
                    self.errorMessage = "Error creating payment intent: \(error.localizedDescription)"
                    completion(.failure(error))
                }
            }
        }
    }
}
