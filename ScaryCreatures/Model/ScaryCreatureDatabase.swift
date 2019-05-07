//
//  ScaryCreatureDatabase.swift
//  ScaryCreatures
//
//  Created by Steve JobsOne on 4/30/19.
//  Copyright © 2019 MobioApp Limited. All rights reserved.
//

import Foundation

class ScaryCreatureDatabase: NSObject {
    
    static let privateDocsDir: URL = {
        // Get the app’s Documents folder, which is a standard folder that all apps have
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // Build the path pointing to the database folder that has everything stored inside.
        let documentsDirectoryURL = paths.first!.appendingPathComponent("PrivateDocuments")
        
        // Create the folder if it isn’t there and return the path.
        do {
            try FileManager.default.createDirectory(at: documentsDirectoryURL,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch {
            print("Couldn't create directory")
        }
        
        print(documentsDirectoryURL.absoluteString)

        return documentsDirectoryURL
    }()
    
    class func loadScaryCreatureDocs() -> [ScaryCreatureDoc] {
        // Get all the contents of the database folder.
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: privateDocsDir,
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles) else { return [] }
        
        return files
            .filter { $0.pathExtension == "scarycreature" } // Filter the list to only include items that end with .scarycreature.
            .map { ScaryCreatureDoc(docPath: $0) } // Load the database from the filtered list and return it.
    }
    
    class func nextScaryCreatureDocPath() -> URL? {
        // 1
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: privateDocsDir,
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles) else { return nil }
        
        var maxNumber = 0
        // 2
        files.forEach {
            if $0.pathExtension == "scarycreature" {
                let fileName = $0.deletingPathExtension().lastPathComponent
                maxNumber = max(maxNumber, Int(fileName) ?? 0)
            }
        }
        // 3
        return privateDocsDir.appendingPathComponent(
            "\(maxNumber + 1).scarycreature",
            isDirectory: true)
    }
}
