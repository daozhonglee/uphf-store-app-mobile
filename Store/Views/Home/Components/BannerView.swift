//
//  BannerView.swift
//  market
//
//  Created by Don Arias Agokoli on 23/12/2024.
//

// MARK: - 技术要点
// 1. 轮播图实现
// - 使用TabView实现轮播效果
// - 集成自动滚动功能
// - 支持手动滑动切换
//
// 2. 状态管理
// - @StateObject管理Banner数据
// - @State控制当前页面索引
// - 处理加载状态显示
//
// 3. 定时器控制
// - 使用Timer实现自动轮播
// - 处理页面切换动画
// - 优化定时器性能
//
// 4. 界面优化
// - 实现响应式布局
// - 优化加载状态显示
// - 统一的视觉风格

// 导入SwiftUI框架，用于构建用户界面
import SwiftUI

// 轮播图视图组件
// 实现自动滚动的Banner展示功能
struct BannerView: View {
    // 使用@StateObject创建并管理BannerViewModel实例，负责数据获取和处理
    // 确保视图模型的生命周期与视图一致，避免数据丢失
    @StateObject private var viewModel = BannerViewModel()
    // 创建一个定时器发布者，每5秒触发一次，用于自动轮播
    // 使用autoconnect()自动连接发布者，简化定时器管理
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    // 使用@State跟踪当前显示的轮播图索引
    // 当索引变化时，TabView会自动切换到对应的轮播项
    @State private var currentIndex = 0
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
                // 使用TabView实现轮播效果，绑定当前索引
                // 支持手势滑动和自动轮播
                TabView(selection: $currentIndex) {
                    // 遍历所有Banner数据，创建轮播项
                    // 动态生成轮播内容，支持任意数量的Banner
                    ForEach(viewModel.banners) { item in
                        BannerRow(banner: item)
                    }
                }
                // 设置轮播图高度
                // 确保轮播图有固定的高度，避免布局问题
                .frame(height: 180)
                // 应用页面标签视图样式，实现轮播指示器
                // 在底部显示小圆点指示当前页面
                .tabViewStyle(PageTabViewStyle())
                // 接收定时器事件，实现自动轮播
                // 每5秒自动切换到下一个轮播项
                .onReceive(timer) { _ in
                    // 使用动画效果切换到下一个轮播项
                    // 添加平滑过渡效果，提升用户体验
                    withAnimation {
                        // 计算下一个索引，循环显示所有轮播项
                        // 当达到最后一项时，返回到第一项
                        currentIndex = (currentIndex + 1) % viewModel.banners.count
                    }
                }
            }
        }
        // 视图出现时的处理逻辑
        // 用于初始化数据，确保视图显示正确内容
        .onAppear {
            // 注释掉的代码：检查是否是首次出现，如果是则获取Banner数据
            // if !didAppear {
            //     viewModel.fetchBanners()
            //     didAppear = true
            // }
            
        }
    }
}

// 轮播项视图组件
// 定义单个Banner的显示样式和内容
// 负责渲染每个轮播项的具体UI
struct BannerRow: View {
    // Banner数据模型，包含轮播图的信息
    // 由父视图传入，用于显示具体的Banner内容
    let banner: Banner
    
    // 视图主体，定义UI结构和布局
    var body: some View {
        // 使用ZStack叠加布局，创建轮播图卡片效果
        // 实现背景和内容的叠加显示
        ZStack {
            // 设置背景颜色为系统黄色，透明度为0.2
            // 创建柔和的背景效果，不会喧宾夺主
            Color(.systemYellow)
                .opacity(0.2)
            // 使用水平堆栈布局组织轮播图内容
            // 左侧显示文本，右侧显示图片
            HStack {
                // 垂直堆栈布局，左对齐，显示促销文本
                // 包含多行文本信息，从上到下排列
                VStack(alignment: .leading) {
                    // 显示"SALE"文本，颜色为橙色
                    // 使用醒目的颜色吸引用户注意
                    Text("SALE")
                        .foregroundColor(.orange)
                    // 显示折扣信息，使用标题字体和粗体样式
                    // 使用换行符分隔文本，创建多行效果
                    Text("UPTO\n60% OFF")
                        .font(.title)
                        .bold()
                    // 显示商品分类信息
                    // 提供额外的上下文信息
                    Text("School Collections")
                }
                // 添加弹性空间，将内容推向两侧
                // 确保文本和图片分别靠左和靠右显示
                Spacer()
                // 显示轮播图图片
                // 使用本地图片资源"image"
                Image("image")
                    .resizable() // 使图片可调整大小
                    .scaledToFit() // 保持图片比例
                    .frame(width: 150) // 设置图片宽度为150
            }
            // 为HStack添加内边距
            // 确保内容不会紧贴边缘，提升视觉体验
            .padding()
        }
        // 为整个ZStack添加圆角效果
        // 创建现代化的卡片外观
        .cornerRadius(15)
    }
}
