# ZemogaTest
Test Zemoga for Vanessa

The app doesn't have any lib so yoy can run it right away

## Architecture
For this project i used MVVM for the presetations layer, and decouple the VC via adapters, the API calls are also decoupled with adapters from the ViewModel.

## UTs
I did UTs of the most important parts beuase they were 3 similar API calls i only did a couple of UT of that and the viewModels the just for the sake of time.

## TODOS
With more time i will ramped up the UT coverage to 100%, and chagned the diffable data source that i used on the views becuase they are no that good with this approach due to the Hashable conformance

I also would've love to create a class for the local database on CoreData or Realm, basically what i would have done, is create a class Decorator to load from the back end `LocalPostLoadetWithOnlineFallbback` that will implement the `PostLoader` protocol and have a conditional to fall back online if the isn't any data sotre locally
