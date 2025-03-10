//
//  CartViewModel.swift
//  Store
//
//  Created by Don Arias Agokoli on 31/01/2025.
//

// MARK: - 技术要点
// 1. 状态管理
// - 使用@MainActor确保在主线程更新UI
// - 采用@Published属性包装器实现数据绑定
//
// 2. MVVM架构
// - ViewModel作为视图和模型层之间的中介
// - 处理业务逻辑和状态转换
//
// 3. 依赖注入
// - 通过构造函数注入CartRepository
// - 支持测试和模块解耦
//
// 4. 异步操作
// - 使用DispatchQueue处理异步UI更新
// - 管理加载状态和错误处理
//
// 5. 数据计算
// - 实现购物车总价的实时计算
// - 使用reduce函数进行数组运算

import Foundation

// @MainActor确保所有UI更新操作都在主线程执行
// 这是Swift并发编程中的重要特性，可以避免多线程导致的UI更新问题
@MainActor
class CartViewModel : ObservableObject {
    // 购物车仓储接口，用于处理购物车数据的持久化操作
    // 通过依赖注入方式注入，支持不同的实现方式（如本地存储、远程存储等）
    private let repository: CartRepository
    
    // 购物车商品列表，使用@Published实现数据绑定
    // 当数据发生变化时，会自动通知UI更新
    @Published var cartItems: [Cart] = []
    
    // 购物车总价，使用@Published实现数据绑定
    // 随着商品数量和价格的变化自动更新
    @Published var total: Double = 0
    
    // 加载状态标志，用于显示加载指示器
    // 在进行异步操作时设置为true，完成后设置为false
    @Published var isLoading = false
    
    // 提示消息，用于向用户显示操作结果
    // 如添加商品成功、商品已存在等提示信息
    @Published var alertMessage = ""
    
    // 是否显示提示框，控制警告框的显示和隐藏
    @Published var showAlert = false
    
    // 初始化方法，支持依赖注入
    // 默认使用LocalCartRepository作为数据仓储
    // 在初始化时自动加载购物车数据
    init(repository: CartRepository = LocalCartRepository()) {
        self.repository = repository
        loadCart()
    }
    
    // 加载购物车数据
    // 从仓储层获取最新的购物车数据
    // 同时触发总价的重新计算
    func loadCart() {
        cartItems = repository.getCarts()
        calculateTotal()
    }
    
    // 添加商品到购物车
    // product: 要添加的商品
    // quantity: 添加的数量，默认为1
    // 返回值通过回调通知UI层添加结果
    func addToCart(product: Product, quantity: Int = 1) {
        isLoading = true
        // 调用仓储层的添加方法
        let added = repository.addToCart(product: product, quantity: quantity)
        // 重新加载购物车数据以更新UI
        loadCart()
        isLoading = false
        
        // 根据添加结果显示不同的提示信息
        if !added {
            // 商品已在购物车中的提示
            DispatchQueue.main.async {
                self.alertMessage = "商品已在购物车中"
                self.showAlert = true
            }
        } else {
            // 添加成功的提示
            DispatchQueue.main.async {
                self.alertMessage = "商品已添加到购物车"
                self.showAlert = true
            }
        }
    }
    
    // 从购物车中移除商品
    // productId: 要移除的商品ID
    // 移除后自动重新加载购物车数据
    func removeFromCart(productId: String) {
        repository.removeFromCart(productId: productId)
        loadCart()
    }
    
    // 更新商品数量
    // productId: 要更新的商品ID
    // quantity: 新的数量值
    // 更新后自动重新加载购物车数据
    func updateQuantity(productId: String, quantity: Int) {
        repository.updateQuantity(productId: productId, quantity: quantity)
        loadCart()
    }
    
    // 清空购物车
    // 删除购物车中的所有商品
    // 清空后自动重新加载购物车数据
    func clearCart() {
        repository.clearCart()
        loadCart()
    }
    
    // 计算购物车总价
    // 使用reduce函数遍历所有商品
    // 将每个商品的价格乘以数量后累加
    private func calculateTotal() {
        total = cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
}
