//
//  LocalCartRepository.swift
//  Store
//
//  Created by Don Arias Agokoli on 31/01/2025.
//

// MARK: - 技术要点
// 1. 本地数据持久化
// - 使用UserDefaults存储购物车数据
// - 实现数据的序列化和反序列化
//
// 2. 购物车操作管理
// - 实现添加、删除、更新和清空购物车功能
// - 使用数组管理多个购物车项目
//
// 3. 数据编码解码
// - 使用JSONEncoder和JSONDecoder处理数据转换
// - 处理编码失败的错误情况
//
// 4. 状态管理
// - 维护购物车商品的数量状态
// - 确保数量不小于1的业务规则
//
// 5. 内存缓存
// - 使用本地变量缓存当前购物车状态
// - 优化读写性能

import Foundation

// LocalCartRepository类实现了CartRepository协议
// 提供基于UserDefaults的本地购物车数据存储功能
class LocalCartRepository: CartRepository {
    // UserDefaults实例，用于本地数据持久化存储
    // UserDefaults是iOS提供的轻量级键值存储系统
    private let userDefaults = UserDefaults.standard
    
    // 购物车数据在UserDefaults中的存储键
    // 使用固定的键名确保数据的一致性
    private let cartKey = "cart_items"
    
    // 获取购物车中的所有商品
    // 实现步骤：
    // 1. 从UserDefaults中读取数据
    // 2. 将数据解码为Cart对象数组
    // 3. 如果读取或解码失败则返回空数组
    func getCarts() -> [Cart] {
        guard let data = userDefaults.data(forKey: cartKey),
              let carts = try? JSONDecoder().decode([Cart].self, from: data) else {
            return []
        }
        return carts
    }
    
    // 添加商品到购物车
    // 参数：
    // - product: 要添加的商品对象
    // - quantity: 添加的数量
    // 返回值：true表示新增商品，false表示更新数量
    // 实现逻辑：
    // 1. 获取当前购物车数据
    // 2. 检查商品是否已存在
    // 3. 存在则更新数量，不存在则添加新商品
    func addToCart(product: Product, quantity: Int) -> Bool{
        var currentCarts = getCarts()
        
        // 查找商品是否已存在于购物车中
        if let index = currentCarts.firstIndex(where: { $0.product.id == product.id }) {
            // 更新已存在商品的数量
            currentCarts[index].quantity += quantity
            saveCart(items: currentCarts)
            return false // 表示更新了已存在的商品
        } else {
            // 创建新的购物车项目并添加
            let cart = Cart(id: UUID().uuidString, product: product, quantity: quantity)
            currentCarts.append(cart)
            saveCart(items: currentCarts)
            return true // 表示添加了新商品
        }
    }
    
    // 从购物车中移除商品
    // 参数：productId - 要移除的商品ID
    // 实现逻辑：
    // 1. 获取当前购物车数据
    // 2. 移除指定ID的商品
    // 3. 保存更新后的数据
    func removeFromCart(productId: String) {
        var currentCarts = getCarts()
        currentCarts.removeAll { $0.product.id == productId }
        saveCart(items: currentCarts)
    }
    
    // 更新购物车中商品的数量
    // 参数：
    // - productId: 要更新的商品ID
    // - quantity: 新的数量值
    // 实现逻辑：
    // 1. 获取当前购物车数据
    // 2. 查找并更新指定商品的数量
    // 3. 确保数量不小于1
    func updateQuantity(productId: String, quantity: Int) {
        var currentCarts = getCarts()
        if let index = currentCarts.firstIndex(where: { $0.product.id == productId }) {
            currentCarts[index].quantity = max(1, quantity) // 使用max确保数量不小于1
        }
        saveCart(items: currentCarts)
    }
    
    // 清空购物车
    // 实现逻辑：直接保存一个空数组，清除所有购物车数据
    func clearCart() {
        saveCart(items: [])
    }
    
    // 私有方法：保存购物车数据
    // 参数：items - 要保存的购物车数据数组
    // 实现逻辑：
    // 1. 将购物车数据编码为Data类型
    // 2. 将编码后的数据保存到UserDefaults
    // 3. 处理编码失败的情况
    private func saveCart(items: [Cart]) {
        if let encoded = try? JSONEncoder().encode(items) {
            userDefaults.set(encoded, forKey: cartKey)
        }
    }
}
