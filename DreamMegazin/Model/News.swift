//
//  News.swift
//  DreamMegazin
//
//  Created by martin on 6/13/24.
//

import Foundation
import UIKit

struct News: Codable , Identifiable {
    let id: UUID
    var title: String
    var date: Date
    var content: String
    var isCompleted: Bool
    var imageName: String
//    var image: String
    
//    private func getImage() -> UIImage?{
//        if let image = UIImage(named: "exampleImage") {
//            if let imageData = image.pngData() {
//                print("PNG로 변환 완료.")
//                return image
//            } else {
//                print("PNG로 변환할 수 없습니다.")
//            }
//        } else {
//            print("이미지를 로드할 수 없습니다.")
//        }
//        return nil
//    }
}
