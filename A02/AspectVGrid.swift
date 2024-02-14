//
//  AspectVGrid.swift
//  A02
//
//  Created by นายธนภัทร สาระธรรม on 14/2/2567 BE.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    var items: [Item]
    var aspectRatio = 1 as CGFloat
    var spacing: CGFloat = 0 // Add spacing between items
    var content: (Item) -> ItemView
    
    var body: some View {
        GeometryReader { geometry in
            let gridItemSize = gridItemWidthThatFits(
                count: items.count,
                size: geometry.size,
                atAspectRatio: aspectRatio
            )
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: spacing)], spacing: spacing) { // Apply spacing
                ForEach(items) { item in
                    content(item)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }
    
    func gridItemWidthThatFits(count: Int, size: CGSize, atAspectRatio: CGFloat) -> CGFloat {
        let count = CGFloat(count)
        var columCount = 1.0
        repeat {
            let width = size.width / columCount
            let height = width / atAspectRatio
            
            let rowCount = (count / columCount).rounded(.up)
            if rowCount * height < size.height {
                return width
            }
            
            columCount += 1
        } while columCount < count
        
        return min(size.width / count, size.height * aspectRatio)
    }
}

