//
//  CartView.swift
//  market
//
//  Created by Don Arias Agokoli on 23/12/2024.
//

// 导入所需的框架
import SwiftUI
import StripeCore  // 用于支付功能
import PassKit    // 用于Apple Pay支持

// 购物车主视图
// 实现了购物车的核心功能，包括商品列表展示、数量调整、删除商品等
struct CartView: View {
    // 使用@StateObject管理购物车视图模型
    // 确保视图模型的生命周期与视图一致，避免数据丢失
    @StateObject private var cartViewModel = CartViewModel()
    
    // 使用@EnvironmentObject注入认证视图模型
    // 实现跨视图的状态共享，用于处理用户登录状态
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // 使用@State管理配送信息视图的显示状态
    // 控制配送信息页面的导航跳转
    @State private var deliveryInfoView: Bool = false

    var body: some View {
        // 主视图容器，使用VStack垂直布局
        VStack {
            // 根据购物车是否为空显示不同的视图
            // 空购物车显示提示信息，非空显示商品列表
            if cartViewModel.cartItems.isEmpty {
                EmptyCartView()
            } else {
                // 使用List展示购物车商品列表
                // 支持滚动和商品项的动态更新
                List {
                    ForEach(cartViewModel.cartItems) { item in
                        CartItemRow(item: item, viewModel: cartViewModel)
                    }
                }
                
                // 显示购物车总结信息
                // 包含总价和下单按钮
                CartSummary(
                    total: cartViewModel.total,
                    onOrder: {
                        // 点击下单按钮时导航到配送信息页面
                        deliveryInfoView = true
                    },
                    onNotLoggedIn: {
                        // 未登录时导航到认证页面
                        authViewModel.navigateToAuthView = true
                    }
                )
            }
        }
        // 显示提示信息的警告框
        // 用于显示操作结果和错误提示
        .alert(isPresented: $authViewModel.showAlert) {
            Alert(title: Text("Information"), message: Text(authViewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        // 以底部弹出的方式显示登录视图
        // 使用sheet实现模态展示，fraction参数控制显示高度
        .sheet(isPresented: $authViewModel.navigateToAuthView, content: {
            AuthView().presentationDetents([.fraction(0.15)])
        })
        
        // 导航到配送信息页面
        // 使用navigationDestination实现页面跳转
        .navigationDestination(isPresented: $deliveryInfoView ) {
            DeliveryInfoView()
        }
        // 视图出现时加载购物车数据
        // 确保显示最新的购物车内容
        .onAppear{
            cartViewModel.loadCart()
        }
        // 支持下拉刷新
        // 用户可以通过下拉手势刷新购物车数据
        .refreshable {
            cartViewModel.loadCart()
        }
        .navigationTitle("Panier")
    }
}

// 购物车商品行视图
// 显示单个商品的详细信息，包括图片、名称、价格和数量控制
struct CartItemRow: View {
    // 商品数据模型
    // 包含商品的基本信息和数量
    let item: Cart
    
    // 观察购物车视图模型的变化
    // 用于更新商品数量和删除商品
    @ObservedObject var viewModel: CartViewModel
    
    var body: some View {
        HStack {
            // 异步加载商品图片
            // 使用AsyncImage支持网络图片的异步加载
            // 显示加载进度指示器
            AsyncImage(url: URL(string: item.product.url)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            
            // 商品信息
            // 显示商品名称和价格
            VStack(alignment: .leading) {
                Text(item.product.name)
                    .lineLimit(2)
                    .font(.headline)
                Text("\(String(format: "%.2f", item.product.price)) €")
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // 商品数量调整控件
            // 包含减少、显示数量、增加三个部分
            HStack {
                Button(action: {
                    viewModel.updateQuantity(productId: item.product.id, quantity: item.quantity - 1)
                }) {
                    Image(systemName: "minus.circle")
                }.buttonStyle(BorderlessButtonStyle())
                
                Text("\(item.quantity)").frame(width: 30)
                
                Button(action: {
                    viewModel.updateQuantity(productId: item.product.id, quantity: item.quantity + 1)
                }) {
                    Image(systemName: "plus.circle")
                }.buttonStyle(BorderlessButtonStyle())
            }
        }
        // 支持向左滑动删除商品
        // 使用swipeActions添加滑动删除功能
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                viewModel.removeFromCart(productId: item.product.id)
            } label: {
                Label("Supprimer", systemImage: "trash")
            }
        }
    }
}
