//
//  OrderView.swift
//  Store
//
//  Created by Don Arias Agokoli on 21/02/2025.
//

// MARK: - 技术要点
// 1. 订单列表视图
// - 使用List组件展示订单列表
// - 实现订单详情的布局和样式
// - 支持订单历史记录的浏览
//
// 2. 状态管理
// - @StateObject管理结账视图模型
// - @EnvironmentObject注入认证状态
// - 实现订单数据的响应式更新
//
// 3. 数据格式化
// - 自定义DateFormatter处理日期显示
// - 格式化订单金额和状态信息
// - 确保数据展示的一致性
//
// 4. 生命周期管理
// - onAppear时初始化视图模型
// - 自动加载用户订单数据
// - 维护视图状态的同步

// 导入SwiftUI框架
import SwiftUI

// 订单视图
// 用于显示用户的历史订单列表
struct OrderView : View {
    // 使用@StateObject创建结账视图模型实例
    // 管理订单数据的获取和处理
    @StateObject private var checkoutViewModel = CheckoutViewModel()
    // 从环境中获取认证视图模型
    // 用于访问用户登录状态和信息
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // 视图主体，定义UI结构和布局
    var body: some View {
        
        // 使用垂直堆栈布局组织视图元素
        VStack{
            // 使用List组件展示订单列表
            // 支持滚动和动态更新
            List {
                // 遍历所有订单并创建列表项
                ForEach(checkoutViewModel.orders) { item in
                    // 订单信息区域
                    // 显示订单ID、日期和状态
                    VStack(alignment: .leading) {
                        // 订单ID和日期行
                        HStack{
                            // 显示订单ID，前缀为#
                            Text("#\(item.id!)")
                            Spacer()
                            // 显示格式化的订单日期
                            Text("\(item.createdAt, formatter: dateFormatter)")
                        }
                        // 显示订单状态
                        Text("\(item.statut)")
                    }
                    // 订单总价行
                    HStack{
                        // "总计"标签
                        Text("Total")
                        Spacer()
                        // 显示格式化的订单金额，保留两位小数
                        Text("\(String(format: "%.2f", item.total)) €")
                    }
                    
                }
            }
        }
        // 视图出现时执行初始化操作
        .onAppear{
            // 设置结账视图模型，传入认证视图模型
            self.checkoutViewModel.setup(self.authViewModel)
            // 获取用户的订单历史
            checkoutViewModel.fetchOrders()
            
            
        }
    }
    
    // 自定义日期格式化器
    // 用于将日期对象转换为指定格式的字符串
    private let dateFormatter: DateFormatter = {
        // 创建日期格式化器实例
        let formatter = DateFormatter()
        // 设置日期格式为日/月/年
        formatter.dateFormat = "dd/MM/yyyy"
        // 返回配置好的格式化器
        return formatter
    }()
}
