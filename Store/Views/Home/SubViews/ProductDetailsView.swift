//
//  ProductDetails.swift
//  Store
//
//  Created by Don Arias Agokoli on 31/01/2025.
//

// MARK: - 技术要点
// 1. 视图结构
// - 使用ScrollView实现可滚动的商品详情页
// - 采用VStack布局组织商品信息
// - 支持异步图片加载和占位符显示
//
// 2. 状态管理
// - @StateObject管理购物车视图模型
// - @State控制加载状态
// - 实现商品数据的展示和更新
//
// 3. 用户交互
// - 实现添加购物车功能
// - 集成加载状态反馈
// - 提供用户操作提示
//
// 4. 界面优化
// - 响应式布局适配
// - 优化图片加载体验
// - 统一的视觉风格

import SwiftUI

struct ProductDetailView: View {
    // 商品数据模型，包含商品的详细信息
    // 由父视图传入，用于显示商品详情
    let product: Product
    
    // 使用@StateObject创建并管理购物车视图模型
    // 负责处理添加商品到购物车的逻辑
    @StateObject private var cartViewModel = CartViewModel()
    // 使用@State跟踪加载状态
    // 控制UI中加载指示器的显示和隐藏
    @State private var isLoading = false
    
    var body: some View {
       
        // 创建可滚动视图容器
        // 允许内容超出屏幕时滚动查看
        ScrollView {
            // 主要内容垂直布局
            // 设置左对齐和16点间距
            VStack(alignment: .leading, spacing: 16) {
                // 商品图片区域
                // 法语注释："商品图片"
                // Image du produit
                // 使用AsyncImage异步加载网络图片
                // 支持加载中状态显示
                AsyncImage(url: URL(string: product.url)) { image in
                    // 图片加载成功后的处理
                    image
                        .resizable() // 使图片可调整大小
                        .aspectRatio(contentMode: .fit) // 保持图片比例
                } placeholder: {
                    // 图片加载中的占位视图
                    ZStack {
                            // 透明背景确保ZStack有尺寸
                            // 法语注释："确保ZStack有尺寸"
                            Color.clear // Pour s'assurer que le ZStack a une taille
                            // 加载进度指示器
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                // 占据所有可用空间
                                // 法语注释："占据所有可用空间"
                                .frame(maxWidth: .infinity, maxHeight: .infinity) // Prendre toute la place disponible
                        }
                }
                // 设置图片区域宽度占满可用空间
                .frame(maxWidth: .infinity)
                
                // 商品信息区域
                // 法语注释："商品信息"
                // Informations du produit
                // 垂直布局，左对齐，12点间距
                VStack(alignment: .leading, spacing: 12) {
                    // 商品名称
                    // 使用二级标题字体和粗体样式
                    Text(product.name)
                        .font(.title2)
                        .bold()
                    
                    // 商品价格
                    // 格式化为两位小数并添加欧元符号
                    Text("\(String(format: "%.2f", product.price)) €")
                        .font(.title3)
                        .bold()
                    
                    // 商品描述
                    // 使用灰色文本降低视觉权重
                    Text(product.description)
                        .foregroundColor(.gray)

                    // 添加到购物车按钮
                    // 法语注释："添加到购物车按钮"
                    // Bouton Add to cart
                    Button(action: {
                        // 点击时调用购物车视图模型的添加方法
                        cartViewModel.addToCart(product: product)
                    }) {
                        // 根据加载状态显示不同内容
                        if(cartViewModel.isLoading){
                            // 加载中显示进度指示器
                            ProgressView()
                        }else{
                            // 正常状态显示按钮文本
                            // 法语文本："添加到购物车"
                            Text("Ajouter au panier")
                                .foregroundColor(.white) // 白色文本
                                .frame(maxWidth: .infinity) // 宽度占满可用空间
                                .padding() // 添加内边距
                                .background(AppColors.primary) // 使用应用主色调作为背景
                                .cornerRadius(10) // 应用圆角
                        }
                        
                    }
                    .padding(.top) // 顶部添加间距
                    // 添加警告弹窗
                    // 法语注释："用于通知用户的警告"
                    .alert(isPresented: $cartViewModel.showAlert) { // Alerte pour informer l'utilisateur
                        // 创建警告对话框，显示信息和确认按钮
                        Alert(title: Text("Information"), message: Text(cartViewModel.alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
                .padding() // 为商品信息区域添加内边距
            }
        }
        
        // 设置导航栏标题显示模式为内联
        // 使标题更加紧凑
        .navigationBarTitleDisplayMode(.inline)
    }
}
