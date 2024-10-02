import SwiftUI

struct ContentView: View {
    @Binding var selectedColor: Color
    private let circleSize: CGSize = .init(width: 200, height: 200)
    @State private var point: CGPoint = .zero
    @State private var saturation: CGFloat = 1.0
    @State private var brightness: CGFloat = 1.0
    @State private var hue: CGFloat = 0.0 // Para almacenar el tono del gradiente

    private static var colors: [Color] = {
        [
            Color.red,
            Color.yellow,
            Color.green,
            Color.cyan,
            Color.blue,
            Color.purple,
            Color.red // Cierra el ciclo de colores
        ]
    }()
    
    var body: some View {
        VStack(spacing: 24) {
            // Círculo que muestra el color seleccionado
            Circle()
                .fill(selectedColor)
                .frame(width: 100, height: 100, alignment: .center)
                .overlay(Circle().stroke(Color.white, lineWidth: 2))

            // Círculo con gradiente en anillo
            Circle()
                .fill(Color.clear)
                .strokeBorder(
                    AngularGradient(colors: Self.colors,
                                    center: .center, startAngle: .zero, endAngle: .degrees(360)),
                    lineWidth: 50
                )
                .overlay {
                    // Selector de color (punto blanco)
                    Circle()
                        .fill(.white)
                        .frame(width: 12, height: 12)
                        .offset(getOffset(for: point, in: circleSize))
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let newPoint = value.location
                            point = calculatePointOnRing(from: newPoint, in: circleSize)
                            hue = getHue(at: point, in: circleSize)
                            updateColor() // Actualizar color con sliders de saturación y brillo
                        }
                )
                .frame(width: circleSize.width, height: circleSize.height)

            // Slider para ajustar la saturación
            VStack {
                Text("Saturation")
                Slider(value: $saturation, in: 0...1) {
                    Text("Saturation")
                } onEditingChanged: { _ in }
                
                    .onChange(of: saturation) { oldValue, newValue in
                        updateColor()
                    }
            }

            // Slider para ajustar el brillo
            VStack {
                Text("Brightness")
                Slider(value: $brightness, in: 0...1) {
                    Text("Brightness")
                } onEditingChanged: { _ in }
                    .onChange(of: brightness) { oldValue, newValue in
                        updateColor()
                    }
            }
        }
        .onAppear {
            calculateColorAndPointFromSelected()
        }
    }
    
    private func calculateColorAndPointFromSelected() {
        // Convertir el color seleccionado en sus componentes HSB
        let uiColor = UIColor(selectedColor)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        // Extraer componentes de HSB
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        // Actualizar los sliders de saturación y brillo
        self.saturation = saturation
        self.brightness = brightness
        
        calculatePoint()
    }
    
    private func calculatePoint() {
        // Calcular la posición del punto en el anillo basado en el hue
        let radius = circleSize.width / 2
        let angle = hue * 2 * .pi
        let ringRadius = radius - 25
        let newX = radius + ringRadius * cos(angle)
        let newY = radius + ringRadius * sin(angle)
        
        // Actualizar la posición del punto
        point = CGPoint(x: newX, y: newY)
    }
    
    // Función para actualizar el color basado en el hue, la saturación y el brillo
    private func updateColor() {
        // Crear un color basado en los valores de hue, saturación y brillo
        selectedColor = Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(brightness))
        calculatePoint()
    }

    // Función para obtener el hue (tono) basado en la posición en el anillo
    private func getHue(at location: CGPoint, in size: CGSize) -> CGFloat {
        let radius = size.width / 2
        let dx = location.x - radius
        let dy = location.y - radius
        
        // Calcular el ángulo en radianes desde la posición del toque
        var angle = atan2(dy, dx)
        
        // Asegurar que el ángulo sea positivo (de 0 a 2π)
        if angle < 0 { angle += 2 * .pi }
        
        // Normalizar el ángulo para que esté entre 0 y 1 (Hue)
        return angle / (2 * .pi)
    }

    // Función para calcular el offset correcto del selector (punto blanco)
    private func getOffset(for point: CGPoint, in size: CGSize) -> CGSize {
        let radius = size.width / 2
        let dx = point.x - radius
        let dy = point.y - radius
        return CGSize(width: dx, height: dy)
    }
    
    // Función para calcular un punto en la circunferencia del anillo
    private func calculatePointOnRing(from location: CGPoint, in size: CGSize) -> CGPoint {
        let radius = size.width / 2
        let dx = location.x - radius
        let dy = location.y - radius

        // Calcular el ángulo
        let angle = atan2(dy, dx)

        // Ajustar el radio para mantener el punto en el centro del anillo (25 es la mitad del grosor)
        let ringRadius = radius - 25

        // Calcular las nuevas coordenadas del punto en el anillo
        let newX = radius + ringRadius * cos(angle)
        let newY = radius + ringRadius * sin(angle)

        return CGPoint(x: newX, y: newY)
    }
}

#Preview {
    @State var color = Color.yellow
    return ContentView(selectedColor: $color)
}
