//
//  Category.swift
//  Store
//
//  Created by Don Arias Agokoli on 23/12/2024.
//

// MARK: - 技术要点
// 1. 分类数据模型
// - 使用 Codable 协议实现数据序列化
// - 定义商品分类的基本属性
// - 支持 Firestore 数据映射
//
// 2. 属性设计
// - 使用可选类型处理可能为空的值
// - 提供默认值确保数据完整性
// - 遵循命名规范和最佳实践

import Foundation
import FirebaseFirestoreSwift

// 商品分类数据模型
struct Category: Identifiable, Codable {
    // 使用 @DocumentID 标记 Firestore 文档ID
    @DocumentID var id: String?    // 分类ID
    
    var name: String              // 分类名称
    var description: String       // 分类描述
    var imageUrl: String         // 分类图片URL
    var isActive: Bool           // 是否激活
    var order: Int               // 显示顺序
    var createdAt: Date          // 创建时间
    var updatedAt: Date          // 更新时间
    
    // CodingKeys 枚举定义属性映射关系
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageUrl = "image_url"
        case isActive = "is_active"
        case order
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
