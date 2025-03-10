//
//  CheckoutViewModel.swift
//  Store
//
//  Created by Don Arias Agokoli on 16/02/2025.
//

// MARK: - 技术要点
// 1. 支付处理
// - 集成 Stripe Payment Sheet 实现安全支付
// - 处理支付状态和结果回调
// - 管理支付配置和客户端密钥
//
// 2. 订单管理
// - 使用 Firestore 存储订单信息
// - 实现订单创建和状态更新
// - 处理订单完成后的购物车清理
//
// 3. 状态追踪
// - 使用 @Published 属性包装器实现响应式状态
// - 跟踪支付和订单状态变化
// - 处理错误状态和用户反馈
//
// 4. 依赖注入
// - 采用仓储模式管理数据访问
// - 支持测试的依赖注入设计
// - 灵活的初始化配置

// 导入所需的框架
import Foundation
import Combine
import StripePaymentSheet  // Stripe支付处理
import FirebaseFirestore  // Firebase数据库
import Alamofire         // 网络请求
import SwiftUICore       // UI核心组件
import FirebaseAuth      // Firebase认证
import FirebaseAnalytics // Firebase分析

// 确保所有UI更新在主线程执行
@MainActor
class CheckoutViewModel: ObservableObject {
    // MARK: - 支付相关属性
    @Published var paymentSheet: PaymentSheet?  // Stripe支付页面
    @Published var cartItems: [Cart] = []       // 购物车商品列表
    @Published var orders: [Order] = []         // 订单列表
    @Published var totalAmount: Double?         // 总金额
    
    // MARK: - 收货地址信息
    @Published var fullName: String = ""     // 收货人姓名
    @Published var address: String = ""      // 收货地址
    @Published var city: String = ""         // 城市
    @Published var postalCode: String = ""   // 邮政编码
    
    // MARK: - Firebase相关
    private let db = Firestore.firestore()    // Firestore数据库实例
    private let collection = "orders"         // 订单集合名称
    
    // Stripe API密钥
    let publishableKey = "pk_test_oKhSR5nslBRnBZpjO6KuzZeX"
    
    // MARK: - 状态追踪
    @Published var paymentResult: PaymentSheetResult?  // 支付结果
    @Published var paymentIsCompleted = false         // 支付是否完成
    @Published var orderIsCompleted = false          // 订单是否完成
    @Published var paymentIsFailed = false           // 支付是否失败
    @Published var paymentIsCancelled = false        // 支付是否取消
    
    @Published var orderId: String = ""            // 订单ID
    @Published var error = ""                      // 错误信息
    
    // MARK: - 依赖注入的仓储
    private var stripeRepository: StripeRepository       // Stripe支付仓储
    private var authRepository: AuthRepository         // 认证仓储
    private var cartRepository: CartRepository         // 购物车仓储
    private var checkoutRepository: CheckoutRepository // 结账仓储
    
    // 认证视图模型引用
    var authViewModel: AuthViewModel?
     
    /// 设置认证视图模型
    /// - Parameter authViewModel: 认证视图模型实例
    /// 用于获取用户信息和支付相关数据
    func setup(_ authViewModel: AuthViewModel) {
       self.authViewModel = authViewModel
    }
    
    // MARK: - 初始化方法
    /// 初始化结账视图模型
    /// - Parameters:
    ///   - stripRepository: Stripe支付仓储，默认使用StripeRepositoryImpl
    ///   - authRepository: 认证仓储，默认使用FirebaseAuthRepository
    ///   - cartRepository: 购物车仓储，默认使用LocalCartRepository
    ///   - checkoutRepository: 结账仓储，默认使用FirestoreCheckoutRepository
    /// 通过依赖注入方式初始化各个仓储，支持单元测试和模块解耦
    init(
        stripRepository: StripeRepository = StripeRepositoryImpl(),
        authRepository: AuthRepository = FirebaseAuthRepository(),
        cartRepository: CartRepository = LocalCartRepository(),
        checkoutRepository: CheckoutRepository = FirestoreCheckoutRepository()
    ) {
        self.stripeRepository = stripRepository
        self.authRepository = authRepository
        self.cartRepository = cartRepository
        self.checkoutRepository = checkoutRepository
        
        // 初始化时获取订单列表
        fetchOrders()
    }
    
    // MARK: - 订单管理方法
    
    /// 获取用户订单列表
    /// 从Firestore数据库获取当前用户的所有订单
    /// 使用异步任务处理网络请求
    func fetchOrders() {
        Task {
            if let uid = authViewModel?.user?.uid {
                self.orders = try await checkoutRepository.getOrders(uid)
            } 
        }
    }
    
    /// 获取购物车商品
    /// 从购物车仓储获取商品列表
    /// 同时计算购物车总金额
    func getCarts() {
        self.cartItems = cartRepository.getCarts()
        if(!self.cartItems.isEmpty){
            // 计算总金额
            totalAmount = self.cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
        }
    }
    
    /// 清空购物车
    /// 在订单完成后调用，清除所有购物车商品
    func cleanCart() {
        self.cartRepository.clearCart()
    }
    
    /// 重置视图状态
    /// 用于重新开始结账流程
    func resetView() {
        self.orderIsCompleted = false
    }
    
    // MARK: - 支付处理方法
    
    /// 准备支付页面
    /// 配置Stripe支付页面并创建支付意图
    /// 处理客户端密钥获取和支付配置
    func preparePaymentSheet() {
        // 检查总金额和客户信息是否存在
        if let totalAmount, ((self.authViewModel?.customer) != nil) {
            // 设置Stripe API密钥
            STPAPIClient.shared.publishableKey = publishableKey
            
            // 创建支付参数
            let parameters = PaymentParameters(customer: self.authViewModel!.customer!.paymentId, amount: totalAmount * 100)
            
            // 创建支付意向
            self.stripeRepository.createPaymentIntent(postData: parameters) { result in
                switch result {
                case .success(let clientSecret):
                    // 配置支付页面
                    var configuration = PaymentSheet.Configuration()
                    configuration.merchantDisplayName = "UPHF Store"
                    configuration.defaultBillingDetails.address.country = "FR"
                    configuration.paymentMethodOrder = ["card"]
                    
                    // 在主线程更新UI
                    DispatchQueue.main.async {
                        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: clientSecret, configuration: configuration)
                    }
                    
                case .failure(let error):
                    print("error==>\(error)")
                }
            }
        }
    }
    
    // MARK: - 订单提交
    
    /// 提交订单到Firestore
    /// 创建订单对象并保存到数据库
    /// 处理订单完成后的状态更新
    func submitOrder() {
        do{
            // 生成订单ID - 使用UUID创建唯一标识符
            self.orderId = UUID().uuidString
            // 截取UUID的后半部分作为订单ID，使其更简短易读
            self.orderId = String(self.orderId[self.orderId.index(self.orderId.startIndex, offsetBy: 24)...])
            
            // 创建订单对象 - 包含所有必要的订单信息
            let order = Order(
                id: self.orderId,                          // 订单唯一标识符
                userId: self.authViewModel!.customer!.id,  // 用户ID，关联订单与用户
                cart: self.cartItems,                     // 购物车商品列表
                total: self.totalAmount!,                 // 订单总金额
                statut: "En cours de traitement",          // 订单状态：处理中
                statutPayment: "Payé",                    // 支付状态：已支付
                address: ShippingAddress(
                    fullName: self.fullName,
                    address: self.address,
                    city: self.city,
                    postalCode: self.postalCode
                )
            )
            
            // 保存订单到Firestore
            try db.collection(self.collection).document(self.orderId).setData(from: order) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    // 订单保存成功后的处理
                    self.cleanCart()             // 清空购物车
                    self.orderIsCompleted = true // 标记订单完成
                    self.paymentSheet = nil      // 清除支付页面
                }
            }
        } catch {
            print("Error encoding order: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 支付结果处理
    
    /// 处理支付完成回调
    /// - Parameter result: 支付结果
    /// 根据支付结果执行不同的操作：
    /// - 成功：提交订单
    /// - 失败：显示错误并重新准备支付
    /// - 取消：重新准备支付
    func onCompletion(result: PaymentSheetResult) {
        self.paymentResult = result
        
        switch result {
        case .completed:
            submitOrder()  // 支付成功，提交订单
        case .failed(let error):
            self.paymentIsFailed = true
            self.error = error.localizedDescription
            preparePaymentSheet()  // 重新准备支付页面
        case .canceled:
            self.paymentIsCancelled = true
            preparePaymentSheet()  // 重新准备支付页面
        }
    }
}
