//
//  ViewController.swift
//  DoggyPedia
//
//  Created by Ujjwal on 17/01/2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout
{
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var breadManager    = BreadManager()
    private var dogsArray       = [Dog]()
    private var selectedBreedID : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        breadManager.delegate = self
        
        quoteLabel.text = Constants().quotes.randomElement()
        
        collectionView.register(UINib.init(nibName: "BreedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants().kBreedCollectionViewCellIdentifier)
    }
    
    @IBAction func searchedPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    private func showQuote(_ flag:Bool)
    {
        quoteLabel.isHidden = !flag
        if !quoteLabel.isHidden {
            errorLabel.isHidden = true
        }
        quoteLabel.text = Constants().quotes.randomElement()
    }
    
    private func showError(_ flag: Bool){
        errorLabel.isHidden = !flag
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants().kShowDetailsIdentifier {
            if let detailViewController = segue.destination as? DetailsController {
                detailViewController.breedId = selectedBreedID //Or pass any values
            }
        }
    }
}

//MARK: - TextField Delegate Methods
extension ViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        breadManager.fetchDog(breadName: textField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
}

//MARK: - CollectionView Methods
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().kBreedCollectionViewCellIdentifier, for: indexPath) as! BreedCollectionViewCell
        let doggy = dogsArray[indexPath.row]
        cell.setUpCell(title : doggy.name, image : doggy.reference_image_id)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2-15, height: collectionView.frame.size.width/2-15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        searchTextField.endEditing(true)
        selectedBreedID = dogsArray[indexPath.row].reference_image_id
        performSegue(withIdentifier: Constants().kShowDetailsIdentifier, sender: self)
    }
}

//MARK: - BreedsManager Delegate Methods
extension ViewController: BreedManagerDelegate
{
    func didReceiveDogData(_ dog: DogModel) {
        //
    }
    
    func didReceiveData(_ breedsArray: [Dog]) {
        DispatchQueue.main.async {
            
            self.showQuote(breedsArray.isEmpty && (self.searchTextField.text!.count == 0))
            
            if (breedsArray.isEmpty && (self.searchTextField.text!.count > 0)) {
                self.showError(true)
            } else {
                self.showError(false)
            }
            
            self.dogsArray = breedsArray
            
            self.collectionView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
