//
//  File.swift
//  GiorgiPilishvili_Homework25
//
//  Created by GIORGI PILISSHVILI on 24.08.22.
//

import Foundation

extension URL {
    
    func subDirectoriesNames() throws -> [String] {
        guard hasDirectoryPath else { return [] }
        
        var arrayOfPaths = [String]()
        
        let directories = try FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]).filter(\.hasDirectoryPath)
        
        for dir in directories {
            let fileArray = dir.path.components(separatedBy: "/")
            if let name = fileArray.last {
                arrayOfPaths.append(name)
            }
        }
        
        return arrayOfPaths
    }
    
}
