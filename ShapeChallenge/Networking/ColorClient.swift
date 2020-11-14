//
//  ColorClient.swift
//  ShapeChallenge
//
//  Created by Vũ Tiến on 11/12/20.
//

import Foundation
import Kingfisher
import Moya

class ColorClient {
    let provider: MoyaProvider<ColorTarget>
    
    init(provider: MoyaProvider<ColorTarget> = MoyaProvider<ColorTarget>()) {
        self.provider = provider
    }
    
    func getRandomColor(failedUsingColor: UIColor = UIColor.randomColor(), _ completion: @escaping (UIColor) -> ()) {
        provider.request(.fetchRandomColor) { (result) in
            switch result {
            case .success(let response):
                guard let colors = try? response.map([ColorModel].self), let color = colors.first else {
                    completion(failedUsingColor)
                    break
                }
                completion(color.color)
            case .failure(let error):
                print("Error: \(error)")
                completion(failedUsingColor)
                break
            }
        }
    }
    
    func getRandomPatternColor(failedUsingColor: UIColor = UIColor.randomColor(), _ completion: @escaping (UIColor) -> ()) {
        let fetchPatternImgClosure: (String) -> () = { imageURL in
            guard let url = URL.init(string: imageURL) else {
                return
            }
            let resource = ImageResource(downloadURL: url)
            
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    let patternColor = UIColor(patternImage: value.image)
                    completion(patternColor)
                case .failure(let error):
                    print("Error: \(error)")
                    completion(failedUsingColor)
                }
            }
        }
        
        provider.request(.fetchRandomPattern) { (result) in
            switch result {
            case .success(let response):
                guard let colors = try? response.map([PatternModel].self), let color = colors.first else {
                    completion(failedUsingColor)
                    break
                }
                fetchPatternImgClosure(color.imageUrl)
            case .failure(let error):
                print("Error: \(error)")
                completion(failedUsingColor)
                break
            }
        }
    }
}
