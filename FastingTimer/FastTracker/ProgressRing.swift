//
//  ProgressRing.swift
//  FastingTimer
//
//  Created by Jeff Barra on 12/28/23.
//

import SwiftUI

struct ProgressRing: View {
    @EnvironmentObject var fastingManager: FastingManager
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            // MARK: Placeholder Ring
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(Color(.systemGray5))
                .opacity(0.1)
            
            // MARK: Color Ring
            Circle()
                .trim(from: 0.0, to: min(fastingManager.progress, 1.0))
                .stroke(AngularGradient(gradient: Gradient(colors: [.indigo, .pink, .purple, .mint, .indigo]), center: .center), style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                .rotationEffect(Angle(degrees: 270))
                .animation(.easeInOut(duration: 1.0), value: fastingManager.progress)
            
            VStack(spacing: 30) {
                if fastingManager.fastingState == .notStarted {
                    VStack(spacing: 5) {
                        // MARK: Upcoming Fast
                        Text("Upcoming Fast")
                        
                        Text("\(fastingManager.fastingPlan.fastingPeriod.formatted()) Hours")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                } else {
//                    // MARK: Elapsed Time
//                    VStack(spacing: 5) {
//                        Text("Elapsed Time (\(max(fastingManager.progress, 0.0).formatted(.percent)))")
//                            .opacity(0.7)
//                        
//                        Text(fastingManager.startTime, style: .timer)
//                            .font(.title)
//                            .fontWeight(.bold)
//                    }
//                    .padding(.top)
                    
                    // MARK: Remaining Time
                    VStack(spacing: 5) {
                        
                        if !fastingManager.elapsed {
                            Text("Fasting Timer")
//                            Text("Remaining Time (\((1 - fastingManager.progress).formatted(.percent)))")
//                                .opacity(0.7)
                        } else {
                            Text("Feeding Timer")
                            
                        }
                        // Timer
                        Text(fastingManager.endTime, style: .timer)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                    }
                }
                


            }
            
        }
        .frame(width: 250, height: 250)
        .padding()
        // change state progress
//        .onAppear {
//            progress = 1
//        }
        .onReceive(timer) { _ in
            fastingManager.track()
        }
    }
}

#Preview {
    ProgressRing()
    .environmentObject(FastingManager())}
