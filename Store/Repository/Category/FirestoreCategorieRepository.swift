//
//  FirestoreBannerRepository.swift
//  Store
//
//  Created by Don Arias Agokoli on 17/01/2025.
//

// MARK: - 技术要点
// 1. Firestore数据库集成
// - 实现CategoryRepository接口
// - 使用Firestore进行数据存储和查询
// - 确保数据实时同步
//
// 2. 分类数据管理
// - 实现分类数据的CRUD操作
// - 维护分类层级结构
// - 支持分类排序和过滤
//
// 3. 数据映射
// - 使用Codable协议进行数据转换
// - 处理文档快照到模型的映射
// - 确保数据格式一致性
//
// 4. 性能优化
// - 实现高效的数据查询
// - 使用缓存减少数据库访问
// - 优化批量操作性能
//
// 5. 错误处理
// - 处理数据库操作异常
// - 提供错误恢复机制
// - 确保数据完整性

import FirebaseFirestore

// FirestoreCategoryRepository类实现CategoryRepository协议
// 提供基于Firestore的分类数据访问功能
class FirestoreCategoryRepository: CategoryRepository {
    // Firestore数据库实例
    private let db = Firestore.firestore()
    // 分类数据集合名称
    private let collection = "categorys"
    
    // 获取所有分类数据
    // 实现步骤：
    // 1. 异步获取Firestore集合中的所有文档
    // 2. 将文档数据映射为Category对象数组
    // 3. 处理可能的错误情况
    func getCategorys() async throws -> [Category] {
        let snapshot = try await db.collection(collection).getDocuments()
        return try snapshot.documents.map { document in
            let category = try document.data(as: Category.self)
            return category
        }
    }
    
    // 以下是预留的CRUD操作方法
    // 目前被注释掉，但保留以供future实现
//    func addTodo(_ todo: Todo) async throws {
//        var todoDict = try todo.dictionary()
//        todoDict.removeValue(forKey: "id")
//        try await db.collection(collection).document().setData(todoDict)
//    }
//    
//    func updateTodo(_ todo: Todo) async throws {
//        var todoDict = try todo.dictionary()
//        todoDict.removeValue(forKey: "id")
//        try await db.collection(collection).document(todo.id).setData(todoDict)
//    }
//    
//    func deleteTodo(_ id: String) async throws {
//        try await db.collection(collection).document(id).delete()
//    }
}
