//
//  RecipeCell.swift
//  iRecipes
//
//  Created by Mihail on 12/19/21.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class RecipeCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadImage(from url: URL) {
        self.mainImage.image = nil
        var task: URLSessionTask!
        
        if let task = task {
            task.cancel()
        }
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteURL as AnyObject) as? UIImage {
            self.mainImage.image = imageFromCache
            return
        }
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                let newImage = UIImage(data: data)
            else {
                print("couldn't load image from url: \(url)")
                return
            }
            
            imageCache.setObject(newImage, forKey: url.absoluteURL as AnyObject)
            DispatchQueue.main.async {
                self.mainImage.image = newImage
            }
        }
        task.resume()
    }
}
