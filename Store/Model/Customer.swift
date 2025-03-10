//
//  Customer.swift
//  Store
//
//  Created by Don Arias Agokoli on 17/02/2025.
//

// MARK: - 技术要点
// 1. 数据模型设计
// - 使用结构体定义客户模型
// - 采用值类型确保数据安全性和一致性
//
// 2. 协议遵循
// - Identifiable：支持在列表和集合中唯一标识
// - Codable：支持JSON序列化和数据持久化
//
// 3. 身份验证集成
// - 存储用户邮箱用于身份验证
// - 与Firebase Auth服务集成
//
// 4. 支付集成
// - 通过paymentId关联Stripe支付信息
// - 支持用户支付方式的管理
//
// 5. 数据安全
// - 使用let声明确保属性不可变
// - 遵循最小权限原则设计数据结构

import Foundation

struct Customer: Identifiable, Codable {
    // 客户唯一标识符
    let id: String
    // 客户邮箱，用于身份验证
    let email: String
    // Stripe支付ID，关联支付信息
    let paymentId: String
    // 客户姓名
    let name: String
    
    // 定义编码键
    // 用于JSON序列化和反序列化
    enum CodingKeys: CodingKey {
        case id
        case email
        case name
        case paymentId
    }
}
