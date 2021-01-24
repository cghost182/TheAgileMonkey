# TheAgileMonkeys Test
Thanks for letting me participate on this project, it was the longest test I've worked on, but I really enjoyed developing it.


## Project configuration

This project runs directly, there is no need to install or run dependencies.

1. Xcode 12.3
2. Swift version : 5
3. Deployment target (minimum version) : 13
4. I used VIPER architecture to implement every module, I used a template that already wires all the components, helping me to speed up the implementation focusing on the requirements.


## Why did I use VIPER:

1. It defines very well the responsibilities, this avoids overloading one single file with several functions. 
2. When there is an issue, you know exactly where to look, you don't need to read hundreds of lines of code to find where is the problem, if there is an UI issue, you go to the **View**, if there is a problem with a network call or database, yo go to the **interactor**, if one view is not navigating to the other one or the initialization has missing data you go to the **Router/Wireframe** and if there is an issue with your business logic you go to the **Presenter**.
3. As all components are wired/referenced through protocols, they are easy to mock and also test can be implemented fast and without direct dependencies.
4. components can be reused easily, in a more extended project for example the **songs** view can be presented through many paths ( best artist's songs, top 10 songs of 2020, pop/rock songs ... ) 


## Why did I chose iOS 13 as minimum version:

Although I know that we should support 2 versions backwards ( iOS 12 ), I wanted to play/explore these few things:

1. How to configure and start the project through the **SceneDelegate** file
2. Use the System built-in images 
3. Use properties as ActivityIndicator's style ( medium, large )


## Why did I used singletons:

I used this pattern in three files: **NetworkManager, AudioManager and VideoManager**
I only needed one instance of these three files, I didn't need to instantiate, inherit from them due to they should have one single gate to what they do ( perform network calls, access to the native media functionalities), specially for the media files, this helped me avoiding possible issues when opening different players at the same time or similar behaviors.


## Pluses implemented:

1. I implemented unit tests for just one module, particularly for the Presenter and Interactor because they both manages most of the business logic.
2. I was able to reproduce songs and videos ( please search for "Beyonce" artist for this test )
3. I implemented the like button, you can select - unselect one song, this selection is stored in a simple CoreData model and is loaded and mapped to the songs no matter if you leave the view or even close the app.

## Issues:

Working with the iTunes API wasn't as straightforward as expected, the documentation does not cover all the scenarios and there are not enough examples so I spent a lot of time trying to understand how it worked and also playing with Postman to see the results, thanks to the communication with the team I realized that I couldn't paginate albums and songs and also that not every song had videos.

## Parts that I couldn't start:
* Share Menu
* Cache network requests

