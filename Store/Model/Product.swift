//
//  Categorie.swift
//  Store
//
//  Created by Don Arias Agokoli on 17/01/2025.
//

// MARK: - 技术要点
// 1. 数据模型设计
// - 使用结构体(struct)定义产品模型，保证数据的值语义
// - 采用标准的Swift命名规范和属性设计
//
// 2. 协议遵循
// - Identifiable：使模型可在列表和ForEach中使用
// - Codable：支持JSON序列化和反序列化
//
// 3. 属性设计
// - 使用let声明不可变属性，确保数据安全性
// - 包含产品的基本信息：ID、类别、图片URL、名称、价格等
//
// 4. 日期处理
// - 使用Foundation的Date类型处理创建时间
// - 默认值设置为当前时间
//
// 5. 编码键定义
// - 使用CodingKeys枚举定义JSON键名
// - 确保与后端API的数据格式匹配

import Foundation

struct Product: Identifiable, Codable {
    // 产品唯一标识符
    let id: String
    // 产品所属类别
    let category: String
    // 产品图片URL
    let url: String
    // 产品名称
    let name: String
    // 产品价格
    let price: Double
    // 产品描述
    let description: String
    // 产品创建时间
    let createdAt: Date = Date()
    
    // 定义编码键
    // 用于JSON序列化和反序列化
    enum CodingKeys: CodingKey {
        case id
        case category
        case url
        case name
        case price
        case description
        case createdAt
    }
}
