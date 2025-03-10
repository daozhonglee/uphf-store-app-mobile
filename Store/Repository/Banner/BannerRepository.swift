//
//  BannerRepository.swift
//  Store
//
//  Created by Don Arias Agokoli on 17/01/2025.
//

// MARK: - 技术要点
// 1. 横幅数据接口
// - 定义统一的横幅数据访问接口
// - 支持异步数据获取
// - 实现数据模型映射
//
// 2. 数据管理
// - 支持横幅数据的CRUD操作
// - 维护横幅展示顺序
// - 确保数据实时性
//
// 3. 错误处理
// - 使用Swift错误处理机制
// - 处理网络和数据异常
// - 提供错误恢复机制
//
// 4. 缓存策略
// - 实现数据缓存机制
// - 优化数据加载性能
// - 管理缓存生命周期

protocol BannerRepository {
    func getBanners() async throws -> [Banner]
}
