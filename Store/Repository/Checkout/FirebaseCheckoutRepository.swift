//
//  FirebaseCheckoutRepository.swift
//  Store
//
//  Created by Don Arias Agokoli on 16/02/2025.
//

// MARK: - 技术要点
// 1. Firestore数据库集成
// - 使用FirebaseFirestore框架进行订单数据操作
// - 实现订单数据的查询功能
// - 维护订单集合的数据一致性
//
// 2. 查询优化
// - 基于用户ID的高效过滤查询
// - 使用whereField实现精确匹配
// - 支持订单历史记录检索
//
// 3. 异步操作
// - 使用async/await处理异步数据库操作
// - 采用Swift现代并发模型
//
// 4. 数据映射
// - 使用Firestore的data(as:)进行模型映射
// - 处理文档快照到Order对象的转换
//
// 5. 错误处理
// - 使用Swift错误处理机制
// - 通过throws传递查询异常
// - 确保数据访问安全

import FirebaseFirestore

class FirestoreCheckoutRepository: CheckoutRepository {
    // Firestore数据库实例
    private let db = Firestore.firestore()
    // 订单集合名称常量
    private let collection = "orders"
    
    // 获取用户订单列表
    // 参数:
    // - userId: 用户唯一标识符
    // 返回: 订单数组
    func getOrders(_ userId: String) async throws -> [Order] {
       
        // 异步查询Firestore数据库中符合条件的订单文档
        // 使用whereField过滤特定用户的订单
        let snapshot = try await db.collection(collection).whereField("userId", isEqualTo: userId).getDocuments()
        
        // 将文档数据映射为Order对象数组
        return try snapshot.documents.map { document in
            let orders = try document.data(as: Order.self)
            
            return orders
        }
    }

}
