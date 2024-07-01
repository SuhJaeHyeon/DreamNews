import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    @State private var isMale: Bool = true
    @State private var selectedAge: Int = 22
    @State private var showAgePicker: Bool = false
    
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    Section(header: Text("계정 정보")) {
                        TextField("이메일", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("비밀번호", text: $password)
                        
                        SecureField("비밀번호 확인", text: $confirmPassword)
                    }
                    
                    Section(header: Text("개인 정보")) {
                        HStack {
                            Text("성별")
                            Spacer()
                            CustomToggle(isOn: $isMale)
                        }
                        HStack {
                            Text("나이")
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width:60, height: 30) // 원하는 높이로 설정
                                Text("\(selectedAge)세")
                                    .foregroundColor(.black)
                            }
                            .onTapGesture {
                                showAgePicker.toggle()
                            }
                        }
                    }
                    
                    if let errorMessage = errorMessage {
                        Section {
                            Text(errorMessage)
                                .foregroundColor(.red)
                        }
                    }
                    
                    Section {
                        Button(action: signUp) {
                            Text("회원 가입")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                }
                .navigationBarTitle("회원 가입", displayMode: .inline)
                .navigationBarItems(trailing: Button("취소") {
                    presentationMode.wrappedValue.dismiss()
                })
            }
            
            if showAgePicker {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showAgePicker = false
                    }
                
                VStack {
                    Spacer()
                    
                    Picker("나이", selection: $selectedAge) {
                        ForEach(18..<100) { age in
                            Text("\(age) 세").tag(age)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 300)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding()
                }
            }
        }
    }
    
    func signUp() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }
            // 회원가입 성공
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CustomToggle: View {
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(isOn ? "남성" : "여성")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(isOn ? Color.blue : Color.pink)
                .cornerRadius(10)
                .onTapGesture {
                    isOn.toggle()
                }
        }
        .frame(height: 30)
        .background(isOn ? Color.blue : Color.pink)
        .cornerRadius(10)
        .animation(.easeInOut, value: isOn)
    }
}

#Preview {
    SignUpView()
}
