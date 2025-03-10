//
//  StripRepository.swift
//  Store
//
//  Created by Don Arias Agokoli on 16/02/2025.
//

// MARK: - 技术要点
// 1. 支付接口定义
// - 定义统一的Stripe支付操作接口
// - 支持客户ID创建和支付意图生成
// - 实现异步回调处理
//
// 2. 支付流程管理
// - 处理支付意图创建流程
// - 管理客户支付信息
// - 确保支付流程完整性
//
// 3. 安全性设计
// - 实现安全的支付信息传输
// - 保护敏感支付数据
// - 遵循PCI DSS安全标准
//
// 4. 错误处理
// - 使用Result类型处理成功和失败情况
// - 统一的错误处理机制
// - 提供详细的错误信息
//
// 5. 接口设计
// - 清晰的方法命名和参数定义
// - 支持完整的支付流程
// - 便于扩展和维护

protocol StripeRepository {
    
    func createCustomerPaymentId(completion: @escaping (Result<String, Error>) -> Void)
    
    func createPaymentIntent(postData: PaymentParameters, completion: @escaping (Result<String, Error>) -> Void)
    
}
