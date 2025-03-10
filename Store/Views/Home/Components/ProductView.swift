//
//  ProductsSection.swift
//  Store
//
//  Created by Don Arias Agokoli on 31/01/2025.
//

// MARK: - 技术要点
// 1. 视图结构
// - 使用LazyVGrid实现网格布局
// - 实现响应式商品列表
// - 支持异步图片加载
//
// 2. 状态管理
// - @StateObject管理商品数据
// - @EnvironmentObject注入认证状态
// - @State处理视图生命周期
//
// 3. 性能优化
// - 使用LazyVGrid实现延迟加载
// - 异步加载商品图片
// - 优化列表性能
//
// 4. 用户交互
// - 实现商品卡片布局
// - 支持商品详情导航
// - 集成购物车功能

// 导入SwiftUI框架，用于构建用户界面
import SwiftUI

// 商品视图组件
// 显示最近添加的商品列表，使用网格布局
struct ProductView: View {
    // 使用@StateObject创建并管理ProductViewModel实例，负责商品数据获取和处理
    // 确保视图模型的生命周期与视图一致，避免数据丢失
    @StateObject private var viewModel = ProductViewModel()
    // 使用@EnvironmentObject注入认证视图模型，实现用户状态的共享
    // 用于访问用户登录状态和相关信息
    @EnvironmentObject var authViewModel: AuthViewModel
    // 使用@State跟踪视图是否已经出现，避免重复加载数据
    // 防止在视图多次出现时重复调用网络请求
    @State private var didAppear = false
    
    // 定义网格列配置，设置最小宽度为150的自适应网格项
    // 用于创建响应式的网格布局，根据屏幕宽度自动调整列数
    let columns = [
           GridItem(.adaptive(minimum: 150))
       ]
    
    // 视图主体，定义UI结构和布局
    var body: some View {
        // 使用ZStack叠加布局，根据加载状态显示不同内容
        // 实现条件渲染，优化用户体验
        ZStack {
            // 如果数据正在加载中，显示加载指示器
            // 提供视觉反馈，表明内容正在加载
            if viewModel.isLoading {
                ProgressView()
            } else {
                // 使用垂直堆栈布局组织商品视图元素，设置左对齐
                // 确保标题和内容左侧对齐，提升视觉一致性
                VStack(alignment: .leading) {
                    // 显示"最近商品"标题文本
                    // 法语文本："最近商品"
                    Text("Produits récents")
                        .font(.title2).padding(.horizontal) // 使用二级标题字体并添加水平内边距
                    
                    // 创建滚动视图，允许垂直滚动浏览商品
                    // 当商品数量较多时，确保用户可以滚动查看所有内容
                    ScrollView {
                        // 使用LazyVGrid创建网格布局，设置两列灵活宽度的网格
                        // 延迟加载提高性能，只渲染可见区域的内容
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                        ], spacing: 20 ) { // 设置网格项间距为20
                            // 遍历所有最近商品数据，创建商品行
                            // 动态生成商品列表，支持任意数量的商品
                            ForEach(viewModel.recentProduct) { item in
                                ProductRow(product: item)
                            }
                        }
                       // .padding(.horizontal)
                        .padding(.leading) // 添加左侧内边距
                    }
                }
            }
        }
        // 添加错误提示弹窗，当viewModel.error不为nil时显示
        // 使用Binding创建双向绑定，处理错误状态的显示和清除
        .alert("Erreur", isPresented: Binding(
            get: { viewModel.error != nil },
            set: { if !$0 { viewModel.error = nil } }
        )) {
            // 显示错误信息文本
            // 如果错误为nil，则显示空字符串
            Text(viewModel.error?.localizedDescription ?? "")
        }
        // 视图出现时的处理逻辑
        // 用于初始化数据，确保视图显示正确内容
        .onAppear {
            // 注释掉的代码：检查是否是首次出现，如果是则获取商品数据
            // if !didAppear {
            //     viewModel.fetchProduct()
            //     didAppear = true
            // }
            
        }
    }
    
}

// 商品行视图组件
// 定义单个商品的卡片样式和内容
struct ProductRow: View {
    // 商品数据模型，包含商品的信息
    let product: Product
    // 使用@StateObject创建并管理CartViewModel实例，负责购物车操作
    @StateObject private var cartViewModel = CartViewModel()
    
    // 视图主体，定义UI结构和布局
    var body: some View {
        // 创建导航链接，点击时跳转到商品详情页面
        NavigationLink(destination: ProductDetailView(product: product)){
            // 使用垂直堆栈布局组织商品卡片元素，设置左对齐
            VStack(alignment: .leading) {
                // 异步加载商品图片，支持占位符显示
                AsyncImage(url: URL(string: product.url)) { image in
                    image
                        .resizable() // 使图片可调整大小
                        .scaledToFill() // 填充模式，保持图片比例
                        .frame(width: 170, height: 112) // 设置图片尺寸
                        
                        
                } placeholder: {
                    // 加载过程中显示进度指示器
                    ProgressView()
                }
                .frame(height: 150) // 设置图片容器高度
                .clipped() // 裁剪超出边界的内容
                .cornerRadius(10) // 添加圆角效果
                
                // 商品信息部分
                VStack(alignment: .leading, spacing: 8) {
                    // 显示商品名称
                    Text(product.name)
                        .font(.subheadline) // 使用副标题字体
                        .lineLimit(2) // 限制文本为两行
                        .multilineTextAlignment(.leading) // 设置文本左对齐
                        .foregroundColor(.primary) // 使用主要文本颜色
                    
                    // 显示商品价格，格式化为两位小数
                    Text("\(String(format: "%.2f", product.price)) €")
                        .font(.headline) // 使用标题字体
                        .foregroundColor(.primary) // 使用主要文本颜色
                }
                .padding(.horizontal, 12) // 添加水平内边距
                
                // 添加到购物车按钮
                Button(action: {
                    // 点击时调用添加到购物车方法
                    cartViewModel.addToCart(product: product)
                }) {
                    // 按钮样式设置
                    Text("Ajouter au panier") // 按钮文本：添加到购物车
                        .foregroundColor(.white) // 设置文本颜色为白色
                        .frame(maxWidth: .infinity) // 按钮宽度占满容器
                        .padding(.vertical, 8) // 添加垂直内边距
                        .background(AppColors.primary) // 设置背景色为应用主色
                        .cornerRadius(8) // 添加圆角效果
                }
                .buttonStyle(PlainButtonStyle()) // 应用朴素按钮样式，避免默认样式干扰
                .padding(.horizontal, 12) // 添加水平内边距
                
                .padding(.bottom, 12) // 添加底部内边距
            }
                // 添加提示弹窗，当添加到购物车操作完成时显示
                .alert(isPresented: $cartViewModel.showAlert) { // 当showAlert为true时显示弹窗
                    Alert(title: Text("Information"), message: Text(cartViewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
                //.padding(.horizontal, 12)
                //.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                //.padding()
                .background(Color(.systemGray6)) // 设置卡片背景色为浅灰色
                .cornerRadius(12) // 添加圆角效果，提升视觉体验
                //.padding(.horizontal)
        }
       
    }

}

// 商品行演示视图组件
// 提供另一种商品卡片样式的实现，更加精美和现代化
struct ProductRowDemo: View {
    // 商品数据模型，包含商品的信息
    let product: Product
    // 使用@StateObject创建并管理CartViewModel实例，负责购物车操作
    @StateObject private var cartViewModel = CartViewModel()
    // 使用@Environment获取当前的颜色方案（深色/浅色模式）
    @Environment(\.colorScheme) private var colorScheme
    
    // 视图主体，定义UI结构和布局
    var body: some View {
        // 使用ZStack叠加布局，底部对齐，实现按钮悬浮效果
        ZStack(alignment: .bottom) {
            // 主卡片部分
            VStack(alignment: .leading, spacing: 12) {
                // 商品图片部分
                AsyncImage(url: URL(string: product.url)) { image in
                    image
                        .resizable() // 使图片可调整大小
                        .aspectRatio(contentMode: .fill) // 填充模式，保持图片比例
                } placeholder: {
                    // 加载过程中显示占位符和进度指示器
                    ZStack {
                        Color.gray.opacity(0.1) // 浅灰色背景
                        ProgressView()
                            .tint(Color.gray) // 设置进度指示器颜色为灰色
                    }
                }
                .frame(height: 180) // 设置图片容器高度
                .clipped() // 裁剪超出边界的内容
                .cornerRadius(12) // 添加圆角效果
                
                // 商品信息部分
                VStack(alignment: .leading, spacing: 8) {
                    // 显示商品名称
                    Text(product.name)
                        .font(.system(size: 16, weight: .medium)) // 设置字体大小和粗细
                        .lineLimit(2) // 限制文本为两行
                        .foregroundColor(colorScheme == .dark ? .white : .black) // 根据深色/浅色模式调整文本颜色
                    
                    // 显示商品价格，格式化为两位小数
                    Text("\(String(format: "%.2f", product.price)) €")
                        .font(.system(size: 18, weight: .bold)) // 设置字体大小和粗细
                        .foregroundColor(AppColors.primary) // 使用应用主色
                    
                    Spacer(minLength: 40) // 添加弹性空间，为按钮预留位置
                }
                .padding(.horizontal, 12) // 添加水平内边距
            }
            .padding(12) // 为整个VStack添加内边距
            .background(colorScheme == .dark ? Color(.systemGray6) : Color.white) // 根据深色/浅色模式调整背景颜色
            .cornerRadius(16) // 添加圆角效果
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2) // 添加阴影效果，提升立体感
            
            // 添加到购物车按钮，悬浮在卡片底部
            Button(action: {
                // 使用弹簧动画效果添加商品到购物车
                withAnimation(.spring()) {
                    cartViewModel.addToCart(product: product)
                }
            }) {
                // 按钮内容布局
                HStack {
                    // 显示购物车图标
                    Image(systemName: "cart.badge.plus")
                        .font(.system(size: 14)) // 设置图标大小
                    // 显示按钮文本
                    Text("Ajouter au panier") // 按钮文本：添加到购物车
                        .font(.system(size: 14, weight: .semibold)) // 设置字体大小和粗细
                }
                .foregroundColor(.white) // 设置文本颜色为白色
                .frame(maxWidth: .infinity) // 按钮宽度占满容器
                .padding(.vertical, 12) // 添加垂直内边距
                .background(AppColors.primary) // 设置背景色为应用主色
                .cornerRadius(10) // 添加圆角效果
            }
            .buttonStyle(PlainButtonStyle()) // 应用朴素按钮样式，避免默认样式干扰
            .padding(.horizontal, 24) // 添加水平内边距
            .padding(.bottom, 16) // 添加底部内边距
        }
        // 添加提示弹窗，当添加到购物车操作完成时显示
        .alert(isPresented: $cartViewModel.showAlert) {
            Alert(
                title: Text("Produit ajouté"), // 弹窗标题：商品已添加
                message: Text(cartViewModel.alertMessage), // 显示提示消息
                dismissButton: .default(Text("OK")) // 确认按钮
            )
        }
        // 使用透明的NavigationLink覆盖整个卡片，实现点击跳转到商品详情
        .overlay(
            NavigationLink(destination: ProductDetailView(product: product)) {
                Rectangle()
                    .fill(Color.clear) // 使用透明填充
            }
            .opacity(0)
        )
    }
}
