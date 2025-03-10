//
//  PaiementParam.swift
//  Store
//
//  Created by Don Arias Agokoli on 21/02/2025.
//

// MARK: - 技术要点
// 1. 支付参数数据模型
// - 定义支付所需的基本参数
// - 支持Stripe支付系统集成
// - 提供数据转换功能
//
// 2. 属性设计
// - 使用let确保参数不可变性
// - 设置默认货币类型
// - 存储客户标识和支付金额
//
// 3. 数据转换
// - 实现dictionary属性支持API请求
// - 确保数据格式符合支付系统要求
// - 提供标准化的数据结构

// 支付参数数据模型
struct PaymentParameters {
    let customer: String      // 客户标识符
    let amount: Double        // 支付金额
    let currency: String = "eur" // 支付货币类型，默认为欧元
    
    // 转换为API请求参数
    var dictionary: [String: Any] {
        return [
            "customer": customer,
            "amount": amount,
            "currency": currency
        ]
    }
}
