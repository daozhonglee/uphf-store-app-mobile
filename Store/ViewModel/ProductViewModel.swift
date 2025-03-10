//
//  ProductViewModel.swift
//  Store
//
//  Created by Don Arias Agokoli on 17/01/2025.
//

// MARK: - 技术要点
// 1. 产品数据管理
// - 处理不同类型的产品数据（最新产品、分类产品、搜索结果）
// - 实现产品搜索和过滤功能
// - 管理产品数据的异步加载
//
// 2. 状态管理
// - 使用@MainActor确保线程安全
// - 采用@Published属性包装器实现数据绑定
// - 跟踪加载状态和错误信息
//
// 3. 搜索功能
// - 实现产品搜索逻辑
// - 处理搜索结果的展示
// - 优化搜索体验（去除空格等）
//
// 4. 依赖注入
// - 通过构造函数注入ProductRepository
// - 支持单元测试和模块解耦
// - 遵循SOLID设计原则

// 导入SwiftUI框架，提供UI组件和数据绑定支持
import SwiftUI

// @MainActor注解确保所有UI更新操作都在主线程执行
// 这是Swift并发编程中的重要特性，可以避免多线程导致的UI更新问题
@MainActor
// 实现ObservableObject协议，支持SwiftUI的数据绑定机制
class ProductViewModel : ObservableObject {
    // 最近产品列表，用于首页展示
    // 使用@Published实现数据绑定，当数据变化时自动通知UI更新
    @Published var recentProduct: [Product] = []
    
    // 按分类筛选的产品列表
    // 当用户选择特定分类时更新此列表
    @Published var productByCategory: [Product] = []
    
    // 搜索结果产品列表
    // 存储用户搜索查询的结果
    @Published var listProductSearch: [Product] = []
    
    // 加载状态标志，用于显示加载指示器
    // 在进行异步操作时设置为true，完成后设置为false
    @Published var isLoading = false
    
    // 错误状态，用于存储和显示错误信息
    // 当数据获取失败时，存储错误对象以便UI层显示
    @Published var error: Error?
    
    // 搜索查询字符串，绑定到搜索框
    // 用户输入的搜索关键词
    @Published var searchQuery: String = ""
    
    // 最后一次搜索的查询字符串
    // 用于比较是否需要重新搜索
    @Published var lastSearchQuery: String = ""
    
    // 搜索结果提示消息
    // 当没有找到结果时显示
    @Published var searchMessage :String = ""
    
    // 产品仓储接口，用于获取产品数据
    // 通过依赖注入方式注入，支持不同的实现方式
    private let repository: ProductRepository
    
    // 初始化方法，支持依赖注入
    // 默认使用FirestoreProductRepository作为数据仓储
    // 在初始化时自动获取最新产品数据
    init(repository: ProductRepository = FirestoreProductRepository()) {
        self.repository = repository
        fetchProduct()
    }
    
    // 获取最新产品数据
    // 从仓储层异步获取最新的产品列表
    // 用于首页展示推荐产品
    func fetchProduct() {
        Task {
            // 设置加载状态为true，通知UI显示加载指示器
            isLoading = true
            do {
                // 异步获取最新产品数据
                recentProduct = try await repository.getRecentProduct()
            } catch {
                // 捕获并存储错误信息
                self.error = error
            }
            // 设置加载状态为false，通知UI隐藏加载指示器
            isLoading = false
        }
    }
    
    // 按分类获取产品数据
    // id: 分类ID，如果为空则获取所有产品
    // 用于分类页面展示特定分类的产品
    func fetchProductByCategory(_ id:String) {
        Task {
            // 设置加载状态为true，通知UI显示加载指示器
            isLoading = true
            do {
                // 根据ID是否为空决定获取全部产品还是特定分类产品
                if(id.isEmpty){
                    // ID为空，获取所有产品
                    productByCategory = try await repository.getAllProduct()
                }else{
                    // ID不为空，获取特定分类的产品
                    productByCategory = try await repository.getProductByCategory(id)
                }
                
            } catch {
                // 捕获并存储错误信息
                self.error = error
            }
            // 设置加载状态为false，通知UI隐藏加载指示器
            isLoading = false
        }
    }
    
    // 搜索产品
    // 根据用户输入的关键词搜索产品
    // 处理搜索结果和无结果情况
    func searchProducts() {
        Task{
            // 设置加载状态为true，通知UI显示加载指示器
            isLoading = true
            // 去除搜索关键词前后的空格
            searchQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
            // 保存当前搜索关键词，用于UI显示
            lastSearchQuery = searchQuery
            // 调用仓储层的搜索方法
            repository.searchProducts(by: searchQuery) { [weak self] products in
                // 在主线程更新UI
                DispatchQueue.main.async {
                    // 检查搜索结果是否为空
                    if(products.isEmpty){
                        // 设置无结果提示消息
                        self?.searchMessage = "Aucun article trouver pour "
                    }
                    // 更新搜索结果列表
                    self?.listProductSearch = products
                }
            }
            // 设置加载状态为false，通知UI隐藏加载指示器
            isLoading = false
        }
    }
}
