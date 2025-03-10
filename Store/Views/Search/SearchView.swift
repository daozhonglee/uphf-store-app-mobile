//
//  SearchView.swift
//  Store
//
//  Created by Don Arias Agokoli on 07/02/2025.
//

// MARK: - 技术要点
// 1. 搜索功能实现
// - 使用@StateObject管理搜索状态
// - 实现实时搜索和结果更新
// - 处理空结果和初始状态显示
//
// 2. UI布局设计
// - 使用VStack和List构建搜索结果列表
// - 实现响应式的搜索栏组件
// - 支持异步图片加载和占位符
//
// 3. 状态管理
// - 跟踪搜索查询和结果状态
// - 处理加载和错误状态
// - 维护最近搜索记录
//
// 4. 导航集成
// - 实现到商品详情的导航
// - 处理搜索结果项的点击事件
//
// 5. 用户体验优化
// - 提供清晰的空状态提示
// - 优化搜索结果的展示方式
// - 支持搜索历史记录

// 导入SwiftUI框架
import SwiftUI

// 搜索视图
// 用于实现商品搜索功能的主视图
struct SearchView: View {
    // 使用@StateObject创建产品视图模型实例
    // 管理搜索状态和结果数据
    @StateObject private var viewModel = ProductViewModel()
    
    
    // 视图主体，定义UI结构和布局
    var body: some View {
       
        // 使用垂直堆栈布局组织视图元素
        VStack {
            // 添加搜索栏组件
            // 绑定搜索文本到视图模型的searchQuery属性
            // 设置搜索回调函数
            SearchBar(text: $viewModel.searchQuery, onSearch: {
                // 触发搜索操作
                viewModel.searchProducts()
            }).padding(.horizontal) // 添加水平内边距
            
            // 使用ZStack实现条件渲染
            // 根据搜索结果是否为空显示不同内容
            ZStack {
                // 当搜索结果为空时显示提示信息
                if viewModel.listProductSearch.isEmpty {
                    // 垂直布局显示提示文本
                    VStack {
                        // 添加顶部弹性空间
                        Spacer()
                        
                        // 显示搜索提示或无结果提示
                        // 根据是否有上次搜索记录显示不同文本
                        Text(viewModel.lastSearchQuery.isEmpty ? "Recherchez un produit" : "Aucun résultat pour \(viewModel.lastSearchQuery)")
                            .font(.title3) // 使用三级标题字体
                            .foregroundColor(.gray) // 设置文本颜色为灰色
                            .bold() // 应用粗体样式
                            .multilineTextAlignment(.center) // 多行文本居中对齐
                            .padding() // 添加内边距
                        
                        // 添加底部弹性空间
                        Spacer()
                    }
                } else {
                    // 当有搜索结果时显示列表
                    List {
                        // 遍历搜索结果数组创建列表项
                        ForEach(viewModel.listProductSearch) { item in
                            // 为每个商品创建导航链接
                            // 点击后跳转到商品详情页
                            NavigationLink(destination: ProductDetailView(product: item)){
                                // 商品列表项的水平布局
                                HStack(spacing: 12) {
                                    // 异步加载商品图片
                                    AsyncImage(url: URL(string: item.url)) { image in
                                        // 图片加载成功后的处理
                                        image
                                            .resizable() // 使图片可调整大小
                                            .aspectRatio(contentMode: .fill) // 填充模式保持比例
                                            .frame(width: 80, height: 80) // 设置图片尺寸
                                            .clipShape(RoundedRectangle(cornerRadius: 8)) // 应用圆角裁剪
                                    } placeholder: {
                                        // 图片加载中的占位视图
                                        ProgressView() // 显示加载进度指示器
                                            .frame(width: 80, height: 80) // 设置占位区域大小
                                    }
                                    
                                    // 商品信息的垂直布局
                                    VStack(alignment: .leading, spacing: 4) {
                                        // 显示商品名称
                                        Text(item.name)
                                            .font(.subheadline) // 使用小标题字体
                                            .foregroundColor(.primary) // 使用主要文本颜色
                                            .lineLimit(2) // 限制最多显示2行
                                        
                                        // 显示商品价格
                                        // 格式化为两位小数并添加欧元符号
                                        Text("\(item.price, specifier: "%.2f") €")
                                            .font(.headline) // 使用标题字体
                                            .foregroundColor(.primary) // 使用主要文本颜色
                                    }
                                    .padding(.vertical, 8) // 添加垂直内边距
                                }
                                .padding(.vertical, 4) // 为整个行添加垂直内边距
                            }
                           
                        }
                    }
                    .listStyle(PlainListStyle()) // 应用简洁列表样式
                }
            }
            
        }
        // 视图出现时触发搜索
        // 确保初始状态下显示搜索结果
        .onAppear{
            viewModel.searchProducts()
        }
        // 设置导航栏标题
        // 法语文本："搜索"
        .navigationTitle("Recherche")
    }
    
}
