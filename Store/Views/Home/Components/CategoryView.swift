//
//  Categorie.swift
//  Store
//
//  Created by Don Arias Agokoli on 17/01/2025.
//

// MARK: - 技术要点
// 1. 分类视图实现
// - 使用ScrollView实现水平滚动的分类列表
// - 集成分类项组件展示不同类别
// - 支持分类导航和选择
//
// 2. 状态管理
// - @StateObject管理分类数据
// - @State控制视图生命周期
// - 处理错误状态显示
//
// 3. 用户交互
// - 实现分类项点击导航
// - 优化分类项布局和间距
// - 提供视觉反馈和提示
//
// 4. 界面优化
// - 统一的视觉风格和配色
// - 响应式布局适配
// - 优化分类图标显示

// 导入SwiftUI框架，用于构建用户界面
import SwiftUI

// 分类视图组件
// 显示水平滚动的商品分类列表
struct CategoryView: View {
    // 使用@StateObject创建并管理CategoryViewModel实例，负责分类数据获取和处理
    // 确保视图模型的生命周期与视图一致，避免数据丢失
    @StateObject private var viewModel = CategoryViewModel()
    // 使用@State跟踪视图是否已经出现，避免重复加载数据
    // 防止在视图多次出现时重复调用网络请求
    @State private var didAppear = false
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
                // 使用垂直堆栈布局组织分类视图元素，设置左对齐
                // 确保标题和内容左侧对齐，提升视觉一致性
                VStack(alignment: .leading) {
                    // 显示"分类"标题文本
                    // 法语文本："分类"
                    Text("Catégories")
                        .font(.title2) // 使用二级标题字体
                        .padding(.horizontal) // 添加水平内边距
                    
                    // 创建水平滚动视图，不显示滚动指示器
                    // 允许用户水平滑动浏览所有分类
                    ScrollView(.horizontal, showsIndicators: false) {
                        // 使用水平堆栈布局组织分类项，设置间距为20
                        // 确保分类项之间有适当的间距，提升可读性
                        HStack(spacing: 20) {
                            // 遍历所有分类数据，创建分类项
                            // 动态生成分类列表，支持任意数量的分类
                            ForEach(viewModel.categorys) { item in
                                CategoryItem(category: item)
                            }
                        }
                        .padding(.horizontal) // 添加水平内边距
                    }
                }
               
            }
        }
        .frame(height: 80) // 设置视图高度为80，减小整体高度
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
            // 注释掉的代码：检查是否是首次出现，如果是则获取分类数据
            // if !didAppear {
            //     viewModel.fetchCategory()
            //     didAppear = true
            // }
            
        }
    }
}

// 分类项视图组件
// 定义单个分类的显示样式和内容
// 负责渲染每个分类项的具体UI
struct CategoryItem: View {
    // 分类数据模型，包含分类的信息
    // 由父视图传入，用于显示具体的分类内容
    var category: Category

    // 视图主体，定义UI结构和布局
    var body: some View {
        // 创建导航链接，点击时跳转到对应分类的商品列表
        // 传递分类ID作为参数，用于加载对应分类的商品
        NavigationLink(destination: ProductByCategoryView(categoryId: category.id)){
            // 使用垂直堆栈布局组织分类项元素，设置间距为8
            // 上方显示图标，下方显示文本
            VStack(spacing: 8) { // 添加控制的间距
                // 创建圆角矩形作为分类图标背景
                // 使用圆角提升视觉美感
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: category.color)) // 使用分类颜色填充
                    .frame(width: 50, height: 50) // 设置固定尺寸
                    .overlay(
                        // 在背景上叠加分类图标
                        // 根据分类名称获取对应的图标
                        Image(getCategoryImage(category.name))
                            .resizable() // 使图片可调整大小
                            .scaledToFit() // 保持图片比例
                            .padding(12) // 添加内边距
                    )
                
                // 显示分类名称
                // 使用分类模型中的名称属性
                Text(category.name)
                    .font(.caption) // 使用说明文字字体
                    .lineLimit(1) // 限制文本为单行
            }
        }
     
    }
}

// 获取分类图标函数
// 根据分类名称返回对应的图标资源名称
// 实现分类名称到图标资源的映射
func getCategoryImage(_ categoryName: String) -> String {
    // 使用switch语句根据分类名称（转换为小写）匹配对应的图标
    // 转换为小写以确保匹配不区分大小写
    switch categoryName.lowercased() {
        case "apparel": // 服装分类
            return "apparel"
        case "school": // 学校用品分类
            return "school"
        case "sports": // 运动用品分类
            return "sport"
        case "electronic": // 电子产品分类
            return "electronic" // 返回电子产品图标资源名称
        case "all": // 全部分类
            return "all" // 返回全部分类图标资源名称
        default: // 默认情况，使用问号图标
            return "questionmark.circle" // 默认图标，当分类不被识别时使用
    }
}
