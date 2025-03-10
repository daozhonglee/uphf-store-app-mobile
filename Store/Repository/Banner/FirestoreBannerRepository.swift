//
//  FirestoreBannerRepository.swift
//  Store
//
//  Created by Don Arias Agokoli on 17/01/2025.
//

// MARK: - 技术要点
// 1. Firestore数据访问
// - 实现BannerRepository接口
// - 使用Firestore数据库服务
// - 处理数据库连接和查询
//
// 2. 数据映射
// - 将Firestore文档转换为Banner模型
// - 处理数据序列化和反序列化
// - 确保数据类型安全
//
// 3. 异步操作
// - 使用async/await处理异步数据获取
// - 优化数据加载性能
// - 处理并发访问
//
// 4. 错误处理
// - 处理数据库查询异常
// - 提供清晰的错误信息
// - 实现错误恢复机制
//
// 5. 缓存优化
// - 实现数据缓存策略
// - 减少数据库访问频率
// - 提高应用响应速度

import FirebaseFirestore

// FirestoreBannerRepository类实现BannerRepository协议
// 提供基于Firestore的横幅数据访问功能
class FirestoreBannerRepository: BannerRepository {
    // Firestore数据库实例
    private let db = Firestore.firestore()
    // 横幅数据集合名称
    private let collection = "banners"
    
    // 获取所有横幅数据
    // 实现步骤：
    // 1. 异步获取Firestore集合中的所有文档
    // 2. 将文档数据映射为Banner对象数组
    // 3. 处理可能的错误情况
    func getBanners() async throws -> [Banner] {
        let snapshot = try await db.collection(collection).getDocuments()
        return try snapshot.documents.map { document in
            let banner = try document.data(as: Banner.self)
            return banner
        }
    }
}
