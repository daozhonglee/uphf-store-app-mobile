//
//  BannerRepository.swift
//  Store
//
//  Created by Don Arias Agokoli on 17/01/2025.
//

// MARK: - 技术要点
// 1. 分类数据接口
// - 定义统一的分类数据访问接口
// - 支持异步数据获取
// - 实现数据模型映射
//
// 2. 数据管理
// - 支持分类数据的CRUD操作
// - 维护分类层级结构
// - 确保数据实时性
//
// 3. 查询优化
// - 实现高效的分类查询
// - 支持分类过滤和排序
// - 优化数据加载性能
//
// 4. 错误处理
// - 使用Swift错误处理机制
// - 处理网络和数据异常
// - 提供错误恢复策略
//
// 5. 缓存管理
// - 实现分类数据缓存
// - 优化访问性能
// - 管理缓存生命周期

protocol CategoryRepository {
    func getCategorys() async throws -> [Category]
    //func addTodo(_ todo: Todo) async throws
    //func updateTodo(_ todo: Todo) async throws
    //func deleteTodo(_ id: String) async throws
}
