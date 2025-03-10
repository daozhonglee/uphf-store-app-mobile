//
//  DeliveryAddressView.swift
//  Store
//
//  Created by Don Arias Agokoli on 07/02/2025.
//

// MARK: - 技术要点
// 1. 位置服务集成
// - 使用LocationViewModel获取用户位置
// - 显示当前配送地址信息
// - 实现位置名称的动态更新
//
// 2. 界面布局
// - 使用HStack和VStack构建水平和垂直布局
// - 实现配送地址和通知图标的排版
// - 优化文本样式和间距
//
// 3. 状态管理
// - @StateObject管理位置视图模型
// - 视图生命周期中获取位置信息
// - 处理位置数据的实时更新
//
// 4. 用户体验
// - 清晰展示配送地址信息
// - 集成通知图标功能
// - 优化视觉层次和可读性

// 导入SwiftUI框架，用于构建用户界面
import SwiftUI

/// 配送地址视图
/// 显示用户当前配送地址和通知图标
/// 集成位置服务获取实时地址信息
struct DeliveryAddressView: View {
    // 使用@StateObject创建并管理LocationViewModel实例
    // 确保视图模型的生命周期与视图一致，避免数据丢失
    // 负责获取和处理用户位置信息
    @StateObject private var locationViewModel = LocationViewModel()
    var body: some View {
        // 使用水平堆栈布局组织配送地址和通知图标
        // 实现左右两侧的内容排布
        HStack {
            // 使用垂直堆栈布局组织配送地址信息
            // 设置左对齐，确保文本靠左显示
            VStack(alignment: .leading) {
                // 显示"配送地址"标签文本
                // 使用灰色前景色降低视觉权重
                Text("Adresse de livraison")
                    .foregroundColor(.gray)
                // 显示从位置视图模型获取的位置名称
                // 使用标题字体增强视觉突出度
                Text(locationViewModel.locationName).font(.headline)
            }
            // 添加弹性空间，将左侧地址信息和右侧通知图标分开
            Spacer()
            
            // 通知图标区域
            // 注释掉的代码是带数字的徽章实现
            // Badge(count: 2)
            // 显示系统提供的铃铛图标作为通知入口
            // 使用SF Symbols系统图标库
            Image(systemName: "bell")
                .font(.title2) // 设置图标大小为二级标题大小
        }
        // 视图出现时的生命周期回调
        // 用于初始化位置信息，确保视图显示最新数据
        .onAppear {
            // 调用位置视图模型的方法获取用户位置
            locationViewModel.getUserLocation()
        }
        // 为整个视图添加内边距
        // 确保内容不会紧贴屏幕边缘，提升视觉体验
        .padding()
    }
}
