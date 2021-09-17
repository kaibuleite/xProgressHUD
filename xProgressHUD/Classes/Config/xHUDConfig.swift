//
//  xHUDConfig.swift
//  xHUDConfig
//
//  Created by Mac on 2021/9/17.
//

import UIKit 

public class xHUDConfig: NSObject {

    // MARK: - Public Property
    /// 标识样式
    public var flagType = xHUDLoadingFlagType.indicator
    /// 背景样式
    public var animeType = xHUDLoadingAnimeType.lineJump
    
    /// 恢复默认设置
    public  func recoverDefaultStyle()
    {
        self.flagType = .indicator
        self.animeType = .lineJump
    }
    
}
