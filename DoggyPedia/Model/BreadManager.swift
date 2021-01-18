//
//  BreadManager.swift
//  DoggyPedia
//
//  Created by Ujjwal on 17/01/2021.
//

import Foundation

protocol BreedManagerDelegate
{
    func didReceiveData(_ breedsArray: [Dog])
    func didReceiveDogData(_ dog: DogModel)
    func didFailWithError(error: Error)
}

struct BreadManager
{
    var delegate: BreedManagerDelegate?
    
    //MARK: - BreedListLoader
    func fetchDog(breadName : String)
    {
        let originalString = "\(Constants().baseURL)breeds/search?q=\(breadName)"
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        performRequest(urlString: urlString!)
    }
    
    func performRequest(urlString : String)
    {
        if let url = URL(string: urlString)
        {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil
                {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let breedsArray = parseData(breedData: safeData) {
                        self.delegate?.didReceiveData(breedsArray)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseData(breedData : Data) -> [Dog]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([Dog].self, from: breedData)
            return decodedData
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    //MARK: - ImageLoader
    func fetchImage(imageId : String)
    {
        if imageId.count > 0
        {
            let urlString = "\(Constants().baseURL)images/\(imageId)"
            imageDownloader(urlString: urlString)
        }
    }
    
    func imageDownloader(urlString : String)
    {
        if let url = URL(string: urlString)?.absoluteURL
        {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil
                {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data
                {
                    if let dogInfo = parseImageData(breedData: safeData) {
                        self.delegate?.didReceiveDogData(dogInfo)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseImageData(breedData: Data) -> DogModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Breeds.self, from: breedData)
            let dog = DogModel(name: decodedData.breeds[0].name, imageUrl: decodedData.url, temperament: decodedData.breeds[0].temperament ?? "", breedGroup: decodedData.breeds[0].breed_group ?? "", lifeSpan: decodedData.breeds[0].life_span ?? "")
            return dog
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
