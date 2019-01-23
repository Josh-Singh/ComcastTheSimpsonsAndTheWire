Design pattern used: MVVM
    MVVM allows us to separate model and view by adding another level i.e ViewModel. It makes the project scalable and renders the code loosely coupled thereby making testing easier.
    
API service call made using: URLSession shared dataTask

JSON parsing done using JSONSerialization

3rd party libraries utilised-
    SDWebImage- Allows for loading images asynchronously through image URL that is present in the JSON data obtained from the API call
    
Used collection view to create an emulated table view cell as well as the traditional grid like cell. This was done because collection view has more flexibility in changing cell dimensions through the flow layout delegate

There are 2 targets in this project, one for each of the required applications. Correspondingly the app config files with app specific constants, namely the app name and the API URL, are made available to those targets so that the code shared between them remains unaffected as it is independent of naming conventions.

Split View controller has been used to accommodate iPad compatibility with respect to the view.
        The main view controller shows the list of characters in a list or grid (which can be toggled using a button)
        The detail view controller displays additional information about the character once it is selected in the aforementioned main view controller
        
Search functionality has been added by using UISearchBar and its corresponding delegate protocol methods

Also added Notification Center to detect when the application returns to foreground from a background state and subsequently recalls the API

Constant files include those which allow for setting cell size and spacing as well as one for storing a placeholder image URL.

Errors are handled using an alert controller which is added as an extension to UIViewController. In case of errors being found, the alert controller is triggered and displays it as such to the user.

Progress view is added to the top of the main view controller, it updates itself using notifications from the network handler class which update the progress bar
