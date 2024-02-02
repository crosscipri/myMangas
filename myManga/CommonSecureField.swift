//
//  CommonSecureField.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 20/12/23.
//

import SwiftUI


struct CommonSecureField: View {
    
    let label: String
    @Binding var text: String
    var validator: (String) -> String? = Validators.shared.isEmpty
    
    @State private var errorMessage = ""


    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
                .padding(.leading, 10)
            HStack {
                SecureField("Introducir \(label)", text: $text)
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark")
                        .symbolVariant(.fill)
                        .symbolVariant(.circle)
                }
                .buttonStyle(.plain)
                .opacity(text.isEmpty ? 0.0 : 0.5)
            }
            .padding(10)
            .background {
                Color(white: 0.95)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .fill(.red)
                    .opacity(!errorMessage.isEmpty ? 1.0 : 0.0)
            }
            if !errorMessage.isEmpty {
                Text("Error \(errorMessage)")
                    .bold()
                    .font(.caption)
                    .padding(.leading, 10)
                    .foregroundStyle(.red)
                    .transition(.opacity)
            }
        }
        .onChange(of: text, initial: false) {
            if let errorMsg = validator(text) {
                errorMessage = errorMsg
            } else {
                errorMessage = ""
            }
        }
        .animation(.default, value: errorMessage)
    }
    
}

#Preview {
    CommonSecureField(label: "Contraseña", text: .constant("cipri@gmail.com"))
}
