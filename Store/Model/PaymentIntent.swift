//
//  PaymentIntent.swift
//  Store
//
//  Created by Don Arias Agokoli on 16/02/2025.
//

// MARK: - 技术要点
// 1. 支付意图数据模型
// - 使用Codable协议实现数据序列化
// - 与Stripe支付系统集成
// - 处理客户端密钥管理
//
// 2. 属性设计
// - 存储Stripe支付意图的客户端密钥
// - 使用let确保密钥不可变性
// - 遵循安全最佳实践
//
// 3. 数据映射
// - 使用CodingKeys自定义JSON键名映射
// - 支持API响应数据的解析
// - 确保与Stripe API的兼容性

import Foundation

// 支付意图数据模型
struct PaymentIntent: Codable {
    // Stripe支付意图的客户端密钥
    let clientSecret: String
    
    // 自定义编码键，映射API响应字段
    enum CodingKeys: String, CodingKey {
        case clientSecret = "client_secret"
    }
}
