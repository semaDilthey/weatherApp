//
//  WeatherCompositionalLayout.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 17.03.2024.
//

import UIKit

fileprivate enum Constants {
    enum Item {
        static let widthFraction: CGFloat = 0.25
        static let heightFraction: CGFloat = 1
        static let insets : CGFloat = 12
    }
   
    enum Group {
        static let width: CGFloat = 0.9
        static let height: CGFloat = 1.1
    }
}

extension WeatherViewController {

    public func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, _ -> NSCollectionLayoutSection? in
            switch sectionNumber {
                case 0: return self.createSection()
                default: return self.createSection()
            }
        }
    }

    private func createLayoutItem(widthFraction: CGFloat, heightFraction: CGFloat) -> NSCollectionLayoutItem {
         let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(widthFraction), heightDimension: .fractionalHeight(heightFraction))
         let item = NSCollectionLayoutItem(layoutSize: itemSize)
         return item
     }

    private func createGroup(layoutSize: NSCollectionLayoutSize, subitems: [NSCollectionLayoutItem]) -> NSCollectionLayoutGroup {
         return NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: subitems)
         }
       
        
    private func createSection() -> NSCollectionLayoutSection {
        let item = createLayoutItem(widthFraction: Constants.Item.widthFraction, heightFraction: Constants.Item.heightFraction)
        item.contentInsets = NSDirectionalEdgeInsets(top: Constants.Item.insets,
                                                     leading: Constants.Item.insets*1.5,
                                                     bottom: Constants.Item.insets,
                                                     trailing: 0)
        let group = createGroup(layoutSize: .init(widthDimension: .fractionalWidth(Constants.Group.width),
                                                  heightDimension: .fractionalHeight(Constants.Group.height)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return section
    }
    
    private func createHeaderItem(height: CGFloat, kind: String) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(height))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: kind, alignment: .top)
        headerElement.pinToVisibleBounds = true
        return headerElement
    }

}
