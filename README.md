# DoggyPedia

Encyclopedia Application to show some Information for adorable pet Dogs.

So in this project you will be able to search the Breed of a Dog using API from "https://api.thedogapi.com" and show the results in a collection view.
On click of each item in the collection view open new screen showing the details of the selected Breed.

# Approch  : 
1. When the user launches the DoggyPedia application, they are shwon with the Search Bar at top of the screen and a beautiful "Dog Quote" to start with.
2. As soon as the user starts typing the Breed Name in the search field, search API call will be made with the letters users has typed. (e.g "https://api.thedogapi.com/v1/breeds/search?q=A")
3. The above API call returns the array of breed details objects.
4. For the API call, URLSession is used and for API callbacks, protocol methods are used. 
5. On click of any item from the search results, the Detail screen with details of the selected item is shown.
6. For the UI - storyboard with two controllers is used and a custom collection view cell is used.
7. For navigation and data transfer between controllers segue is used with prepareForSegue method.
8. Error message is shown when there is no data available for the search made.

# Code structure and software design patterns : 
1. ViewController  - controller to handle the search results and popullate the search data into collectionView.
2. DetailsController - controller to show the details when any item is selected from the search results .
3. BreedManager -  struct  to manage the Network call to get the details from the API.
4. BreedData - codable struct to parse the API data.
5. DogModel - model to use for futher customization.
6. BreedsCollectionViewCell - custom cell used for showing the results in the collection view.
7. BreedManagerDelegate - protocol with API callback methods.

# Current Limitations : 
1. Currently the Dogs API does not retrun the Image url property for the searched breed object when the search is made using breed name. So had to make two separate API calls to fetch the Image for each item to get the ImageURL and then download image data for the cell.
2. For few of the entries in the search result, currently a blank screen is shown. as the Dog APIs are not returning any details required to show on the screen (image, breed group, etc) 

# Open Issues and Improvements : 
1. Images in the collection view has flicker issue. - could be fixed by implementing lazy loading of images and caching the images once downloaded.
2. Proper loading indicators could be added to make UI more user friendly.
3. Options to Add to faviorute could be implemented.
4. Code can be optimised futher, if given time.
