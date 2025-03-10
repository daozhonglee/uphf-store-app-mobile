//
//  LocationRepository.swift
//  Store
//
//  Created by Don Arias Agokoli on 07/02/2025.
//

// MARK: - 技术要点
// 1. 位置服务接口
// - 定义统一的位置服务访问接口
// - 支持异步位置信息获取
// - 使用Result类型处理成功和错误情况
//
// 2. CoreLocation集成
// - 集成iOS CoreLocation框架
// - 提供标准化的位置信息访问方法
// - 确保位置服务权限管理
//
// 3. 错误处理
// - 统一的错误处理机制
// - 支持位置服务异常处理
// - 提供清晰的错误反馈

import Foundation
import CoreLocation

protocol LocationRepository {
    func fetchUserLocation(completion: @escaping (Result<CLLocation, Error>) -> Void)
}
