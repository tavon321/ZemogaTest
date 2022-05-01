# ZemogaTest
Test Zemoga for Vanessa

Architecture
For this project i used MVVM for the presetations layer, and decouple the VC via adapters, the API calls are also decoupled with adapters from the ViewModel.

I did UTs of the most important parts beuase they were 3 similar API calls i only did a couple of UT of that and the viewModels the just for the sake of time, with more time i will ramped up the UT coverage to 100%, and chagned the diffable data source that i used on the views becuase they are no that good with this approach due to the Hashable conformance
