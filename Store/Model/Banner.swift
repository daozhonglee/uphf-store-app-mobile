//
//  Banner.swift
//  Store
//
//  Created by Don Arias Agokoli on 23/12/2024.
//

// MARK: - 技术要点
// 1. 数据模型设计
// - 使用 Codable 协议实现数据序列化
// - 定义横幅广告的基本属性
// - 支持 Firestore 数据映射
//
// 2. 属性设计
// - 使用可选类型处理可能为空的值
// - 提供默认值确保数据完整性
// - 遵循命名规范和最佳实践

import Foundation
import FirebaseFirestoreSwift

// 横幅广告数据模型
struct Banner: Identifiable, Codable {
    // 使用 @DocumentID 标记 Firestore 文档ID
    @DocumentID var id: String?    // 横幅ID
    
    var title: String             // 横幅标题
    var description: String       // 横幅描述
    var imageUrl: String         // 横幅图片URL
    var link: String?           // 点击跳转链接（可选）
    var isActive: Bool          // 是否激活
    var order: Int              // 显示顺序
    var createdAt: Date         // 创建时间
    var updatedAt: Date         // 更新时间
    
    // CodingKeys 枚举定义属性映射关系
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imageUrl = "image_url"
        case link
        case isActive = "is_active"
        case order
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
