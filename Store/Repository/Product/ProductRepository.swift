//
//  BannerRepository.swift
//  Store
//
//  Created by Don Arias Agokoli on 17/01/2025.
//

// MARK: - 技术要点
// 1. 产品数据接口
// - 定义统一的产品数据访问接口
// - 支持多种查询方式
// - 实现异步数据获取
//
// 2. 查询功能
// - 支持最近产品查询
// - 实现分类筛选
// - 提供全文搜索
//
// 3. 性能优化
// - 优化查询性能
// - 实现数据缓存
// - 支持分页加载
//
// 4. 错误处理
// - 统一的错误处理机制
// - 异步操作异常处理
// - 网络错误恢复
//
// 5. 数据同步
// - 确保数据实时性
// - 处理离线场景
// - 维护数据一致性

protocol ProductRepository {
    // 获取最近添加的产品
    // 通常用于首页展示最新商品
    func getRecentProduct() async throws -> [Product]
    
    // 根据分类ID获取产品列表
    // 用于分类页面的商品展示
    func getProductByCategory(_ id: String) async throws -> [Product]
    
    // 获取所有产品
    // 用于商品总览或管理后台
    func getAllProduct() async throws -> [Product]
    
    // 根据名称搜索产品
    // 实现商品搜索功能
    func searchProducts(by name: String, completion: @escaping ([Product]) -> Void)
}
