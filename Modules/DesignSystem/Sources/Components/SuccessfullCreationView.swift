//
//  ModalView.swift
//  CustomModal
//
//  Created by Theo Sementa on 28/02/2024.
//

import SwiftUI
import ConfettiSwiftUI
import Core
import Navigation

public struct SuccessfullCreationView: View {
    
    // Environment
    @EnvironmentObject private var succesfullModalManager: SuccessfullModalManager
    
    @State private var fakeRouter: Router<AppDestination> = .init()
    
    // Number variables
    @State private var confettiCounter: Int = 0
    
    public init() { }
    
    // MARK: -
    public var body: some View {
        ZStack(alignment: .bottom) {
            if succesfullModalManager.isPresenting {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        succesfullModalManager.isPresenting = false
                    }
                
                VStack(spacing: 36) {
                    CircleWithCheckmark()
                        .confettiCannon(
                            counter: $confettiCounter,
                            num: 50,
                            openingAngle: Angle(degrees: 0),
                            closingAngle: Angle(degrees: 360),
                            radius: 200
                        )
                    
                    VStack(spacing: 16) {
                        Text(succesfullModalManager.title)
                            .font(.Display.small, color: .Text.primary)
                        
                        Text(succesfullModalManager.subtitle)
                            .font(.Body.small, color: .Text.secondary)
                            .multilineTextAlignment(.center)
                    }

                    AnyView(succesfullModalManager.content)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
                .frame(height: 400)
                .frame(maxWidth: .infinity)
                .padding(24)
                .padding(.vertical, 8)
                .background(Color.Background.bg300)
                .clipShape(RoundedRectangle(cornerRadius: UIScreen.main.displayCornerRadius, style: .continuous))
                .transition(.move(edge: .bottom))
                .padding(4)
            }
        }
        .environment(fakeRouter)
        .animation(.smooth, value: succesfullModalManager.isPresenting)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .onChange(of: succesfullModalManager.isPresenting) { _, newValue in
            if newValue {
                confettiCounter += 1
            } else {
                succesfullModalManager.resetData()
            }
        }
    }
}
