//
//  Cart.swift
//  Store
//
//  Created by Don Arias Agokoli on 23/12/2024.
//

// MARK: - 技术要点
// 1. 购物车数据模型
// - 使用 Codable 协议实现数据序列化
// - 定义购物车项的基本属性
// - 支持本地存储和网络传输
//
// 2. 属性设计
// - 关联商品模型
// - 记录商品数量
// - 支持购物车项唯一标识

import Foundation

// 购物车项数据模型
struct Cart: Identifiable, Codable {
    var id: String        // 购物车项唯一标识符
    var product: Product  // 关联的商品信息
    var quantity: Int     // 商品数量
    
    // 自定义编码键，用于JSON序列化
    enum CodingKeys: String, CodingKey {
        case id
        case product
        case quantity
    }
    
    // 初始化方法
    init(id: String = UUID().uuidString, product: Product, quantity: Int = 1) {
        self.id = id
        self.product = product
        self.quantity = quantity
    }
}
