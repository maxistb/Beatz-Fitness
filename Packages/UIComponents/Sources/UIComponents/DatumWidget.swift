//
//  DatumWidget.swift
//
//
//  Created by Maximillian Stabe on 26.12.23.
//

import Styleguide
import SwiftUI

public struct DatumWidget: View {
    @Environment(\.colorScheme) var colorScheme
    private let dayName: String
    private let dayNumber: Int

    private var isLightMode: Bool {
        return colorScheme == .light
    }

    public init(dayName: String, dayNumber: Int) {
        self.dayName = dayName
        self.dayNumber = dayNumber
    }

    public var body: some View {
        ZStack {
            topRectangle
            dayOfWeekText
            bottomRectangle
            dayOfMonthText
        }
    }

    private var topRectangle: some View {
        Rectangle()
            .cornerRadius(5, corners: [.topLeft, .topRight])
            .frame(width: 40, height: 25)
            .padding(.top, -5)
            .foregroundColor(isLightMode ? .pink : Asset.Color.beatzColor.swiftUIColor)
    }

    private var bottomRectangle: some View {
        Rectangle()
            .cornerRadius(5, corners: [.bottomRight, .bottomLeft])
            .frame(width: 40, height: 25)
            .offset(y: 10)
            .foregroundColor(isLightMode ? Color(red: 241 / 255, green: 240 / 255, blue: 246 / 255) : Color(red: 43 / 255, green: 43 / 255, blue: 45 / 255))
    }

    private var dayOfWeekText: some View {
        Text(dayName)
            .font(.custom("", size: 12))
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .bold()
            .padding(.top, -15)
    }

    private var dayOfMonthText: some View {
        Text("\(dayNumber)")
            .fontWeight(isLightMode ? .medium : .heavy)
            .foregroundColor(isLightMode ? .black : .white)
            .bold()
            .padding(.top, 20)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
