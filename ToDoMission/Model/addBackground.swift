//
//  appBackground.swift
//  ToDoMission
//
//  Created by Konta on 2020/10/02.
//  Copyright © 2020 Masakazu Konno. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addBackground(imageName:String) {
        // スクリーンサイズの取得
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        // スクリーンサイズに合わせてimageViewの配置
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        // imageViewに背景画像を表示
        imageViewBackground.image = UIImage(named: imageName)
        
        // 画像の表示モードを変更
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        
        // subviewをメインビューに追加
        self.addSubview(imageViewBackground)
        
        // subviewを最背面に設置
        self.sendSubviewToBack(imageViewBackground)
    }
}
