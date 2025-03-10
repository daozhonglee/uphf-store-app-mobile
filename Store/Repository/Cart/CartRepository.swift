//
//  CartRepository.swift
//  Store
//
//  Created by Don Arias Agokoli on 07/02/2025.
//

// MARK: - 技术要点
// 1. 购物车接口定义
// - 定义统一的购物车操作接口
// - 支持商品的增删改查
// - 管理购物车状态
//
// 2. 数据持久化
// - 实现购物车数据的本地存储
// - 支持数据的序列化和反序列化
// - 确保数据一致性
//
// 3. 商品管理
// - 商品数量的增减操作
// - 商品总价计算
// - 购物车商品验证
//
// 4. 状态同步
// - 与服务器数据同步
// - 处理离线状态
// - 冲突解决策略
//
// 5. 错误处理
// - 定义统一的错误类型
// - 处理网络异常
// - 数据验证和错误恢复

import Foundation

protocol CartRepository {
    // 获取购物车中的所有商品
    func getCart() -> Cart
    
    // 添加商品到购物车
    func addToCart(_ product: Product)
    
    // 从购物车中移除商品
    func removeFromCart(_ product: Product)
    
    // 清空购物车
    func clearCart()
    
    // 更新购物车中商品的数量
    func updateQuantity(for product: Product, quantity: Int)
    
    // 获取购物车中商品的总数
    func getItemCount() -> Int
    
    // 计算购物车中商品的总价
    func getTotal() -> Double
}
