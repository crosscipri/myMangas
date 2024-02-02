//
//  FilterButton.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 3/1/24.
//

import SwiftUI

struct FilterButton: View {
    @Binding var showFilters: Bool

    var body: some View {
           Button(action: {
               showFilters.toggle()

           }) {
               ZStack {
                   RoundedRectangle(cornerRadius: 13)
                       .frame(width: 44, height: 44)
                       .foregroundColor(Color(red: 255/255, green: 40/255, blue: 84/255))
                   
                   Image(systemName: "slider.horizontal.3")
                       .resizable()
                       .frame(width: 24, height: 24)
                       .foregroundColor(.white)
               }
           }
       }
}

#Preview {
    FilterButton(showFilters: .constant(true))
}
