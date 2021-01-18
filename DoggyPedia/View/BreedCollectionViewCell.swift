//
//  BreedCollectionViewCell.swift
//  DoggyPedia
//
//  Created by Ujjwal on 17/01/2021.
//

import UIKit

class BreedCollectionViewCell: UICollectionViewCell, BreedManagerDelegate {
   
   
    @IBOutlet weak var breedName: UILabel!
    @IBOutlet weak var breedImage: UIImageView!
    @IBOutlet weak var holderView: UIView!
    
    var breadManager = BreadManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        breadManager.delegate = self
    }

    override func prepareForReuse() {
        breedImage.image = nil
    }
    
    func setUpCell(title : String, image : String?) {
        breedName.text = title
        if let imageId = image {
            breadManager.fetchImage(imageId: imageId)
        } else {
            self.breedImage.image = UIImage(imageLiteralResourceName: "BG")
        }
    }
    
    //MARK: - BreedsManager Delegate Methods
    func didReceiveData(_ breedsArray: [Dog]) {}
    
    func didReceiveDogData(_ dog: DogModel) {
        let url = URL(string: dog.imageUrl)

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.breedImage.image = UIImage(data: data!)
            }
        }
    }

    func didFailWithError(error: Error) {
     print(error)
    }
}

