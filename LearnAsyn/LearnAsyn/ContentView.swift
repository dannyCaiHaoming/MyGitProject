//
//  ContentView.swift
//  LearnAsyn
//
//  Created by 蔡浩铭 on 2025/6/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var model: AsynAwait = AsynAwait()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            if model.isWake {
                Text("Hello, world!")
            }
            Button {
                Task {
                    await model.wakeup()
                }
            } label: {
                Text("Press me")
            }

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
