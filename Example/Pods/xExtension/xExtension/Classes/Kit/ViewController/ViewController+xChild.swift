//
//  ViewController+xChild.swift
//  xExtension
//
//  Created by Mac on 2021/6/10.
//

import Foundation

extension UIViewController {
    
    // MARK: - 添加子控制器
    /// 添加子控制器
    /// - Parameters:
    ///   - vc: 子控制器
    ///   - container: 容器
    ///   - frame: frame
    public func xAddChild(viewController vc : UIViewController,
                          in container : UIView?,
                          frame : CGRect = .zero)
    {
        guard let superView = container else {
            print("⚠️ 无效的容器")
            return
        }
        self.addChild(vc)
        superView.addSubview(vc.view)
        if frame == .zero {
            vc.view.frame = superView.bounds
        } else {
            vc.view.frame = frame
        }
    }
    
}
