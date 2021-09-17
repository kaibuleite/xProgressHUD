//
//  ViewController.swift
//  xProgressHUD
//
//  Created by kaibuleite on 09/17/2021.
//  Copyright (c) 2021 kaibuleite. All rights reserved.
//

import UIKit
import xProgressHUD

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - 显示遮罩动画
    @IBAction func hudBtnClick(_ sender: UIButton)
    {
        xProgressHUD.setBackgroundColor(.xNewRandom(alpha: 0.3))
        guard let title = sender.currentTitle else { return }
        switch title {
        case "系统菊花":
            xProgressHUD.setLoadingflagType(.indicator)
            xProgressHUD.setIndicator(style: .whiteLarge)
        case "GIF动图1":
            let bundle = Bundle.init(for: self.classForCoder)
            var list = [UIImage]()
            for i in 1 ... 12 {
                let name = "loading1-\(i)"
                guard let img = name.xToImage(in: bundle) else { continue }
                list.append(img)
            }
            xProgressHUD.setLoadingflagType(.gif)
            xProgressHUD.setGIFAnimationImages(list)
        case "GIF动图2":
            let bundle = Bundle.init(for: self.classForCoder)
            var list = [UIImage]()
            for i in 1 ... 32 {
                let name = "loading2-\(i)"
                guard let img = name.xToImage(in: bundle) else { continue }
                list.append(img)
            }
            xProgressHUD.setLoadingflagType(.gif)
            xProgressHUD.setGIFAnimationImages(list)
        case "吃豆人":
            xProgressHUD.setLoadingflagType(.anime)
            xProgressHUD.setLoadingAnimeType(.eatBeans)
        case "线段跳跃":
            xProgressHUD.setLoadingflagType(.anime)
            xProgressHUD.setLoadingAnimeType(.lineJump)
        case "魔法1":
            xProgressHUD.setLoadingflagType(.anime)
            xProgressHUD.setLoadingAnimeType(.magic1)
        case "魔法2":
            xProgressHUD.setLoadingflagType(.anime)
            xProgressHUD.setLoadingAnimeType(.magic2)
        default:
            break
        }
        xProgressHUD.display(msg: "", delay: 3)
    }

}

