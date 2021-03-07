//
//  ImagePostViewController.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/12/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins

class ImagePostViewController: ShiftableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImageViewHeight(with: 1.0)
        
        filterView.isHidden = true
        
        updateViews()
    }
    
    func updateViews() {
        
        guard let imageData = imageData,
            let image = UIImage(data: imageData) else {
                title = "New Post"
                return
        }
        
        title = post?.title
        
        setImageViewHeight(with: image.ratio)
        
        imageView.image = image
        
        chooseImageButton.setTitle("", for: [])
        
        if let _ = imageView.image {
            filterView.isHidden = false
        }
    }
    
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func createPost(_ sender: Any) {
        
        view.endEditing(true)
        
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.1),
            let title = titleTextField.text, title != "" else {
            presentInformationalAlertController(title: "Uh-oh", message: "Make sure that you add a photo and a caption before posting.")
            return
        }
        
        postController.createPost(with: title, ofType: .image, mediaData: imageData, ratio: imageView.image?.ratio) { (success) in
            guard success else {
                DispatchQueue.main.async {
                    self.presentInformationalAlertController(title: "Error", message: "Unable to create post. Try again.")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
                    return
                }
                
                self.presentImagePickerController()
            }
            
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. Your device's restrictions do not allow access.")
            
        @unknown default:
            print("FatalError")
        }
        presentImagePickerController()
    }
    
    func setImageViewHeight(with aspectRatio: CGFloat) {
        
        imageHeightConstraint.constant = imageView.frame.size.width * aspectRatio
        
        view.layoutSubviews()
    }
    
    var postController: PostController!
    var post: Post?
    var imageData: Data?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    @IBOutlet weak var filterView: UIView!
    
    private let context = CIContext()
    private let exposureFilter = CIFilter.exposureAdjust()
    private let hueFilter = CIFilter.hueAdjust()
    private let bloomFilter = CIFilter.bloom()
    private let gammaFilter = CIFilter.gammaAdjust()
    private let gloomFilter = CIFilter.gloom()
    private let sharpenFilter = CIFilter.unsharpMask()
    
    // Filter Sliders
    
    @IBOutlet weak var exposureSlider: UISlider!
    @IBOutlet weak var hueSlider: UISlider!
    @IBOutlet weak var bloomSlider: UISlider!
    @IBOutlet weak var gammaSlider: UISlider!
    @IBOutlet weak var gloomSlider: UISlider!
    @IBOutlet weak var sharpenSlider: UISlider!
    
    @IBAction func exposureChanged(_ sender: UISlider) {
        updateImage()
    }
    @IBAction func hueChanged(_ sender: UISlider) {
        updateImage()
    }
    @IBAction func bloomChanged(_ sender: UISlider) {
        updateImage()
    }
    @IBAction func gammaChanged(_ sender: UISlider) {
        updateImage()
    }
    @IBAction func gloomChanged(_ sender: UISlider) {
        updateImage()
    }
    @IBAction func sharpenChanged(_ sender: UISlider) {
        updateImage()
    }
    
    var originalImage: UIImage? {
        didSet {
            guard let originalImage = originalImage else {
                scaledImage = nil
                return
            }
            
            var scaledSize = imageView.bounds.size
            let scale = imageView.contentScaleFactor
            scaledSize.width *= scale
            scaledSize.height *= scale

            guard let scaledUIImage = originalImage.imageByScaling(toSize: scaledSize) else {
                scaledImage = nil
                return
            }
            
            scaledImage = CIImage(image: scaledUIImage)
        }
    }

    var scaledImage: CIImage? {
        didSet {
            updateImage()
        }
    }

    private func updateImage() {
        if let scaledImage = scaledImage {
            imageView.image = filterImage(byFiltering: scaledImage)
        } else {
            imageView.image = nil
        }
    }
    
    private func filterImage(byFiltering inputImage: CIImage) -> UIImage? {
        exposureFilter.inputImage = inputImage
        exposureFilter.ev = exposureSlider.value
        
        hueFilter.inputImage = exposureFilter.outputImage
        hueFilter.angle = hueSlider.value
        
        bloomFilter.inputImage = hueFilter.outputImage
        bloomFilter.intensity = bloomSlider.value
        
        gammaFilter.inputImage = bloomFilter.outputImage
        gammaFilter.power = gammaSlider.value
        
        gloomFilter.inputImage = gammaFilter.outputImage
        gloomFilter.intensity = gloomSlider.value
        
        sharpenFilter.inputImage = gloomFilter.outputImage
        sharpenFilter.intensity = sharpenSlider.value
        
        guard let outputImage = sharpenFilter.outputImage else { return nil }
        
        guard let renderedCGImage = context.createCGImage(outputImage, from: inputImage.extent) else { return nil }
        
        return UIImage(cgImage: renderedCGImage)
    }
    
}

extension ImagePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        chooseImageButton.setTitle("", for: [])
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        filterView.isHidden = false
        
        originalImage = image
//        imageView.image = image
        
        setImageViewHeight(with: image.ratio)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
