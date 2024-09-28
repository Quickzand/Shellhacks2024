import SwiftUI

struct LoadingView: View {
    var baseMessage: String = "Cooking up something tasty"
    @State private var isAnimating = false

    
    let maxDots = 3

    

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                // Pot base
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray)
                    .frame(width: 120, height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 0)
                    ).offset(y: 15)
                
                // Handle
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray)
                    .frame(width: 150, height: 30)
                    .offset(x: 0, y: 10)
                
                // Pot top (bubbles area)
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue.opacity(0.5))
                    .frame(width: 100, height: 40)
                    .offset(y: -10)
                
                // Bubbles
                ForEach(0..<20, id: \.self) { i in
                    Circle()
                        .fill(Color.white.opacity(0.8))
                        .frame(width: CGFloat.random(in: 10...20), height: CGFloat.random(in: 10...20))
                        .opacity(isAnimating ? 1 : 0)
                        .offset(x: CGFloat.random(in: -40...40), y: isAnimating ? -60 : 0)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: false)
                                .delay(Double(i) * 0.3),
                            value: isAnimating
                        )
                }
            }
            .onAppear {
                self.isAnimating = true
            }
            .padding(.bottom, 10)
            
            // Loading message with animated fading dots
            HStack(spacing: 5) {
                Text(baseMessage)
                    .font(.system(size: 25, weight:.bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.orange)
                
                ForEach(0..<maxDots, id: \.self) { index in
                    Text(".")
                        .font(.system(size: 25, weight:.bold))
                        .foregroundColor(.orange)
                }
            }
        }
        .padding()
    }
    
}

#Preview {
    LoadingView()
}
