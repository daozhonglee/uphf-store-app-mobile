//
//  AuthUtils.swift
//  Store
//
//  Created by Don Arias Agokoli on 14/02/2025.
//

// MARK: - 技术要点
// 1. 加密工具类
// - 提供安全的随机数生成功能
// - 实现SHA256哈希算法
// - 支持身份验证和安全通信
//
// 2. 随机数生成
// - 使用SecRandomCopyBytes生成加密安全的随机字节
// - 自定义字符集确保生成的字符串可用性
// - 提供可配置的随机字符串长度
//
// 3. 哈希计算
// - 使用CryptoKit框架实现SHA256哈希
// - 支持字符串输入的哈希计算
// - 提供十六进制格式的哈希输出
//
// 4. 安全性考虑
// - 使用系统级加密API
// - 处理加密操作的错误情况
// - 遵循加密最佳实践

// 导入基础框架，提供核心数据类型和功能
import Foundation
// 导入加密工具包，提供现代加密算法实现
import CryptoKit

// 认证工具结构体，提供静态方法用于认证过程中的加密操作
struct AuthUtils {
    
    // 生成随机nonce字符串，用于防止重放攻击
    // 参数:
    // - length: 生成的随机字符串长度，默认为32个字符
    // 返回: 指定长度的随机字符串
    static func randomNonceString(length: Int = 32) -> String {
        // 确保长度参数有效
        precondition(length > 0)
        // 创建指定长度的字节数组，初始值全为0
        var randomBytes = [UInt8](repeating: 0, count: length)
        // 使用系统安全随机数生成器填充字节数组
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        // 检查随机数生成是否成功
        if errorCode != errSecSuccess {
            // 生成失败则抛出致命错误
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        // 定义字符集，包含数字、大小写字母和特殊字符
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        // 将随机字节映射为字符集中的字符
        let nonce = randomBytes.map { byte in
            // 从字符集中选择一个随机字符，使用模运算确保索引在有效范围内
            charset[Int(byte) % charset.count]
        }
        
        // 将字符数组转换为字符串并返回
        return String(nonce)
    }
    
    // 计算输入字符串的SHA256哈希值
    // 参数:
    // - input: 需要计算哈希的输入字符串
    // 返回: 十六进制格式的SHA256哈希字符串
    static func sha256(_ input: String) -> String {
        // 将输入字符串转换为UTF-8编码的数据
        let inputData = Data(input.utf8)
        // 使用SHA256算法计算数据的哈希值
        let hashedData = SHA256.hash(data: inputData)
        // 将哈希值转换为十六进制字符串
        let hashString = hashedData.compactMap {
            // 将每个字节格式化为两位十六进制数
            String(format: "%02x", $0)
        }.joined()
        
        // 返回完整的哈希字符串
        return hashString
    }
}
