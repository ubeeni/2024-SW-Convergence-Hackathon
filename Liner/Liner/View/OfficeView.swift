//
//  OfficeView.swift
//  Liner
//
//  Created by KimYuBin on 8/25/24.
//

import SwiftUI

struct OfficeView: View {
    @State private var isMicOn: Bool = true
    
    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 10) {
                HStack {
                    VStack {
                        ZStack(alignment: .bottomTrailing) {
                            Image(.imgProfile3)
                                .resizable()
                                .frame(width: 130, height: 130)
                                .clipShape(Circle())
                            
                            Circle()
                                .frame(width: 34, height: 34)
                                .foregroundStyle(Color.green)
                        }
                        
                        Text("김소람")
                            .font(Font.system(size: 22))
                            .fontWeight(.bold)
                    }
                    
                    VStack {
                        ZStack(alignment: .bottomTrailing) {
                            Image(.imgProfile4)
                                .resizable()
                                .frame(width: 130, height: 130)
                                .clipShape(Circle())
                            
                            Circle()
                                .frame(width: 34, height: 34)
                                .foregroundStyle(Color.green)
                        }
                        
                        Text("김유빈")
                            .font(Font.system(size: 22))
                            .fontWeight(.bold)
                    }
                    .padding(.leading, 80)
                    
                    VStack {
                        ZStack(alignment: .bottomTrailing) {
                            Image(.imgProfile5)
                                .resizable()
                                .frame(width: 130, height: 130)
                                .clipShape(Circle())
                            
                            Circle()
                                .frame(width: 34, height: 34)
                                .foregroundStyle(Color.green)
                        }
                        
                        Text("김강혁")
                            .font(Font.system(size: 22))
                            .fontWeight(.bold)
                    }
                    .padding(.leading, 80)
                }
                
                HStack {
                    VStack {
                        ZStack(alignment: .bottomTrailing) {
                            Image(.imgProfile1)
                                .resizable()
                                .frame(width: 130, height: 130)
                                .clipShape(Circle())
                            
                            Circle()
                                .frame(width: 34, height: 34)
                                .foregroundStyle(Color.green)
                        }
                        
                        Text("윤혁진")
                            .font(Font.system(size: 22))
                            .fontWeight(.bold)
                    }
                    
                    VStack {
                        ZStack(alignment: .bottomTrailing) {
                            Image(.imgProfile2)
                                .resizable()
                                .frame(width: 130, height: 130)
                                .clipShape(Circle())
                            
                            Circle()
                                .frame(width: 34, height: 34)
                                .foregroundStyle(Color.green)
                        }
                        
                        Text("이선하")
                            .font(Font.system(size: 22))
                            .fontWeight(.bold)
                    }
                    .padding(.leading, 80)
                }
            }
            .padding(.horizontal, 112)
            .padding(.vertical, 42)
            .frame(width : 900, height: 426)
            .background(
              LinearGradient(
                stops: [
                  Gradient.Stop(color: Color(red: 0.88, green: 0.93, blue: 0.74), location: 0.00),
                  Gradient.Stop(color: .white, location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.51, y: 1)
              )
            )
            .cornerRadius(32)
            .padding(.top, 42)
            
            Spacer()
            
            HStack {
                Button(action: {
                    isMicOn.toggle()
                }) {
                    Image(systemName: isMicOn ? "mic.fill" : "mic.slash.fill")
                        .foregroundStyle(Color(red: 0.62, green: 0.62, blue: 0.62))
                        .font(.system(size: 60))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 18)
                        .frame(width: 80, height: 80)
                        .background(isMicOn ? Color(red: 0.85, green: 0.97, blue: 0.51) : Color(red: 0.85, green: 0.85, blue: 0.85))
                        .cornerRadius(16)
                }
                
                HStack(alignment: .center, spacing: 10) {
                    
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(width: 700, height: 80)
                .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                .cornerRadius(16)
                
                Button(action: {
                    
                }, label: {
                    VStack(alignment: .center, spacing: 10) {
                        Image(systemName: "arrow.turn.down.left")
                            .resizable()
                            .frame(width: 50, height: 40)
                            .foregroundStyle(Color(red: 0.62, green: 0.62, blue: 0.62))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 18)
                    .frame(width: 120, height: 80, alignment: .center)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                    .cornerRadius(16)
                })
            }
            .padding(.bottom, 42)
        }
    }
}

#Preview {
    OfficeView()
}
