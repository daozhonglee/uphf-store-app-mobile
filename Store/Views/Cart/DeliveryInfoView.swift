//
//  DeliveryInfoView.swift
//  Store
//
//  Created by Don Arias Agokoli on 14/02/2025.
//

// MARK: - 技术要点
// 1. 视图结构
// - 使用 SwiftUI 的 VStack 构建表单布局
// - 实现响应式的送货信息输入界面
// - 集成 Stripe Payment Sheet 进行支付处理
//
// 2. 状态管理
// - @EnvironmentObject 注入全局认证状态
// - @StateObject 管理本地视图模型
// - @State 处理表单验证状态
//
// 3. 支付集成
// - 使用 StripePaymentSheet 实现安全支付
// - 处理支付结果回调
// - 动态更新支付按钮状态
//
// 4. 表单验证
// - 实时验证用户输入
// - 使用 isValidated 控制支付按钮状态
// - 确保所有必填字段完整

// 导入SwiftUI框架，用于构建用户界面
import SwiftUI
// 导入Stripe支付表单组件
import StripePaymentSheet


/// 配送信息视图
/// 用于收集用户配送地址信息并处理支付流程
/// 集成了Stripe支付功能，实现了表单验证和状态管理
struct DeliveryInfoView: View {
    // 从环境中获取认证视图模型，用于访问用户信息
    @EnvironmentObject var authViewModel: AuthViewModel
    // 控制是否导航到认证页面的状态
    @State private var navigateToAuth: Bool = false
    // 位置视图模型，管理地址相关功能
    @StateObject private var locationViewModel = LocationViewModel()
    // 结账视图模型，处理支付和订单提交
    @StateObject private var checkoutViewModel = CheckoutViewModel()
    // 购物车视图模型，管理购物车商品
    @StateObject private var cartViewModel = CartViewModel()
    
    // 表单验证状态，控制支付按钮的可用性
    @State private var isValidated = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            // 配送信息表单
            VStack(spacing: 20){
                
                // 姓名输入框
                TextField("Nom Complet", text: $checkoutViewModel.fullName)
                    .onChange(of: checkoutViewModel.fullName) {
                        updateValidation() // 实时验证表单
                    }
                
                // 地址输入框
                TextField("Adresse", text: $checkoutViewModel.address)
                    .onChange(of: checkoutViewModel.address) {
                        updateValidation() // 实时验证表单
                    }
                
                // 城市输入框
                TextField("Ville", text: $checkoutViewModel.city)
                    .onChange(of: checkoutViewModel.city) {
                        updateValidation() // 实时验证表单
                    }
                
                // 邮政编码输入框
                TextField("Code Postal", text: $checkoutViewModel.postalCode)
                    .onChange(of: checkoutViewModel.postalCode) {
                        updateValidation() // 实时验证表单
                    }
                
                
            }
            .padding()
            .disableAutocorrection(true) // 禁用自动更正
            .textFieldStyle(.roundedBorder) // 应用圆角边框样式
            
            
            Spacer()
            
            // 支付按钮区域
            // 根据表单验证状态和支付表单可用性动态显示
            if isValidated, let paymentSheet = checkoutViewModel.paymentSheet {
                // Stripe支付按钮，集成了支付表单和回调处理
                PaymentSheet.PaymentButton(
                    paymentSheet: paymentSheet,
                    onCompletion: checkoutViewModel.onCompletion // 支付完成回调
                ) {
                    
                    // 支付按钮UI
                    Text("Commander et payer") // "下单并支付"
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.primary) // 使用应用主色调
                        .cornerRadius(10)
                        .padding()
                }
            } else {
                // 禁用状态的支付按钮
                // 当表单未验证通过或支付表单未准备好时显示
                Text("Commander et payer") // "下单并支付"
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background((isValidated && checkoutViewModel.paymentSheet != nil) ? AppColors.primary : .gray) // 根据状态切换颜色
                    .cornerRadius(10)
                    .padding()
            }
            
            
            
            
        }
        .onAppear {
            // 视图出现时初始化
            // 设置认证视图模型
            self.checkoutViewModel.setup(self.authViewModel)
            // 获取购物车商品
            checkoutViewModel.getCarts()
            // 准备支付表单
            checkoutViewModel.preparePaymentSheet()
            
        }
        .toolbar(.hidden, for: .tabBar) // 隐藏标签栏
        .background(Color(.systemBackground)) // 设置背景色
        .navigationBarTitle("Livraison", displayMode: .inline) // 设置导航栏标题为"配送"
        
        // 订单完成后导航到成功页面
        .navigationDestination(isPresented: $checkoutViewModel.orderIsCompleted){
            OrderSuccessView(orderId: checkoutViewModel.orderId).navigationBarBackButtonHidden() // 隐藏返回按钮
        }
    }
    
    /// 更新表单验证状态
    /// 检查所有必填字段是否已填写
    /// 当任何输入字段发生变化时调用
    private func updateValidation() {
        isValidated = !checkoutViewModel.fullName.isEmpty &&
        !checkoutViewModel.address.isEmpty &&
        !checkoutViewModel.city.isEmpty &&
        !checkoutViewModel.postalCode.isEmpty
    }
}



