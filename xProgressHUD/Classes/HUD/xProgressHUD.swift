//
//  xProgressHUD.swift
//  xProgressHUD
//
//  Created by Mac on 2021/9/17.
//

import UIKit
import xDefine
import xExtension

public class xProgressHUD: UIView {
    
    // MARK: - IBOutlet Property
    /// 菊花控件
    @IBOutlet weak var aiView: UIActivityIndicatorView!
    /// gif容器
    @IBOutlet weak var gifIcon: UIImageView!
    /// 动画容器
    @IBOutlet weak var animeContainer: UIView!
    /// 提示内容
    @IBOutlet weak var msgLbl: UILabel!
    
    // MARK: - Public Property
    /// 配置
    public var config = xHUDConfig()
    /// 显示次数
    public var displayCount = 0
    /// 最大显示时长(默认60s)
    public var maxDisplayDuration = TimeInterval(60)
    
    // MARK: - Private Property
    /// 承载动画的layer
    let animeLayer = CAShapeLayer()
    /// 是否正在显示
    var isDisplaying = false
    
    // MARK: - 内存释放
    deinit {
        print("🌼 HUD")
    }
    
    // MARK: - Public Override Func
    // 单例
    public static var shared : xProgressHUD = {
        let bundle = Bundle.init(for: xProgressHUD.classForCoder())
        let list = bundle.loadNibNamed("xProgressHUD", owner: nil, options: nil)
        let hud = list?.first as! xProgressHUD
        return hud
    }()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // 基本配置
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.animeContainer.backgroundColor = .clear
        self.animeLayer.backgroundColor = UIColor.clear.cgColor
        self.animeLayer.fillColor = UIColor.clear.cgColor
        self.animeContainer.layer.addSublayer(self.animeLayer)
    }
    
    // MARK: - Public Func
    /// 恢复默认样式
    public static func recoverDefaultStyle()
    {
        shared.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        shared.config.recoverDefaultStyle()
    }
    /// 设置随机样式
    public static func setRandomStyle()
    {
        let config = shared.config
        config.flagType = arc4random() % 2 == 0 ? .indicator : .anime
        let arr : [xHUDLoadingAnimeType] = [.lineJump, .eatBeans, .magic1, .magic2]
        let idx = arc4random() % 4
        config.animeType = arr[Int(idx)]
    }
    /// 设置最大显示时长
    public static func setMaxDisplayDuration(_ duration : TimeInterval)
    {
        shared.maxDisplayDuration = duration
    }
    /// 设置背景颜色
    public static func setBackgroundColor(_ color : UIColor)
    {
        shared.backgroundColor = color
    }
    /// 设置系统菊花样式
    public static func setIndicator(style : UIActivityIndicatorView.Style)
    {
        shared.aiView.style = style
    }
    /// 设置中间提示类型
    public static func setLoadingflagType(_ style : xHUDLoadingFlagType)
    {
        shared.config.flagType = style
    }
    /// 设置中间动画类型
    public static func setLoadingAnimeType(_ type : xHUDLoadingAnimeType)
    {
        shared.config.animeType = type
    }
    /// 设置GIF动画资源
    public static func setGIFAnimationImages(_ list : [UIImage]?)
    {
        // 图片需要压缩
        var scaleList = [UIImage]()
        let scaleSize = shared.gifIcon.bounds.size
        for img in list ?? [] {
            guard let scaleImg = img.xScaleTo(size: scaleSize) else { continue }
            scaleList.append(scaleImg)
        }
        shared.gifIcon.animationImages = scaleList
    }
    /// 更新遮罩提示
    public static func setMessage(_ msg : String)
    {
        shared.msgLbl.text = msg
    }
    
    /// 显示遮罩
    /// - Parameters:
    ///   - style: 遮罩样式
    ///   - msg: 提示内容
    public static func display(msg : String = "",
                               delay : TimeInterval = 0)
    {
        guard !shared.isDisplaying else { return }    // 保证只显示1个遮罩
        guard let window = xKeyWindow else { return }
        shared.displayCount += 1
        shared.isDisplaying = true
        // 添加UI
        shared.alpha = 0
        shared.msgLbl.text = msg
        shared.msgLbl.isHidden = (msg.count == 0)
        shared.updateHUDStyle()
        shared.startAnimation()
        shared.frame = window.bounds
        window.addSubview(shared)
        // 展示UI
        UIView.animate(withDuration: 0.25, animations: {
            shared.alpha = 1
        })
        // 延迟隐藏
        var duration = delay
        if delay == 0 {
            duration = self.shared.maxDisplayDuration
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: {
            // shared.displayCount = 1
            self.dismiss()
        })
    }
    /// 隐藏遮罩
    public static func dismiss()
    {
        guard shared.isDisplaying else { return }
        UIView.animate(withDuration: 0.25, animations: {
            shared.alpha = 0
            
        }, completion: {
            (finish) in
            shared.isDisplaying = false
            shared.stopAnimation()
            shared.removeFromSuperview()
        })
    }
    
    // MARK: - Private Func
    /// 更新遮罩样式
    private func updateHUDStyle()
    {
        // 加载控件样式
        let arr = [self.aiView, self.gifIcon, self.animeContainer]
        var idx = 0
        switch config.flagType {
        case .indicator:    idx = 0
        case .gif:          idx = 1
        case .anime:        idx = 2
        }
        for (i, obj) in arr.enumerated() {
            let spv = obj?.superview ?? obj
            spv?.isHidden = i != idx
        }
    }
    /// 开始动画
    private func startAnimation()
    {
        let config = self.config
        switch config.flagType {
        case .indicator:    // 系统菊花
            self.aiView.startAnimating()
        case .gif:          // 自定义gif
            self.gifIcon.startAnimating()
        case .anime:        // CA动画
            // 清空旧动画
            self.stopAnimation()
            // 添加新动画
            switch config.animeType {
            case .lineJump: // 线条跳动
                self.addLineJumpAnime()
            case .eatBeans: // 吃豆人
                self.addEatBeansAnime()
            case .magic1, .magic2:  // 六芒星
                self.addMagicAnime()
            }
        }
    }
    /// 结束动画
    private func stopAnimation()
    {
        let config = self.config
        switch config.flagType {
        case .indicator:
            self.aiView.stopAnimating()
        case .gif:
            self.gifIcon.stopAnimating()
        case .anime:
            for layer in self.animeLayer.sublayers ?? [] {
                layer.removeAllAnimations()
                layer.removeFromSuperlayer()
            }
        }
    }
}
