//
//  CustomLayout.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 07/02/19.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit

class CustomLayout: UICollectionViewLayout {

  let CELL_HEIGHT = 65.0
  let CELL_WIDTH = 75.0
 
  let STATUS_BAR = UIApplication.shared.statusBarFrame.height
  
  // Dictionary to hold the UICollectionViewLayoutAttributes for
  // each cell. The layout attribtues will define the cell's size
  // and position (x, y, and z index). I have found this process
  // to be one of the heavier parts of the layout. I recommend
  // holding onto this data after it has been calculated in either
  // a dictionary or data store of some kind for a smooth performance.
  var cellAttrsDictionary = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
  
  // Defines the size of the area the user can move around in
  // within the collection view.
  var contentSize = CGSize.zero
  
  override var collectionViewContentSize: CGSize {
    return self.contentSize
  }
  
  override func prepare() {
    
    // Cycle through each section of the data source.
    if (collectionView?.numberOfSections)! > 0 {
      for section in 0...collectionView!.numberOfSections-1 {
        
        // Cycle through each item in the section.
        if (collectionView?.numberOfItems(inSection: section))! > 0 {
          for item in 0...collectionView!.numberOfItems(inSection: section)-1 {
            
            // Build the UICollectionVieLayoutAttributes for the cell.
            let cellIndex = IndexPath(item: item, section: section)
            let xPos = Double(item) * CELL_WIDTH
            let yPos = Double(section) * CELL_HEIGHT
            
            let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex as IndexPath)
            cellAttributes.frame = CGRect(x: xPos, y: yPos, width: CELL_WIDTH, height: CELL_HEIGHT)
            
            // Determine zIndex based on cell type.
            if section == 0 && item == 0 {
              cellAttributes.zIndex = 4
            } else if section == 0 {
              cellAttributes.zIndex = 3
            } else if item == 0 {
              cellAttributes.zIndex = 2
            } else {
              cellAttributes.zIndex = 1
            }
            
            // Save the attributes.
            cellAttrsDictionary[cellIndex] = cellAttributes
            
          }
        }
        
      }
    }
    
    // Update content size.
    let contentWidth = Double(collectionView!.numberOfItems(inSection: 0)) * CELL_WIDTH
    let contentHeight = Double(collectionView!.numberOfSections) * CELL_HEIGHT
    self.contentSize = CGSize(width: contentWidth, height: contentHeight)
    
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
    // Create an array to hold all elements found in our current view.
    var attributesInRect = [UICollectionViewLayoutAttributes]()
    
    // Check each element to see if it should be returned.
    for cellAttributes in cellAttrsDictionary.values {
      if rect.intersects(cellAttributes.frame) {
        attributesInRect.append(cellAttributes)
      }
    }
    
    // Return list of elements.
    return attributesInRect
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cellAttrsDictionary[indexPath]
  }

  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return false
  }
}
