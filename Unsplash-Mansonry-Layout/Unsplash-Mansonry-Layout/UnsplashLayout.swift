//
//  UnsplashLayout.swift
//  Unsplash-Mansonry-Layout
//
//  Created by Aitor Pagán on 24/10/24.
//

import SwiftUI

struct UnsplashLayout: Layout {
    private var layoutProperties: LayoutProperties
    private var rowsOrColumns: Int
    private var spacing: Double
    private let axis: Axis
    
    init (rowsOrColumns: Int = 3, spacing: Double = 10, axis: Axis = .vertical) {
        self.rowsOrColumns = rowsOrColumns
        self.spacing = spacing
        self.axis = axis
        self.layoutProperties = .init()
        layoutProperties.stackOrientation = axis
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        print("Size that fits \(proposal.replacingUnspecifiedDimensions())")
        let size = proposal.replacingUnspecifiedDimensions()
        let viewFrames = frames(for: subviews, in: size)
        let width = axis == .vertical ?  size.width : (viewFrames.max { $0.maxX < $1.maxX } ?? .zero).maxX
        let height = axis == .horizontal ? size.height : (viewFrames.max { $0.maxY < $1.maxY } ?? .zero).maxY
        print("Size width: \(width), height: \(height)")
        return CGSize(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        let viewFrames = frames(for: subviews, in: bounds.size)
        
        for index in subviews.indices {
            let frame = viewFrames[index]
            let position = CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY)
            subviews[index].place(at: position, proposal: ProposedViewSize(frame.size))
        }
    }
    
    func frames(for subviews: Subviews, in size: CGSize) -> [CGRect] {
        if axis == .vertical {
            let totalSpacing = spacing * Double(rowsOrColumns - 1)
            let columnWidth = (size.width - totalSpacing) / Double(rowsOrColumns)
            let columnWidthWithSpacing = columnWidth + spacing
            let proposedSize = ProposedViewSize(width: columnWidth, height: nil)
            
            var viewFrames = [CGRect]()
            var columnHeights = Array(repeating: 0.0, count: rowsOrColumns)
            for subview in subviews {
                var selectedColumn = 0
                var selectedHeight = Double.greatestFiniteMagnitude
                for (columnIndex, height) in columnHeights.enumerated() {
                    if height < selectedHeight {
                        selectedColumn = columnIndex
                        selectedHeight = height
                    }
                }
                let x = Double(selectedColumn) * columnWidthWithSpacing
                let y = columnHeights[selectedColumn]
                let size = subview.sizeThatFits(proposedSize)
                let frame = CGRect(x: x, y: y, width: size.width, height: size.height)
                columnHeights[selectedColumn] += size.height + spacing
                viewFrames.append(frame)
            }
            
            return viewFrames
        } else {
            let totalSpacing = spacing * Double(rowsOrColumns - 1)
            let rowHeight = (size.height - totalSpacing) / Double(rowsOrColumns)
            let rowHeightWithSpacing = rowHeight + spacing
            let proposedSize = ProposedViewSize(width: nil, height: rowHeight)
            
            var viewFrames = [CGRect]()
            var rowWidths = Array(repeating: 0.0, count: rowsOrColumns)
            for subview in subviews {
                var selectedRow = 0
                var selectedWidth = Double.greatestFiniteMagnitude
                for (rowIndex, width) in rowWidths.enumerated() {
                    if width < selectedWidth {
                        selectedRow = rowIndex
                        selectedWidth = width
                    }
                }
                let y = Double(selectedRow) * rowHeightWithSpacing
                let x = rowWidths[selectedRow]
                let size = subview.sizeThatFits(proposedSize)
                let frame = CGRect(x: x, y: y, width: size.width, height: size.height)
                rowWidths[selectedRow] += size.width + spacing
                viewFrames.append(frame)
            }
            
            return viewFrames
        }
    }
}
