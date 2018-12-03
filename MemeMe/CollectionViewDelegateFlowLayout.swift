//
//  CollectionViewDelegateFlowLayout.swift
//  MemeMe
//
//  Created by Felipe Ribeiro on 03/12/18.
//  Copyright © 2018 Felipe Ribeiro. All rights reserved.
//

import Foundation
import UIKit

extension MemeCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Use the same aspect ratio from the image in the table view cell.
        let screenWidth: CGFloat = view.frame.size.width
        let aspectRatio: CGFloat = 130.0 / 190.0
        
        let width = UIDevice.current.orientation.isPortrait ? screenWidth / 3.0 : screenWidth / 5.0
        
        return CGSize(width: width, height: width / aspectRatio)
    }
}
