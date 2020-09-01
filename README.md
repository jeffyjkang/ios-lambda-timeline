# Lambda Timeline

## Introduction

The goal of this project is to take an existing project called LambdaTimeline and add features to it throughout this sprint. 

1. To begin with you will design the photo filter UI in a new Xcode project using different filters.
2. After you finish implementing your UI for filters, you'll update the Lambda Timeline project with the ability to:
    1. Create posts with images from the user's photo library
    2. Add comments to posts
    3. Filter images you post using your photo filter UI

## Instructions

Please fork and clone this repository, and work from the base project in the repo.

### Part 1 - ~~#NoFilter~~ #Filters

Create a new Xcode project called `ImageFilterEditor` to use as a playground for your Core Image filters and UI setup. *It is ok to create extra Xcode projects to make sure things are working (and it's faster to build and test).*

1. Add at least 5 filters. The [Core Image Filter Reference](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/#//apple_ref/doc/filter/ci/CIFalseColor) lists the filters that you can use. Note that some simply take in an `inputImage` parameter, while others have more parameters such as the `CIMotionBlur`, `CIColorControls`, etc. 
    1. Use at least two or three of filters with a bit more complexity than just the `inputImage`.
2. Create an `ImagePostViewController` that will get a starting image and filter it.
    1. Add whatever UI elements you want to control the filters with the selected image.
    2. For filters that require other parameters use a slider, UITextField, segmented control, or UIPanGestureRecognizer. 
3. Ensure that the controls to add your filters, adjust them, etc. are only available to the user at the appropriate time. 
    1. For example, you shouldn't let the user add a filter if they haven't selected an image yet. And it doesn't make sense to show the adjustment UI if they selected a filter that has no adjustment.
4. You can use a Collection or Table View to select filters with additional detail screens to fine tune amounts of filters (i.e.: Instagram or Apple Photo)

### Part 2: Feature Integration

1. Integrate your `ImagePostViewController` into the Lambda Timeline project.
2. You should be able to create a new post, select a photo, edit the photo, and create an image post. 
3. Be sure that you are able to add comments to posts.

## Go Further

- Clean up the UI of the app, either with the UI you added to support filters. You're welcome to touch up the UI overall if you wish as well.
- Allow for undoing and redoing of filter effects (i.e.: Reset to the identity values, snap to default, etc.)
- Try using a `UIPanGestureRecognizer` on your `UIImageView` to get the (x, y) coordinate using `locationInView:` on the panGesture. (You may need to clamp the value to the bounds of the image).
