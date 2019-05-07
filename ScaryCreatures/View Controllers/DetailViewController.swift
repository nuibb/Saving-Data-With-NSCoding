//
//  AppDelegate.swift
//  ScaryCreatures
//
//  Created by Steve JobsOne on 4/30/19.
//  Copyright © 2019 MobioApp Limited. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  @IBOutlet weak var rateView: RateView!
  @IBOutlet weak var detailDescriptionLabel: UILabel!
  @IBOutlet weak var titleField: UITextField!
  @IBOutlet weak var imageView: UIImageView!
  
  private var picker: UIImagePickerController!
  
  var detailItem: ScaryCreatureDoc? {
    didSet {
      if isViewLoaded {
        configureView()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    picker = UIImagePickerController()
    configurePicker()
    configureView()
  }
  
  func configurePicker() {
    picker.delegate = self
    picker.sourceType = .photoLibrary
    picker.allowsEditing = false
  }
  
  func configureView() {
    rateView.notSelectedImage = #imageLiteral(resourceName: "shockedface2_empty")
    rateView.fullSelectedImage = #imageLiteral(resourceName: "shockedface2_full")
    rateView.editable = true
    rateView.maxRating = 5
    rateView.delegate = self
    
    if let detailItem = detailItem {
      titleField.text = detailItem.data!.title
      rateView.rating = detailItem.data!.rating
      imageView.image = detailItem.fullImage
      detailDescriptionLabel.isHidden = imageView.image != nil
    }
  }
  
  @IBAction func addPictureTapped(_ sender: UIButton) {
    present(picker, animated: true, completion: nil)
  }
  
  @IBAction func titleFieldTextChanged(_ sender: UITextField) {
    detailItem?.data?.title = sender.text!
    detailItem?.saveData()
  }
}

// MARK: - RateViewDelegate

extension DetailViewController: RateViewDelegate {
  func rateViewRatingDidChange(rateView: RateView, newRating: Float) {
    detailItem?.data?.rating = newRating
    detailItem?.saveData()
  }
}

// MARK: - UIImagePickerControllerDelegate

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    let fullImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    let concurrentQueue = DispatchQueue(label: "ResizingQueue", attributes: .concurrent)
    
    concurrentQueue.async {
      let thumbImage = fullImage.resized(newSize: CGSize(width: 107, height: 107))
      
      DispatchQueue.main.async {
        self.detailItem?.fullImage = fullImage
        self.detailItem?.thumbImage = thumbImage
        self.imageView.image = fullImage
        self.detailItem?.saveImages()
      }
    }
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - UITextFieldDelegate

extension DetailViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
