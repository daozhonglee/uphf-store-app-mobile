//
//  OrderSuccessView.swift
//  Store
//
//  Created by Don Arias Agokoli on 21/02/2025.
//

// MARK: - 技术要点
// 1. 视图结构
// - 使用VStack构建垂直布局
// - 集成圆形进度和图标组件
// - 实现订单确认界面的层次布局
//
// 2. 状态管理
// - @StateObject管理结账视图模型
// - @EnvironmentObject注入标签页监控
// - 处理订单状态的更新
//
// 3. 动画效果
// - 使用Circle和trim实现动画效果
// - 自定义图标和颜色样式
// - 优化视觉反馈体验
//
// 4. 交互设计
// - 清晰的订单确认信息展示
// - 实现返回首页的导航逻辑
// - 优化用户操作流程

// 导入SwiftUI框架
import SwiftUI

// 订单成功视图
// 用于显示订单提交成功后的确认页面
struct OrderSuccessView: View {
    // 使用@StateObject创建结账视图模型实例
    // 管理订单相关状态和操作
    @StateObject private var checkoutViewModel = CheckoutViewModel()
    // 订单ID，由父视图传入
    let orderId: String
    
    // 从环境中获取标签页监控对象
    // 用于控制返回首页的导航
    @EnvironmentObject var tabMonitor: TabMonitor
    
    // 视图主体，定义UI结构和布局
    var body: some View {
        // 使用垂直堆栈布局组织视图元素，设置元素间距为32
        VStack(spacing: 32) {
            
            // 创建圆形成功图标
            // 使用Circle和trim构建圆环
            Circle()
                .trim(from: 0, to: 1) // 完整圆环
                .stroke(AppColors.primary, lineWidth: 3) // 设置描边颜色和宽度
                .frame(width: 80, height: 80) // 设置圆环大小
                .overlay { // 在圆环上叠加对勾图标
                    Image(systemName: "checkmark") // 使用系统对勾图标
                        .font(.system(size: 40, weight: .bold)) // 设置图标大小和粗细
                        .foregroundColor(AppColors.primary) // 设置图标颜色
                }
                .padding(.top, 60) // 顶部添加间距
            
            // 确认文本信息区域
            // 包含订单确认标题、感谢信息和订单号
            VStack(spacing: 16) {
                // 订单确认标题
                // 法语文本："订单已确认！"
                Text("Commande confirmée !")
                    .font(.title) // 使用大标题字体
                    .fontWeight(.bold) // 应用粗体样式
                
                // 感谢信息
                // 法语文本："感谢您的订单"
                Text("Merci pour votre commande")
                    .font(.title3) // 使用三级标题字体
                    .foregroundColor(.secondary) // 设置次要文本颜色
                
                // 显示订单号
                // 格式："N° [订单ID]"
                Text("N° \(orderId)")
                    .font(.subheadline) // 使用小标题字体
                    .foregroundColor(.secondary) // 设置次要文本颜色
            }
            
            // 添加弹性空间
            // 将上方内容和下方按钮分开
            Spacer()
            
            // 返回首页按钮
            Button(action:{
                checkoutViewModel.resetView() // 重置结账视图状态
                tabMonitor.selectedTab = .home // 切换到首页标签
            }) {
                // 按钮外观设置
                // 法语文本："返回首页"
                Text("Retour à l'accueil")
                    .font(.headline) // 使用标题字体
                    .foregroundColor(.white) // 文本颜色设为白色
                    .frame(maxWidth: .infinity) // 按钮宽度占满可用空间
                    .padding() // 添加内边距
                    .background(AppColors.primary) // 设置背景色为应用主色调
                    .cornerRadius(10) // 应用圆角
            }
            .padding() // 为按钮添加外边距
        }
    }
}

// 预览提供者（已注释掉）
// 用于在SwiftUI预览画布中显示组件
//struct OrderSuccessView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderSuccessView(orderId: "CMD-123456", shouldPopToRootView: false)
//    }
//}
