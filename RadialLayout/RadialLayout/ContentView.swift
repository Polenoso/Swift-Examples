//
//  ContentView.swift
//  RadialLayout
//
//  Created by Aitor Pagán on 18/10/24.
//

import SwiftUI

enum RadialLayoutAngle {
    case fullCircle
    case trailingCircle
    case leadingCircle
    case custom(degrees: Double, anchor: UnitPoint)
    
    var totalDegrees: Double {
        switch self {
        case .fullCircle:
            360
        case .trailingCircle:
            180
        case .leadingCircle:
            -180
        case .custom(let degrees, _):
            degrees
        }
    }
    
    var anchor: UnitPoint {
        switch self {
        case .fullCircle:
                .center
        case .leadingCircle:
                .trailing
        case .trailingCircle:
                .leading
        case .custom(_, let anchor):
                anchor
        }
    }
}

// Layout radial que acepta cualquier tipo de vista
struct RadialLayout: Layout {
    var angleConfig: RadialLayoutAngle
    var angleOffset: Double // Offset inicial, por defecto será 0

    init(angleConfig: RadialLayoutAngle = .fullCircle, angleOffset: Double = 0) {
        self.angleConfig = angleConfig
        self.angleOffset = angleOffset
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        // Retorna las dimensiones especificadas por el layout
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let radius = min(bounds.size.width, bounds.size.height) / 2
        let totalAngle = angleConfig.totalDegrees
        let angleStep = totalAngle / Double(max(subviews.count - 1, 1)) // Ángulo entre elementos
        
        for (index, subview) in subviews.enumerated() {
            let adjustedIndex = Double(index)
            let angle = Angle.degrees(angleStep * adjustedIndex + angleOffset).radians
            
            let viewSize = subview.sizeThatFits(.unspecified)
            let xPos = cos(angle - .pi / 2) * (radius - viewSize.width / 2)
            let yPos = sin(angle - .pi / 2) * (radius - viewSize.height / 2)
            
            let point = CGPoint(x: bounds.midX + xPos, y: bounds.midY + yPos)
            subview.place(at: point,
                          anchor: angleConfig.anchor,
                          proposal: .unspecified)
        }
    }
}

struct MenuButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    var body: some View {
        Button(title,
               systemImage: icon,
               action: action)
        .padding()
        .background(.clear)
        .border(.black)
        .cornerRadius(8)
        .foregroundStyle(.black)
    }
}

struct ContentView: View {
    @State var showMenu = false
    @State var alertMessage: String?
    
    // Puedes definir el ángulo y offset aquí
    var radialLayoutAngle: RadialLayoutAngle = .leadingCircle
    var angleOffset: Double = 0 // Ángulo inicial para posicionar el primer elemento
    
    var body: some View {
        ZStack {
            Button(action: {
                withAnimation {
                    showMenu.toggle()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(showMenu ? Color.white : Color.black)
                        .frame(width: 100, height: 100)
                    Text(showMenu ? "Cerrar" : "Abrir")
                        .foregroundColor(showMenu ? .black : .white)
                        .font(.system(size: 30))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .padding(10) // Un pequeño padding
                }
            }
            if showMenu {
                    RadialLayout(angleConfig: radialLayoutAngle, angleOffset: angleOffset) {
                        MenuButton(title: "Crear",
                                   icon: "plus") {
                            alertMessage = "Crear"
                        }
                        
                        MenuButton(title: "Buscar",
                                   icon: "magnifyingglass") {
                            alertMessage = "Buscar"
                        }
                        
                        MenuButton(title: "Borrar",
                                   icon: "trash") {
                            alertMessage = "Borrar"
                        }
                    }
                    .frame(width: 300, height: 300)
                    .transition(.scale)
            }
        }
        .alert(alertMessage ?? "",
               isPresented: .constant(alertMessage != nil)) {
            Button("Ok") {
                alertMessage = nil
            }
        }
    }
}

#Preview {
    ContentView()
}
