//
//  LoginView.swift
//  Liner
//
//  Created by KimYuBin on 8/25/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var userName: String = ""
    @State private var isShow: Bool = false
    
    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .center) {
                    Image(.linerLogo)
                        .frame(width: 280, height: 121)
                    
                    HStack {
                        VStack {
                            TextField("이름", text: $userName)
                                .foregroundStyle(Color(red: 0.47, green: 0.49, blue: 0.54))
                                .padding()
                                .frame(width: 450, height: 84)
                                .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                                .cornerRadius(16)
                            //
                            //                        TextField("회사메일을 입력해주세요", text: $email)
                            //                            .foregroundStyle(Color(red: 0.47, green: 0.49, blue: 0.54))
                            //                            .padding()
                            //                            .frame(width: 450, height: 84)
                            //                            .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                            //                            .cornerRadius(16)
                            //
                            //                        SecureField("비밀번호를 입력해주세요", text: $password)
                            //                            .foregroundStyle(Color(red: 0.47, green: 0.49, blue: 0.54))
                            //                            .padding()
                            //                            .frame(width: 450, height: 84)
                            //                            .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                            //                            .cornerRadius(16)
                            //                            .padding(.top, 16)
                        }
                        NavigationLink {
                            ContentView(userName: userName)
                        } label: {
                            VStack(alignment: .center, spacing: 10) {
                                Image(systemName: "arrow.turn.down.left")
                                    .resizable()
                                    .frame(width: 50, height: 40)
                                    .foregroundStyle(Color(red: 0.62, green: 0.62, blue: 0.62))
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 18)
                            .frame(width: 120, height: 188, alignment: .center)
                            .background(isFormValid ? Color(red: 0.85, green: 0.97, blue: 0.51) : Color(red: 0.85, green: 0.85, blue: 0.85))
                            .cornerRadius(16)
                        }
                    }
                    
                    Button(action: {
                        
                    }, label: {
                        Text("로그인에 어려움이 있나요?")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color(red: 0.62, green: 0.62, blue: 0.62))
                            .frame(width: 586, height: 18, alignment: .leading)
                    })
                    .padding(.top, 16)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.59, green: 0.69, blue: 0.3).opacity(0.4), location: 0.01),
                    Gradient.Stop(color: Color(red: 0.14, green: 0.14, blue: 0.14).opacity(0.4), location: 0.55),
                    Gradient.Stop(color: Color(red: 0.14, green: 0.14, blue: 0.14).opacity(0.4), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.46, y: 1.26),
                endPoint: UnitPoint(x: 0.45, y: 0.19)
            )
        )
        .background(Color(red: 0.13, green: 0.13, blue: 0.13))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    LoginView()
}
