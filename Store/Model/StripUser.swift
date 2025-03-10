//
//  StripUser.swift
//  Store
//
//  Created by Don Arias Agokoli on 19/02/2025.
//

// MARK: - 技术要点
// 1. Stripe用户数据模型
// - 使用Codable协议实现数据序列化
// - 与Stripe支付系统集成
// - 存储Stripe用户标识信息
//
// 2. 属性设计
// - 使用let确保用户ID不可变
// - 简洁的数据结构设计
// - 遵循Stripe API规范
//
// 3. 数据安全
// - 仅存储必要的用户信息
// - 确保用户数据的安全性
// - 支持用户身份验证

import Foundation

// Stripe用户数据模型
struct StripUser: Codable {
    // Stripe用户唯一标识符
    let id: String
}
