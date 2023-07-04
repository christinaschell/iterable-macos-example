//
//  ShopView.swift
//  MacOSPushTest
//
//  Created by Christina Schell on 6/30/23.
//

import SwiftUI

struct ShopView: View {
    var body: some View {
        VStack {
            Image(systemName: "cart.fill")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Shop")
        }
        .padding()
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}
