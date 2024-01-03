//
//  ContentView.swift
//  FastingTimer
//
//  Created by Jeff Barra on 12/28/23.
//

import SwiftUI

struct ContentView: View {
    // Create instance of FastingManager
    @StateObject var fastingManager = FastingManager()
    
    // Defines color associated with each fasting plan
    func fastingPlanColor(for plan: FastingPlan) -> Color {
        switch plan {
        case .beginner:
            return .blue
        case .intermediate:
            return .purple
        case .advanced:
            return .orange
        }
    }


    // Title bar status
    var title: String {
        switch fastingManager.fastingState {
        case .notStarted:
            return "Let's Get Started"
        case .fasting:
            return "You Are Fasting 🚫"
        case .feeding:
            return "You Are Feeding 💪"
        }
    }

    var body: some View {
        ZStack {
            // MARK: Background
            Color.black
                .ignoresSafeArea()


            content
        }
        .foregroundColor(.white)
    }

    var content: some View {
        ZStack {
            VStack(spacing: 20) {
                // MARK: Title
                Text(title)
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                
                Text("Select Your Plan")
                    .font(.headline)
                    .foregroundColor(.white)

                // MARK: Fasting Plan Button
                Button(action: {
                    // Update fastingPlan when the button is pressed
                    switch fastingManager.fastingPlan {
                    case .beginner:
                        fastingManager.fastingPlan = .intermediate
                    case .intermediate:
                        fastingManager.fastingPlan = .advanced
                    case .advanced:
                        fastingManager.fastingPlan = .beginner
                    }
                    // Recalculate timers
                    fastingManager.startTime = Date()
                }) {
                        Text(fastingManager.fastingPlan.rawValue)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                            .background(fastingPlanColor(for: fastingManager.fastingPlan))
                        .cornerRadius(20)
                        .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 2))
                }
                Spacer()
            }
            .padding()

            VStack(spacing: 40) {
                // MARK: Progress Ring
                ProgressRing()
                    .environmentObject(fastingManager)

                // MARK: Button
                ToggleFastingButton(fastingManager: fastingManager)
                    .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 2))
            }
            .padding()

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    static let appBackground = Color(.black)
}

struct ToggleFastingButton: View {
    @ObservedObject var fastingManager: FastingManager

    var body: some View {
        Button {
            fastingManager.toggleFastingState()
        } label: {
            Text(fastingManager.fastingState == .fasting ? "End Fast" : "Start Fasting")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(fastingManager.fastingState == .fasting ? .red : .green)
                .cornerRadius(20)
        }
    }
}



#Preview {
    ContentView()
}
