//
//  PayWithLinkViewController-SignUpViewController.swift
//  StripePaymentSheet
//
//  Created by Ramon Torres on 11/2/21.
//  Copyright © 2021 Stripe, Inc. All rights reserved.
//

// MARK: - 技术要点
// 1. Link支付注册流程
// - 实现用户注册界面
// - 处理表单验证和提交
// - 管理注册状态和错误处理
//
// 2. UI组件管理
// - 使用自定义UI组件
// - 实现响应式布局
// - 支持动态字体大小
//
// 3. 表单验证
// - 实时验证用户输入
// - 显示错误提示
// - 管理提交按钮状态

import SafariServices
import UIKit

@_spi(STP) import StripeCore
@_exported @_spi(STP) import StripePayments
@_spi(STP) import StripeUICore

extension PayWithLinkViewController {

    /// For internal SDK use only
    @objc(STP_Internal_PayWithLinkSignUpViewController)
    final class SignUpViewController: BaseViewController {

        // MARK: - 视图模型
        private let viewModel: SignUpViewModel

        // MARK: - UI组件
        
        // 标题标签
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.font = LinkUI.font(forTextStyle: .title)
            label.textColor = .linkPrimaryText
            label.adjustsFontForContentSizeCategory = true
            label.numberOfLines = 0
            label.textAlignment = .center
            label.text = STPLocalizedString(
                "Fast, secure, 1⁠-⁠click checkout",
                "Title for the Link signup screen"
            )
            return label
        }()

        // 副标题标签
        private lazy var subtitleLabel: UILabel = {
            let label = UILabel()
            label.font = LinkUI.font(forTextStyle: .body)
            label.textColor = .linkSecondaryText
            label.adjustsFontForContentSizeCategory = true
            label.numberOfLines = 0
            label.textAlignment = .center
            label.text = String.Localized.save_your_payment_information_with_link
            return label
        }()

        // 邮箱输入组件
        private lazy var emailElement = LinkEmailElement(defaultValue: viewModel.emailAddress, showLogo: true, theme: LinkUI.appearance.asElementsTheme)

        // 电话号码输入组件
        private lazy var phoneNumberElement = PhoneNumberElement(
            defaultCountryCode: context.configuration.defaultBillingDetails.address.country,
            defaultPhoneNumber: context.configuration.defaultBillingDetails.phone,
            theme: LinkUI.appearance.asElementsTheme
        )

        // 姓名输入组件
        private lazy var nameElement = TextFieldElement(
            configuration: TextFieldElement.NameConfiguration(
                type: .full,
                defaultValue: viewModel.legalName
            ),
            theme: LinkUI.appearance.asElementsTheme
        )

        // 表单分组组件
        private lazy var emailSection = SectionElement(elements: [emailElement], theme: LinkUI.appearance.asElementsTheme)
        private lazy var phoneNumberSection = SectionElement(elements: [phoneNumberElement], theme: LinkUI.appearance.asElementsTheme)
        private lazy var nameSection = SectionElement(elements: [nameElement], theme: LinkUI.appearance.asElementsTheme)

        // 法律条款视图
        private lazy var legalTermsView: LinkLegalTermsView = {
            let legalTermsView = LinkLegalTermsView(textAlignment: .center, isStandalone: true)
            legalTermsView.tintColor = .linkBrandDark
            legalTermsView.delegate = self
            return legalTermsView
        }()

        // 错误提示标签
        private lazy var errorLabel: UILabel = {
            let label = ElementsUI.makeErrorLabel(theme: LinkUI.appearance.asElementsTheme)
            label.isHidden = true
            return label
        }()

        // 注册按钮
        private lazy var signUpButton: Button = {
            let button = Button(
                configuration: .linkPrimary(),
                title: STPLocalizedString(
                    "Agree and continue",
                    "Title for a button that when tapped creates a Link account for the user."
                )
            )
            button.addTarget(self, action: #selector(didTapSignUpButton(_:)), for: .touchUpInside)
            button.adjustsFontForContentSizeCategory = true
            button.isEnabled = false
            return button
        }()

        // 主堆栈视图
        private lazy var stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [
                titleLabel,
                subtitleLabel,
                emailSection.view,
                phoneNumberSection.view,
                nameSection.view,
                legalTermsView,
                errorLabel,
                signUpButton,
            ])

            stackView.axis = .vertical
            stackView.spacing = LinkUI.contentSpacing
            stackView.setCustomSpacing(LinkUI.smallContentSpacing, after: titleLabel)
            stackView.setCustomSpacing(LinkUI.extraLargeContentSpacing, after: subtitleLabel)
            stackView.setCustomSpacing(LinkUI.extraLargeContentSpacing, after: legalTermsView)
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.directionalLayoutMargins = LinkUI.contentMargins

            return stackView
        }()

        // MARK: - 初始化方法
        init(
            linkAccount: PaymentSheetLinkAccount?,
            context: Context
        ) {
            self.viewModel = SignUpViewModel(
                configuration: context.configuration,
                accountService: LinkAccountService(apiClient: context.configuration.apiClient, elementsSession: context.elementsSession),
                linkAccount: linkAccount,
                country: context.elementsSession.countryCode
            )
            super.init(context: context)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - 生命周期方法
        override func viewDidLoad() {
            super.viewDidLoad()

            let scrollView = LinkKeyboardAvoidingScrollView(contentView: stackView)
            #if !os(visionOS)
            scrollView.keyboardDismissMode = .interactive
            #endif

            contentView.addAndPinSubview(scrollView)

            setupBindings()
            updateUI()
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            STPAnalyticsClient.sharedClient.logLinkSignupFlowPresented()

            // 如果邮箱字段为空，自动选中它
            if emailElement.emailAddressString?.isEmpty ?? false {
                emailElement.beginEditing()
            }
        }

        // MARK: - 私有方法
        
        // 设置数据绑定
        private func setupBindings() {
            // 将电话号码字段的值同步到视图模型
            viewModel.phoneNumber = phoneNumberElement.phoneNumber

            viewModel.delegate = self
            emailElement.delegate = self
            phoneNumberElement.delegate = self
            nameElement.delegate = self
        }

        // 更新UI状态
        private func updateUI(animated: Bool = false) {
            if viewModel.isLookingUpLinkAccount {
                emailElement.startAnimating()
            } else {
                emailElement.stopAnimating()
            }

            // 电话号码字段
            stackView.toggleArrangedSubview(
                phoneNumberSection.view,
                shouldShow: viewModel.shouldShowPhoneNumberField,
                animated: animated
            )

            // 姓名字段
            stackView.toggleArrangedSubview(
                nameSection.view,
                shouldShow: viewModel.shouldShowNameField,
                animated: animated
            )

            // 法律条款
            stackView.toggleArrangedSubview(
                legalTermsView,
                shouldShow: viewModel.shouldShowLegalTerms,
                animated: animated
            )
        }
    }
}

extension PayWithLinkViewController.SignUpViewController: PayWithLinkSignUpViewModelDelegate {
    func viewModelDidEncounterAttestationError(_ viewModel: PayWithLinkViewController.SignUpViewModel) {
        self.coordinator?.bailToWebFlow()
    }

    func viewModelDidChange(_ viewModel: PayWithLinkViewController.SignUpViewModel) {
        updateUI(animated: true)
    }

    func viewModel(
        _ viewModel: PayWithLinkViewController.SignUpViewModel,
        didLookupAccount linkAccount: PaymentSheetLinkAccount?
    ) {
        if let linkAccount = linkAccount {
            coordinator?.accountUpdated(linkAccount)

            if !linkAccount.isRegistered {
                STPAnalyticsClient.sharedClient.logLinkSignupStart()
            }
        }
    }

}

extension PayWithLinkViewController.SignUpViewController: ElementDelegate {

    func didUpdate(element: Element) {
        switch emailElement.validationState {
        case .valid:
            viewModel.emailAddress = emailElement.emailAddressString
        case .invalid:
            viewModel.emailAddress = nil
        }

        viewModel.phoneNumber = phoneNumberElement.phoneNumber

        switch nameElement.validationState {
        case .valid:
            viewModel.legalName = nameElement.text
        case .invalid:
            viewModel.legalName = nil
        }
    }

    func continueToNextField(element: Element) {
        // No-op
    }

}

extension PayWithLinkViewController.SignUpViewController: UITextViewDelegate {

#if !os(visionOS)
    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        if interaction == .invokeDefaultAction {
            let safariVC = SFSafariViewController(url: URL)
            present(safariVC, animated: true)
        }

        return false
    }
#endif

}

extension PayWithLinkViewController.SignUpViewController: LinkLegalTermsViewDelegate {

    func legalTermsView(_ legalTermsView: LinkLegalTermsView, didTapOnLinkWithURL url: URL) -> Bool {
        let safariVC = SFSafariViewController(url: url)
        #if !os(visionOS)
        safariVC.dismissButtonStyle = .close
        #endif
        safariVC.modalPresentationStyle = .overFullScreen
        present(safariVC, animated: true)
        return true
    }

}
