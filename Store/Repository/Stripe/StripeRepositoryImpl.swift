//
//  ImplStripRepository.swift
//  Store
//
//  Created by Don Arias Agokoli on 16/02/2025.
//

// 导入 Alamofire 用于网络请求
import Alamofire
import Foundation

// Stripe 仓储层实现类，负责处理与 Stripe API 的所有交互
class StripeRepositoryImpl: StripeRepository {
    
    // Stripe API 密钥，用于服务器端认证
    private let apiKey = "sk_test_VePHdqKTYQjKNInc7u56JBrQ"
    // Stripe API 的基础 URL
    private let baseURL = "https://api.stripe.com/v1/"
    
    
    // 创建 Stripe 客户 ID 的方法
    func createCustomerPaymentId(completion: @escaping (Result<String, Error>) -> Void) {
        // Stripe 创建客户的 API 端点
        let url = "https://api.stripe.com/v1/customers"
        // 设置请求头，包含 API 密钥认证
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)"
        ]
        
        // 使用 Alamofire 发送 POST 请求创建客户
        AF.request(url, method: .post, headers: headers
        ).responseDecodable(of:StripUser.self) { response in
            switch response.result {
            case .success(let value):
                // 成功时返回客户 ID
                completion(.success(value.id))
            case .failure(let error):
                // 失败时返回错误信息
                completion(.failure(error))
            }
        }
    }
    
    // 创建支付意向的方法
    func createPaymentIntent(postData: PaymentParameters, completion: @escaping (Result<String, Error>) -> Void) {
        // Stripe 创建支付意向的 API 端点
        let url = "https://api.stripe.com/v1/payment_intents"
        // 设置请求头，包含认证和内容类型
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        // 支付参数示例（实际应使用 postData）
        let parameters: [String: Any] = [
              "customer": "cus_RmhvSo8BYmD2Yr",
              "amount": 5 * 100,
              "currency": "eur"
          ]
        
        
        // 发送创建支付意向的请求
        AF.request(url, method: .post,
                   parameters: postData.dictionary,
                   encoding: URLEncoding.default,
                   headers: headers).responseDecodable(of: PaymentIntent.self) { response in
            // 打印调试信息
            debugPrint("response==>\(response)")
            switch response.result {
            case .success(let value):
                // 打印成功响应
                debugPrint("value==>\(value)")
                // 返回客户端密钥
                completion(.success(value.clientSecret))
            case .failure(let error):
                // 返回错误信息
                completion(.failure(error))
            }
        }
    }
    
}

