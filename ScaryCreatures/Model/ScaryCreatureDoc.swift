//
//  AppDelegate.swift
//  ScaryCreatures
//
//  Created by Steve JobsOne on 4/30/19.
//  Copyright © 2019 MobioApp Limited. All rights reserved.
//

import UIKit

class ScaryCreatureDoc: NSObject {
    
    enum Keys: String {
        case dataFile = "Data.plist"
        case thumbImageFile = "thumbImage.png"
        case fullImageFile = "fullImage.png"
    }
    
    private var _data: ScaryCreatureData?
    var data: ScaryCreatureData? {
        get {
            // If the data has already been loaded to memory, just return it.
            if _data != nil { return _data }
            
            // Otherwise, read the contents of the saved file as a type of Data.
            let dataURL = docPath!.appendingPathComponent(Keys.dataFile.rawValue)
            guard let encodedData = try? Data(contentsOf: dataURL) else { return nil }
            
            // Unarchive the contents of the previously encoded ScaryCreatureData object and start using them.
            _data = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(encodedData) as?
            ScaryCreatureData
            
            return _data
        }
        set {
            _data = newValue
        }
    }
    
    private var _thumbImage: UIImage?
    var thumbImage: UIImage? {
        get {
            if _thumbImage != nil { return _thumbImage }
            if docPath == nil { return nil }
            let thumbImageURL = docPath!.appendingPathComponent(Keys.thumbImageFile.rawValue)
            guard let imageData = try? Data(contentsOf: thumbImageURL) else { return nil }
            _thumbImage = UIImage(data: imageData)
            return _thumbImage
        }
        set {
            _thumbImage = newValue
        }
    }
    
    private var _fullImage: UIImage?
    var fullImage: UIImage? {
        get {
            if _fullImage != nil { return _fullImage }
            if docPath == nil { return nil }            
            let fullImageURL = docPath!.appendingPathComponent(Keys.fullImageFile.rawValue)
            guard let imageData = try? Data(contentsOf: fullImageURL) else { return nil }
            _fullImage = UIImage(data: imageData)
            return _fullImage
        }
        set {
            _fullImage = newValue
        }
    }
    
    init(title: String, rating: Float, thumbImage: UIImage?, fullImage: UIImage?) {
        super.init()
        _data = ScaryCreatureData(title: title, rating: rating)
        self.thumbImage = thumbImage
        self.fullImage = fullImage
        saveData()
        saveImages()
    }
    
    var docPath: URL?
    init(docPath: URL) {
        super.init()
        self.docPath = docPath
    }
    
    func createDataPath() throws {
        guard docPath == nil else { return }
        docPath = ScaryCreatureDatabase.nextScaryCreatureDocPath()
        try FileManager.default.createDirectory(at: docPath!, withIntermediateDirectories: true, attributes: nil)
    }
    
    func saveData() {
        // Ensure that there is something in data, otherwise simply return as there is nothing to save.
        guard let data = data else { return }
        
        // In preparation for saving the data inside the created folder.
        do {
            try createDataPath()
        } catch {
            print("Couldn't create save folder. " + error.localizedDescription)
            return
        }
        
        // Build the path of the file where you will write the information.
        let dataURL = docPath!.appendingPathComponent(Keys.dataFile.rawValue)
        
        // Encode data, an instance of ScaryCreatureData, which we previously made conform to NSCoding.
        let encodedData: Data
        if #available(iOS 11.0, *) {
            encodedData = try! NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
        } else {
            encodedData = NSKeyedArchiver.archivedData(withRootObject: data)
        }
        
        // Write the encoded data to the created file path
        do {
            try encodedData.write(to: dataURL)
        } catch {
            print("Couldn't write to save file: " + error.localizedDescription)
        }
    }
    
    func saveImages() {
        // Ensure that there are images stored; otherwise, there’s no point continuing the execution.
        if _fullImage == nil || _thumbImage == nil { return }
        
        // Create the data path if needed.
        do {
            try createDataPath()
        } catch {
            print("Couldn't create save Folder. " + error.localizedDescription)
            return
        }
        
        // Build the paths that will point to each file on the disk.
        let thumbImageURL = docPath!.appendingPathComponent(Keys.thumbImageFile.rawValue)
        let fullImageURL = docPath!.appendingPathComponent(Keys.fullImageFile.rawValue)
        
        // Convert each image to its PNG data representation to be ready for you to write on disk.
        let thumbImageData = _thumbImage!.pngData()
        let fullImageData = _fullImage!.pngData()
        
        // Write the generated data on disk in their respective paths.
        try! thumbImageData!.write(to: thumbImageURL)
        try! fullImageData!.write(to: fullImageURL)
    }
    
    // Deletes the whole folder containing the file with the creature data inside it.
    func deleteDoc() {
        if let docPath = docPath {
            do {
                try FileManager.default.removeItem(at: docPath)
            }catch {
                print("Error Deleting Folder. " + error.localizedDescription)
            }
        }
    }
}
