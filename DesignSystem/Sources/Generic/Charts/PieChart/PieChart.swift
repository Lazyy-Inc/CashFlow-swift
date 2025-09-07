//
//  TPieChart.swift
//  CustomPieChart
//
//  Created by Theo Sementa on 10/08/2024.
//

import Foundation
import SwiftUI
import Core
import Models
import Stores

public struct PieChart: View {
  
  // Builder
  var month: Date
  var slices: [PieSliceData]
  
  // Configuration
  var config: Configuration
  
  // Other
  @State private var activeSlice: PieSliceData?
  
  // Computed
  var values: [Double] {
    return PieChart.adjustValues(slices.map(\.value))
  }
  var colors: [Color] {
    return slices.map(\.color)
  }
  var icons: [String] {
    return slices.compactMap(\.icon)
  }
  var percentage: Double {
    if let activeSlice {
      return (activeSlice.value / slices.map(\.value).reduce(0, +)) * 100
    } else { return 0 }
  }
  
  public init(
    month: Date,
    slices: [PieSliceData],
    config: Configuration
  ) {
    self.month = month
    self.slices = slices
    self.config = config
  }
  
  // MARK: -
  public var body: some View {
    GeometryReader { geometry in
      let adjustedValues =  PieChart.adjustValues(values)
      let total = adjustedValues.reduce(0, +)
      let angles = adjustedValues.reduce(into: [Angle(degrees: 0)]) { angles, value in
        angles.append(angles.last! + Angle(degrees: 360 * (value / total)))
      }
      
      let shorterSideLength = min(geometry.size.width, geometry.size.height)
      let radius = shorterSideLength * config.pieSizeRatio / 2
      let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
      let lineWidth = shorterSideLength * config.pieSizeRatio * (values.count > 1 ? config.lineWidthMultiplier : 0)
      
      ZStack {
        ForEach(0..<values.count, id: \.self) { index in
          PieSlice(startAngle: angles[index], endAngle: angles[index + 1], cornerRadius: 8)
            .fill(colors[index % colors.count])
            .scaleEffect(self.activeSlice == slices[index] ? 1.05 : 1)
            .animation(.spring, value: activeSlice)
            .animation(.smooth, value: slices)
            .overlay(
              PieSlice(startAngle: angles[index], endAngle: angles[index + 1])
                .stroke(config.backgroundColor, lineWidth: lineWidth)
                .scaleEffect(self.activeSlice == slices[index] ? 1.05 : 1)
            )
            .onTapGesture {
              if config.isInteractive {
                if let activeSlice, activeSlice == slices[index] {
                  withAnimation { self.activeSlice = nil }
                } else {
                  withAnimation { self.activeSlice = slices[index] }
                }
              }
            }
          
          if index < icons.count {
            let midAngle = (angles[index] + angles[index + 1]) / 2
            let iconRadius = radius * (1.2 + config.holeSizeRatio) / 2
            let iconPosition = CGPoint(
              x: center.x + cos(midAngle.radians - .pi / 2) * iconRadius,
              y: center.y + sin(midAngle.radians - .pi / 2) * iconRadius
            )
            
            IconSVG(icon: icons[index], value: .standard)
              .foregroundStyle(Color.white)
              .position(iconPosition)
          }
        }
        
        if config.holeSizeRatio > 0 {
          Circle()
            .fill(config.backgroundColor)
            .frame(width: radius * 2 * config.holeSizeRatio, height: radius * 2 * config.holeSizeRatio)
            .overlay {
              VStack(spacing: 8) {
                Group {
                  if let activeSlice {
                    Text(activeSlice.title)
                  } else {
                    Text(month.formatted(Date.FormatStyle().month(.wide).year()).capitalized)
                  }
                }
                .font(Font.semiBoldSmall())
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundStyle(Color.gray)
                .isDisplayed(config.isInteractive)
                
                Text((self.activeSlice == nil ? values.reduce(0, +).toCurrency() : activeSlice?.value.toCurrency()) ?? "")
                  .foregroundStyle(Color.text)
                  .font(.semiBoldCustom(size: 20))
                
                if activeSlice != nil {
                  Text(percentage.toString() + "%")
                    .foregroundStyle(Color.text)
                    .font(Font.mediumText16())
                }
              }
            }
        }
      }
      .frame(width: geometry.size.width, height: geometry.size.height)
    }
    .aspectRatio(1, contentMode: .fit)
    .frame(height: config.height)
  } // End body
} // End struct
