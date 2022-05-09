## How to run
The app doesn't have any lib, so you can run it right away

## Architecture
For this project I used MVVM for the prestation layer, and decouple the VC via adapters, the API calls are also decoupled with adapters from the View Model.

## UT's
I did UT's of the most important parts because they were 3 similar API calls, i only did a couple of UT's of that and the view Models the just for the sake of time.

## TO DOS
With more time I will ramp up the UT coverage to 100%, and changed the `Diffable` data source that I used on the views because they are no that good with this approach due to the `Hashable`conformance.

I also would've love to create a class for the local database on Core Data or Realm, basically what I would have done, is created a class Decorator to load from the back end `LocalPostLoadetWithOnlineFallbback` that will implement the `PostLoader` protocol and have a conditional to fall back online if the isn't any data store locally.
