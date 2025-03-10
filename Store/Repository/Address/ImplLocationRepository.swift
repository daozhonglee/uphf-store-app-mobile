//
//  ImpLocationRepository.swift
//  Store
//
//  Created by Don Arias Agokoli on 07/02/2025.
//

// MARK: - 技术要点
// 1. 位置服务实现
// - 实现LocationRepository接口
// - 使用CLLocationManager管理位置服务
// - 处理位置更新和授权状态
//
// 2. 代理模式应用
// - 实现CLLocationManagerDelegate协议
// - 处理位置更新回调
// - 管理位置服务生命周期
//
// 3. 异步操作处理
// - 使用completion handler处理异步结果
// - 支持位置服务状态变化通知
// - 确保线程安全的位置更新

import Foundation
import CoreLocation

class ImplLocationRepository: NSObject, LocationRepository, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func fetchUserLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        locationManager?.startUpdatingLocation()
        
        // Stocker la closure pour l'utiliser dans le delegate
        self.completionHandler = completion
    }
    
    private var completionHandler: ((Result<CLLocation, Error>) -> Void)?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager?.stopUpdatingLocation()
            completionHandler?(.success(location))
            completionHandler = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completionHandler?(.failure(error))
        completionHandler = nil
    }
}
