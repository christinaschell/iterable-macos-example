//
//  ButtonView.swift
//  MacOSPushTest
//
//  Created by Christina Schell on 7/5/23.
//

import SwiftUI

struct ButtonView: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(title) {
            action()
        }
        .foregroundColor(.white)
        .background(Color.darkPurple)
        .buttonStyle(.borderedProminent)
        .padding(5)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(title: "Tester") {
            print("pressed")
        }
    }
}
