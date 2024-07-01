import SwiftUI

struct ProfileDreamView: View {
    @State private var dreamJob: String = ""
    @State private var dreamTime: String = ""
    @State private var dreamContent: String = ""
    @State private var selectedYears = 0
    @State private var selectedMonths = 0
    @State private var showYearPicker = false
    @State private var showMonthPicker = false
    let years = Array(0...50) // 0부터 50년까지 선택할 수 있는 배열
    let months = Array(0...11) // 0부터 11개월까지 선택할 수 있는 배열
    
    var body: some View {
        ZStack {
            MAIN_BACK_COLOR.edgesIgnoringSafeArea(.all) // 전체 배경 색상 설정
            List {
                Section(header: Text("나의 꿈을 수정하기")) {
                    TextField("나의 꿈", text: $dreamJob)
                }
                Section(header: Text("나의 꿈에 이루어지는 기간")) {
                    HStack {
                        Button(action: {
                            self.showYearPicker = true
                        }) {
                            Text("\(selectedYears) 년")
                                .foregroundColor(.blue)
                                .padding()
                        }
                        .border(Color.black)
                        .sheet(isPresented: $showYearPicker) {
                            VStack {
                                Picker(selection: $selectedYears, label: Text("년")) {
                                    ForEach(0 ..< self.years.count) {
                                        Text("\(self.years[$0]) 년")
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        self.showYearPicker = false
                                    }) {
                                        Text("취소")
                                            .padding(.vertical, 10)
                                    }
                                    .padding(.horizontal)
                                    
                                    Button(action: {
                                        self.showYearPicker = false
                                        // 선택된 내용을 적용하는 로직을 추가할 수 있습니다.
                                    }) {
                                        Text("완료")
                                            .foregroundColor(.blue)
                                            .padding(.vertical, 10)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        Button(action: {
                            self.showMonthPicker = true
                        }) {
                            Text("\(selectedMonths) 개월")
                                .foregroundColor(.blue)
                                .padding()
                        }
                        .border(Color.blue)
                        .sheet(isPresented: $showMonthPicker) {
                            VStack {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        self.showMonthPicker = false
                                    }) {
                                        Text("취소")
                                            .padding(.vertical, 10)
                                    }
                                    .padding(.horizontal)
                                    Spacer()
                                    Button(action: {
                                        self.showMonthPicker = false
                                        // 선택된 내용을 적용하는 로직을 추가할 수 있습니다.
                                    }) {
                                        Text("완료")
                                            .foregroundColor(.blue)
                                            .padding(.vertical, 10)
                                    }
                                    .padding(.horizontal)
                                }
                                Picker(selection: $selectedMonths, label: Text("개월")) {
                                    ForEach(0 ..< self.months.count) {
                                        Text("\(self.months[$0]) 개월")
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                            }
                        }
                    }
                }
                Section(header: Text("나의 꿈에 대한 자세한 설명")) {
                    ZStack(alignment: .topLeading) {
                        if dreamContent.isEmpty {
                            Text("여기에 꿈에 대한 설명을 입력하세요")
                                .foregroundColor(Color(UIColor.placeholderText))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 15)
                        }
                        TextEditor(text: $dreamContent)
                            .frame(minHeight: 100, maxHeight: 200)
                            .padding(.vertical, 8)
                    }
                    
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .background(MAIN_BACK_COLOR)
                
                Button(action: {
                    // 저장 로직
                }) {
                    Text("저장")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(MAIN_BACK_COLOR3)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .background(MAIN_BACK_COLOR)
                    
            }
            .onAppear {
                dreamJob = UserDefaults.standard.string(forKey: "dreamJob") ?? ""
                dreamTime = UserDefaults.standard.string(forKey: "dreamTime") ?? ""
                dreamContent = UserDefaults.standard.string(forKey: "dreamContent") ?? ""
            }
            .padding(.top, 60)
            .environment(\.defaultMinListRowHeight, 0)
        }
    }
}

#Preview {
    ProfileDreamView()
}
