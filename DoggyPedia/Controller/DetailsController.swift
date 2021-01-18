//
//  DetailsController.swift
//  DoggyPedia
//
//  Created by Ujjwal on 17/01/2021.
//

import UIKit

class DetailsController: UIViewController, BreedManagerDelegate
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var temperamentLabel: UILabel!
    
    @IBOutlet weak var lifeSpanBreedLabel: UILabel!
    
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    var breedId : String!
    
    private var breadManager = BreadManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        breadManager.delegate = self
        
        if let imageId = breedId {
            breadManager.fetchImage(imageId: imageId)
        } else {
            self.imageView.image = UIImage(imageLiteralResourceName: "BG")
        }
    }
}

//MARK: - BreedsManager Delegate Methods
extension DetailsController
{
    func didReceiveData(_ breedsArray: [Dog]) {}
    
    func didReceiveDogData(_ dog: DogModel)
    {
        
        let url = URL(string: dog.imageUrl)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.stackView.isHidden = false
                self.nameLabel.text = dog.name
                self.temperamentLabel.text = "I am \(dog.temperament)"
                self.lifeSpanBreedLabel.text = dog.lifeSpan
                self.breedLabel.text = dog.breedGroup.count > 0 ? dog.breedGroup : "NA"
                self.imageView.image = UIImage(data: data!)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

