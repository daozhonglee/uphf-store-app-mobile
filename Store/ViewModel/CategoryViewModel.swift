//
//  CategorieViewModel.swift
//  Store
//
//  Created by Don Arias Agokoli on 17/01/2025.
//

// MARK: - 技术要点
// 1. 状态管理
// - 使用@MainActor确保线程安全
// - 实现ObservableObject支持数据绑定
// - 管理分类数据和加载状态
//
// 2. 数据获取
// - 通过依赖注入获取数据仓储
// - 使用async/await处理异步数据加载
// - 实现分类数据的排序逻辑
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

// 导入Foundation框架，提供基础功能支持
import Foundation

// @MainActor注解确保所有UI更新操作都在主线程执行
// 这是Swift并发编程中的重要特性，可以避免多线程导致的UI更新问题
@MainActor
// 实现ObservableObject协议，支持SwiftUI的数据绑定机制
class CategoryViewModel : ObservableObject {
    // 分类列表，使用@Published实现数据绑定
    // 当数据发生变化时，会自动通知UI更新
    @Published var categorys: [Category] = []
    
    // 加载状态标志，用于显示加载指示器
    // 在进行异步操作时设置为true，完成后设置为false
    @Published var isLoading = false
    
    // 错误状态，用于存储和显示错误信息
    // 当数据获取失败时，存储错误对象以便UI层显示
    @Published var error: Error?
    
    // 分类仓储接口，用于处理分类数据的获取
    // 通过依赖注入方式注入，支持不同的实现方式
    private let repository: CategoryRepository
    
    // 初始化方法，支持依赖注入
    // 默认使用FirestoreCategoryRepository作为数据仓储
    // 在初始化时自动获取分类数据
    init(repository: CategoryRepository = FirestoreCategoryRepository()) {
        self.repository = repository
        fetchCategory()
    }
    
    // 获取分类数据
    // 从仓储层异步获取最新的分类数据
    // 并对数据进行排序处理
    func fetchCategory() {
        // 创建异步任务
        Task {
            // 设置加载状态为true，通知UI显示加载指示器
            isLoading = true
            do {
                // 异步获取分类数据
                self.categorys = try await repository.getCategorys()
                // 对分类数据进行排序，确保"All"分类始终排在最前面
                // 其他分类按字母顺序排序
                self.categorys.sort { $0.name == "All" ? false : $1.name == "All" ? true : $0.name < $1.name }
            } catch {
                // 捕获并存储错误信息
                self.error = error
            }
            // 设置加载状态为false，通知UI隐藏加载指示器
            isLoading = false
        }
    }
}
