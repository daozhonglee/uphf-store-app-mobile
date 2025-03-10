//
//  ProduitByCategorie.swift
//  Store
//
//  Created by Don Arias Agokoli on 31/01/2025.
//

// MARK: - 技术要点
// 1. 商品列表展示
// - 使用LazyVGrid实现网格布局
// - 支持商品列表的响应式布局
// - 优化空状态的显示效果
//
// 2. 状态管理
// - @StateObject管理商品数据
// - 处理加载状态显示
// - 实现商品数据的动态更新
//
// 3. 错误处理
// - 集成错误提示弹窗
// - 处理网络请求异常
// - 优化错误信息展示
//
// 4. 性能优化
// - 使用LazyVGrid实现延迟加载
// - 优化列表滚动性能
// - 合理控制视图更新

import SwiftUI

/// 分类商品视图
/// 根据分类ID显示对应的商品列表
/// 支持网格布局和空状态处理
struct ProductByCategoryView: View {
    // 分类ID，由父视图传入，用于获取特定分类的商品
    let categoryId: String
    // 使用@StateObject创建并管理ProductViewModel实例
    // 负责商品数据的获取和处理
    @StateObject private var viewModel = ProductViewModel()
    
    var body: some View {
        
        ZStack {
            if viewModel.isLoading {
                // 显示加载指示器
                // 当数据正在加载时提供视觉反馈
                ProgressView()
            } else {
                // 使用ScrollView创建可滚动内容区域
                // 支持垂直滚动浏览商品列表
                ScrollView {
                    // 检查商品列表是否为空
                    // 根据结果显示不同的UI
                    if viewModel.productByCategory.isEmpty {
                        // 空状态视图
                        // 当没有商品时显示友好提示
                        VStack {
                            // 添加上方空间，使内容垂直居中
                            Spacer(minLength: 100)
                            
                            // 空状态提示内容
                            // 包含图标和文本信息
                            VStack(spacing: 20) {
                                // 购物车减号图标
                                // 视觉上表示没有商品
                                Image(systemName: "cart.badge.minus")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                
                                // 法语文本："没有可用商品"
                                // 清晰传达当前状态
                                Text("Aucun produit disponible")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                                    .bold()
                                    .multilineTextAlignment(.center)
                            }
                            // 使内容水平居中
                            .frame(maxWidth: .infinity)
                            .padding()
                            
                            // 添加下方空间，保持垂直居中
                            Spacer(minLength: 100)
                        }
                        // 设置最小高度，确保空状态视图填充足够空间
                        // 减去300像素考虑到导航栏和其他UI元素
                        .frame(minHeight: UIScreen.main.bounds.height - 300)
                    } else {
                        // 商品网格视图
                        // 法语注释："商品网格"
                        // Grille de produits
                        // 使用LazyVGrid创建网格布局
                        // 仅在需要时渲染单元格，提高性能
                        LazyVGrid(columns: [
                            // 创建两列灵活布局
                            // 自动适应屏幕宽度
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 20) { // 设置网格项间距为20
                            // 遍历分类商品数组
                            // 为每个商品创建一个ProductRow视图
                            ForEach(viewModel.productByCategory) { item in
                                ProductRow(product: item)
                            }
                        }
                        // 添加水平内边距
                        // 防止内容紧贴屏幕边缘
                        .padding(.horizontal)
                    }
                }
            }
        }
        // 错误提示弹窗
        // 当viewModel.error不为nil时显示
        .alert("Erreur", isPresented: Binding(
            get: { viewModel.error != nil },
            set: { if !$0 { viewModel.error = nil } }
        )) {
            // 显示错误详细信息
            // 如果没有错误描述则显示空字符串
            Text(viewModel.error?.localizedDescription ?? "")
        }
        // 视图出现时加载数据
        // 确保分类商品数据及时显示
        .onAppear {
            // 调用视图模型方法获取指定分类的商品
            viewModel.fetchProductByCategory(categoryId)
        }
    }
}
