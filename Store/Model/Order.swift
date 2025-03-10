//
//  Order.swift
//  Store
//
//  Created by Don Arias Agokoli on 17/02/2025.
//

// MARK: - 技术要点
// 1. 订单数据模型
// - 使用Identifiable和Codable协议支持唯一标识和序列化
// - 集成Firestore数据存储
// - 包含订单状态和支付状态管理
//
// 2. 属性设计
// - 使用可选类型处理订单ID
// - 关联用户ID实现用户订单关系
// - 包含购物车商品列表和配送地址
// - 记录订单总金额和创建时间
//
// 3. 数据转换
// - 实现dictionary属性支持Firestore数据映射
// - 使用CodingKeys自定义序列化键名
// - 支持日期类型的处理

import Foundation
import FirebaseFirestore

// 订单数据模型
struct Order: Identifiable, Codable {
    let id: String?              // 订单唯一标识符
    let userId: String           // 关联的用户ID
    let cart: [Cart]            // 订单包含的商品列表
    let total: Double           // 订单总金额
    let statut: String          // 订单状态
    let statutPayment: String   // 支付状态
    let address: ShippingAddress // 配送地址信息
    let createdAt: Date = Date() // 订单创建时间
    
    // 自定义编码键
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case cart
        case address
        case statut
        case statutPayment
        case total
        case createdAt
    }
    
    // 转换为Firestore文档数据
    var dictionary: [String: Any] {
        return [
            "userId": userId,
            "cart": cart,
            "total": total,
            "statut": statut,
            "statutPayment": statutPayment,
            "address": address
        ]
    }
    
    // 注释掉的初始化方法
//    init(
//        id: String?,
//        userId: String,
//        cart: [Cart],
//        total: Double,
//        statut: String,
//        statutPayment: String,
//        address: ShippingAddress
//    ) {
//        self.id = id
//        self.userId = userId
//        self.cart = cart
//        self.total = total
//        self.statut = statut
//        self.statutPayment = statutPayment
//        self.address = address
//    }
}
