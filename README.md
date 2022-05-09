## How to run

The app doesn't have any lib, so you can run it right away

## Architecture

For this project I used MVVM for the presentation layer, and decoupled the VC via adapters, the API calls are also decoupled with adapters from the View Model.

## UT's

I did UT's of the most important parts because there were 3 similar API calls, I only did a couple of UT's of that, and the view Models, just for the sake of time.

## TO DOS

With more time I will ramp up the UT coverage to 100%, and change the `Diffable` data source that I used on the views because they aren't that good with this approach, due to the `Hashable` conformance.

I also would've loved to create a class for the local database on Core Data or Realm, basically what I would have done, is create a class Decorator to load from the back end `LocalPostLoadetWithOnlineFallback` that will implement the `PostLoader` protocol and have a conditional to fall back online if there isn't any data stored locally.
