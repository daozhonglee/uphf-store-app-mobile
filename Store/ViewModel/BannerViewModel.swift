//
//  BannerViewModel.swift
//  Store
//
//  Created by Don Arias Agokoli on 17/01/2025.
//

// MARK: - 技术要点
// 1. 状态管理
// - 使用@MainActor确保线程安全
// - 实现ObservableObject支持数据绑定
// - 管理轮播图数据和加载状态
//
// 2. 数据获取
// - 通过依赖注入获取数据仓储
// - 使用async/await处理异步数据加载
// - 实现数据的自动刷新机制
//
// 3. 错误处理
// - 统一的错误状态管理
// - 异步操作的错误捕获
// - 提供友好的错误提示
//
// 4. 架构设计
// - 遵循MVVM架构模式
// - 实现视图模型的职责分离
// - 优化数据流和状态更新

// 导入SwiftUI框架，提供UI组件和数据绑定支持
import SwiftUI

// @MainActor注解确保所有UI更新操作都在主线程执行
// 这是Swift并发编程中的重要特性，可以避免多线程导致的UI更新问题
@MainActor
// 实现ObservableObject协议，支持SwiftUI的数据绑定机制
class BannerViewModel: ObservableObject {
    // 轮播图数据列表，使用@Published实现数据绑定
    // 当数据发生变化时，会自动通知UI更新
    @Published var banners: [Banner] = []
    
    // 加载状态标志，用于显示加载指示器
    // 在进行异步操作时设置为true，完成后设置为false
    @Published var isLoading = false
    
    // 错误状态，用于存储和显示错误信息
    // 当数据获取失败时，存储错误对象以便UI层显示
    @Published var error: Error?
    
    // 轮播图仓储接口，用于获取轮播图数据
    // 通过依赖注入方式注入，支持不同的实现方式
    private let repository: BannerRepository
    
    // 初始化方法，支持依赖注入
    // 默认使用FirestoreBannerRepository作为数据仓储
    // 在初始化时自动获取轮播图数据
    init(repository: BannerRepository = FirestoreBannerRepository()) {
        self.repository = repository
        fetchBanners()
    }
    
    // 获取轮播图数据
    // 从仓储层异步获取最新的轮播图数据
    // 用于首页展示推广内容
    func fetchBanners() {
        // 创建异步任务
        Task {
            // 设置加载状态为true，通知UI显示加载指示器
            isLoading = true
            do {
                // 异步获取轮播图数据
                banners = try await repository.getBanners()
            } catch {
                // 捕获并存储错误信息
                self.error = error
            }
            // 设置加载状态为false，通知UI隐藏加载指示器
            isLoading = false
        }
    }
}
