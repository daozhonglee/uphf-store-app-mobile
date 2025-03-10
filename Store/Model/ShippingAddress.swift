//
//  ShippingAddress.swift
//  Store
//
//  Created by Don Arias Agokoli on 19/02/2025.
//

// MARK: - 技术要点
// 1. 配送地址数据模型
// - 使用Codable协议实现数据序列化
// - 定义标准化的地址信息结构
// - 支持订单配送信息管理
//
// 2. 属性设计
// - 使用let确保地址信息不可变
// - 包含完整的配送地址字段
// - 遵循地址信息标准格式
//
// 3. 数据验证
// - 通过CodingKeys确保数据完整性
// - 支持地址信息的序列化和反序列化
// - 便于与订单系统集成

import Foundation

// 配送地址数据模型
struct ShippingAddress: Codable {
    let fullName: String    // 收件人全名
    let address: String     // 详细地址
    let city: String        // 城市
    let postalCode: String  // 邮政编码
    
    // 自定义编码键
    enum CodingKeys: CodingKey {
        case fullName
        case address
        case city
        case postalCode
    }
}


