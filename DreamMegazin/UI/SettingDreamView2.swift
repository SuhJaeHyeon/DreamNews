//
//  SettingDreamView2.swift
//  DreamMegazin
//
//  Created by martin on 6/12/24.
//

import SwiftUI

struct SettingDreamView2: View {
    @Binding var isPresented: Bool
    @State private var isNextActive: Bool = false
    @State private var selectedYears = 0
    @State private var selectedMonths = 0
    @State private var showYearPicker = false
    @State private var showMonthPicker = false
    let years = Array(0...50) // 0부터 50년까지 선택할 수 있는 배열
    let months = Array(0...11) // 0부터 11개월까지 선택할 수 있는 배열
    var body: some View {
        if isNextActive {
            SettingDreamView3(isPresented: $isPresented)
        } else {
            VStack(alignment: .leading, spacing: 20, content: {
                VStack(content: {
                    Text("당신의 꿈은 언제 이루어지나요?")
                    Spacer()
                        .frame(height: 50)
                    HStack{
                        Spacer()
                        Button(action: {
                            self.showYearPicker = true
                        }) {
                            Text("\(String(format: "%02d", selectedYears))")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.gray)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        .frame(width: 80)
                        .cornerRadius(10)
                        .sheet(isPresented: $showYearPicker) {
                            VStack {
                                Picker(selection: $selectedYears, label: Text("년")) {
                                    ForEach(0 ..< self.years.count) {
                                        Text("\(self.years[$0]) 년")
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                
                                HStack {
                                    Button(action: {
                                        self.showYearPicker = false
                                    }) {
                                        Text("취소")
                                            .padding(.vertical, 10)
                                    }
                                    .padding(.horizontal)
                                    Spacer()
                                    Button(action: {
                                        self.showYearPicker = false
                                    }) {
                                        Text("완료")
                                            .foregroundColor(.blue)
                                            .padding(.vertical, 10)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        Text("년")
                        Button(action: {
                            self.showMonthPicker = true
                        }) {
                            Text("\(String(format: "%02d", selectedMonths))")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.gray)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        .frame(width: 80)
                        .cornerRadius(10)
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
                        Text("월")
                        Spacer()
                    }
                })
                .padding(.top, 100)
                Spacer()
                Button(action: {
                    UserDefaults.standard.set(selectedYears, forKey: "TIME_YEAR")
                    UserDefaults.standard.set(selectedMonths, forKey: "TIME_MONTH")
                    isNextActive = true
                }) {
                    Text("다음")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            })
            .padding()
            .navigationBarHidden(true)
        }
    }
}
struct SettingDreamView2_Previews: PreviewProvider {
    static var previews: some View {
        SettingDreamView2(isPresented: .constant(false))
    }
}
