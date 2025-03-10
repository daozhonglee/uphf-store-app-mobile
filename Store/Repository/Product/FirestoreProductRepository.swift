//
//  FirestoreBannerRepository.swift
//  Store
//
//  Created by Don Arias Agokoli on 17/01/2025.
//

// MARK: - 技术要点
// 1. Firestore数据库集成
// - 使用FirebaseFirestore框架进行数据库操作
// - 实现产品数据的CRUD操作
//
// 2. 查询优化
// - 使用order(by:)实现数据排序
// - 使用limit(to:)限制查询结果数量
// - 实现基于分类的数据过滤
//
// 3. 异步操作
// - 使用async/await处理异步数据库操作
// - 采用Swift现代并发模型
//
// 4. 数据映射
// - 使用Firestore的data(as:)进行模型映射
// - 处理文档快照到Swift对象的转换
//
// 5. 搜索功能实现
// - 使用前缀匹配实现产品搜索
// - 处理搜索结果的异步回调

import FirebaseFirestore

class FirestoreProductRepository: ProductRepository {
    // Firestore数据库实例
    private let db = Firestore.firestore()
    // 集合名称常量
    private let collection = "products"
    
    // 获取最近的产品
    // 按创建时间倒序排列，限制10条记录
    func getRecentProduct() async throws -> [Product] {
        let snapshot = try await db.collection(collection)
            .order(by: "createdAt", descending: true)
            .limit(to: 10).getDocuments()
        return try snapshot.documents.map { document in
            let product = try document.data(as: Product.self)
            return product
        }
    }
    
    // 根据类别获取产品
    // 使用whereField过滤特定类别的产品
    func getProductByCategory(_ categoryId:String) async throws -> [Product] {
        let snapshot = try await db.collection(collection).whereField("category", isEqualTo: categoryId).getDocuments()
        return try snapshot.documents.map { document in
            let product = try document.data(as: Product.self)
            return product
        }
    }

    // 获取所有产品
    // 不带过滤条件的查询
    func getAllProduct() async throws -> [Product] {
        let snapshot = try await db.collection(collection).getDocuments()
        return try snapshot.documents.map { document in
            let product = try document.data(as: Product.self)
            return product
        }
    }
    
    // 搜索产品
    // 使用前缀匹配实现模糊搜索
    func searchProducts(by name: String, completion: @escaping ([Product]) -> Void) {
        db.collection(collection)
            .whereField("name", isGreaterThanOrEqualTo: name)
            .whereField("name", isLessThanOrEqualTo: name + "\u{f8ff}")
            .getDocuments { (snapshot, error) in
                var products: [Product] = []
                
                if let error = error {
                    print("Error fetching products: \(error)")
                    completion(products)
                    return
                }
                
                for document in snapshot?.documents ?? [] {
                    if let product = try? document.data(as: Product.self) {
                        products.append(product)
                    }
                }
                completion(products)
            }
    }
}
