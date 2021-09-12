//
//  File.swift
//  
//
//  Created by Emory Dunn on 9/11/21.
//

import Foundation

public extension Array where Element == Float {
    func pageData(rows: Int = 8, columns: Int = 8) -> [[Element]] {
        let grid = (0..<columns).map { currentPage in
            self[(currentPage * columns)..<(currentPage * columns) + columns].map {
                return $0
            }
        }
        
        return grid
    }
    
    func logPagedData(rows: Int = 8, columns: Int = 8) {
        let grid = (0..<columns).map { currentPage in
            self[(currentPage * columns)..<(currentPage * columns) + columns].map {
                return String(format:"%02d", Int($0))
            }
            .joined(separator: " ")
        }
        
        print(grid.joined(separator: "\n"))
    }
}
