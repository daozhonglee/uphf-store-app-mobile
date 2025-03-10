//
//  ImplStripRepository.swift
//  Store
//
//  Created by Don Arias Agokoli on 16/02/2025.
//

// MARK: - 技术要点
// 1. Stripe支付实现
// - 实现StripeRepository接口定义的功能
// - 使用Alamofire进行网络请求
// - 处理Stripe API的认证和请求
//
// 2. 安全性设计
// - 使用私有属性存储API密钥
// - 实现安全的HTTP请求头设置
// - 遵循Stripe安全最佳实践
//
// 3. 错误处理
// - 完整的错误处理和回调机制
// - 支持异步操作结果返回
// - 规范的HTTP响应处理

// 导入Alamofire框架，用于简化网络请求的处理
import Alamofire
// 导入Foundation框架，提供基础功能支持
import Foundation

/// Stripe支付仓库实现类
/// 负责实现与Stripe支付平台的所有交互功能
/// 包括创建客户ID和支付意图等核心支付流程
class StripeRepositoryImpl: StripeRepository {
    
    /// Stripe API密钥，用于身份验证
    /// 注意：在生产环境中应使用环境变量或安全存储方式管理
    private let apiKey = "sk_test_VePHdqKTYQjKNInc7u56JBrQ" // 测试环境的API密钥
    
    /// Stripe API的基础URL
    private let baseURL = "https://api.stripe.com/v1/" // Stripe API的根路径
    
    
    /// 创建Stripe客户ID
    /// - Parameter completion: 异步回调，返回客户ID或错误
    /// - Returns: 无返回值，通过completion回调返回结果
    func createCustomerPaymentId(completion: @escaping (Result<String, Error>) -> Void) {
        // 设置创建客户的API端点URL
        let url = "https://api.stripe.com/v1/customers"
        // 配置HTTP请求头，包含Bearer令牌认证
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)" // 使用Bearer认证方式
        ]
        
        // 使用Alamofire发送POST请求创建客户
        // 不需要请求体参数，仅使用认证头
        AF.request(url, method: .post, headers: headers
        ).responseDecodable(of:StripUser.self) { response in // 将响应解析为StripUser对象
            // 处理响应结果
            switch response.result {
            case .success(let value): // 请求成功
                completion(.success(value.id)) // 返回客户ID
            case .failure(let error): // 请求失败
                completion(.failure(error)) // 返回错误信息
            }
        }
    }
    
    /// 创建支付意图
    /// - Parameters:
    ///   - postData: 支付参数，包含金额、货币、客户ID等信息
    ///   - completion: 异步回调，返回客户端密钥或错误
    /// - Returns: 无返回值，通过completion回调返回结果
    func createPaymentIntent(postData: PaymentParameters, completion: @escaping (Result<String, Error>) -> Void) {
        // 构建Stripe支付意图API的URL
        let url = "https://api.stripe.com/v1/payment_intents" // 支付意图API端点
        
        // 设置HTTP请求头，包含认证信息和内容类型
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)", // Bearer认证
            "Content-Type": "application/x-www-form-urlencoded" // 表单编码内容类型
        ]
        
        // 示例参数（注：此处未使用，实际使用postData.dictionary）
        let parameters: [String: Any] = [
              "customer": "cus_RmhvSo8BYmD2Yr", // 客户ID示例
              "amount": 5 * 100,               // 金额（单位：分）示例
              "currency": "eur"                // 货币（欧元）示例
          ]
        
        // 使用Alamofire发送POST请求创建支付意图
        // 参数使用postData.dictionary，它将PaymentParameters对象转换为字典
        AF.request(url, method: .post, // POST方法
                   parameters: postData.dictionary, // 使用传入的支付参数
                   encoding: URLEncoding.default,  // 使用URL编码方式
                   headers: headers).responseDecodable(of: PaymentIntent.self) { response in // 解析为PaymentIntent对象
            // 调试输出完整响应
            debugPrint("response==>\(response)") // 打印完整响应信息用于调试
            
            // 处理响应结果
            switch response.result {
            case .success(let value): // 请求成功
                // 调试输出解析后的PaymentIntent对象
                debugPrint("value==>\(value)") // 打印解析后的支付意图对象
                // 成功时返回客户端密钥
                completion(.success(value.clientSecret)) // 返回客户端密钥用于前端支付确认
            case .failure(let error): // 请求失败
                // 失败时返回错误
                completion(.failure(error)) // 返回错误信息
            }
        }
    }
    
} // 类定义结束

