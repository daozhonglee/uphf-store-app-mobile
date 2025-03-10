//
//  AddressViewModel.swift
//  Store
//
//  Created by Don Arias Agokoli on 07/02/2025.
//

// MARK: - 技术要点
// 1. 位置服务集成
// - 使用CoreLocation框架获取用户位置
// - 实现地理编码和反向地理编码
// - 处理位置权限和隐私设置
//
// 2. 状态管理
// - 使用@Published实现响应式更新
// - 管理位置信息和地址名称状态
// - 实现位置数据的实时更新
//
// 3. 错误处理
// - 处理位置获取失败情况
// - 地理编码错误处理
// - 提供用户友好的错误提示
//
// 4. 依赖注入
// - 通过接口抽象位置服务
// - 支持测试和模拟数据
// - 降低组件间耦合度

// 导入基础框架
import Foundation
// 导入CoreLocation框架，用于位置服务和地理编码
import CoreLocation

/// 位置视图模型类
/// 负责管理用户位置信息和地址名称，提供位置服务的核心功能
/// 采用ObservableObject协议支持SwiftUI的数据绑定机制
class LocationViewModel: ObservableObject {
    // 用户当前位置，使用@Published包装器实现数据绑定
    // 当位置更新时，会自动通知观察者
    @Published var userLocation: CLLocation?
    
    // 位置名称（如城市、街道等），用于UI显示
    // 通过反向地理编码从坐标获取
    @Published var locationName: String = ""
    
    // 位置仓储接口，通过依赖注入方式引入
    // 使用接口而非具体实现，提高代码可测试性
    private var locationRepository: LocationRepository
    
    // 初始化方法，支持依赖注入
    // 默认使用ImplLocationRepository实现
    // 便于单元测试时注入模拟实现
    init(repository: LocationRepository = ImplLocationRepository()) {
        self.locationRepository = repository
    }
    
    /// 获取用户当前位置信息
    /// 调用位置仓储接口获取用户位置坐标
    /// 成功后更新位置状态并执行反向地理编码
    func getUserLocation() {
        // 通过仓储接口异步获取位置信息
        locationRepository.fetchUserLocation { result in
            switch result {
            case .success(let location):
                // 更新用户位置状态
                self.userLocation = location
                // 执行反向地理编码获取位置名称
                self.reverseGeocode(location: location)
            case .failure(let error):
                // 处理位置获取失败的情况
                print("Error fetching location: \(error)")
            }
        }
    }
    
    /// 反向地理编码方法
    /// 将坐标转换为可读的地址名称
    /// - Parameter location: 用户位置坐标
    private func reverseGeocode(location: CLLocation) {
        // 创建地理编码器实例
        let geocoder = CLGeocoder()
        // 执行反向地理编码操作
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                // 处理地理编码错误
                print("Error in reverse geocoding: \(error)")
                return
            }
            if let placemark = placemarks?.first {
                // 更新位置名称，如果为空则使用默认值
                self.locationName = placemark.name ?? "Unknown Location"
            }
        }
    }
}
