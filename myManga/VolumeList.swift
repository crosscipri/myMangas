//
//  VolumeList.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 28/1/24.
//

import SwiftUI

struct VolumeList: View {
    var volumes: Int
     
    @Binding var readingVolume: Int
    @Binding var myVolumes: [Int]

    @State var selectedVolumes: [Int] = []

    init(volumes: Int, myVolumes: Binding<[Int]>, readingVolume: Binding<Int>) {
        self.volumes = volumes
        _myVolumes = myVolumes
        _readingVolume = readingVolume
    }

    var body: some View {
        List {
            ForEach(0..<volumes) { volume in
                HStack {
                    Text(String(format: "%02d", volume + 1))
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.gray.opacity(0.5))
                    Text("Volumen \(volume + 1)")
                        .font(.title3)
                    Spacer()
                    if myVolumes.contains(volume + 1) {
                        Button(action: {
                            if (volume + 1) == readingVolume {
                                readingVolume = 0
                            } else {
                                readingVolume = volume + 1
                                selectedVolumes.removeAll()
                            }
                        }) {
                            Image(systemName: "book.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor((volume + 1) == readingVolume ? .green : .blue)
                        }
                    } else {
                        Button(action: {
                            myVolumes.append(volume + 1)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(myVolumes.contains(volume + 1) ? .blue : .gray)
                        }
                    }
                }
                .padding([.top, .bottom])
            }
        }
    }
}
#Preview {
    VolumeList(volumes: 22, myVolumes: .constant([1]), readingVolume: .constant(1))
}
