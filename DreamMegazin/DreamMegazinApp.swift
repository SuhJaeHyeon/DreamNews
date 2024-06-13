//
//  DreamMegazinApp.swift
//  DreamMegazin
//
//  Created by JaehyeonS on 5/22/24.
//

import OpenAIKit
import SwiftUI
import FirebaseCore
let apiToken: String = ""
let organizationName: String = "Personal"

/// Initialize OpenAIKit with your API Token wherever convenient in your project. Organization name is optional.
var openAI: OpenAIKit?

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if let filePath = Bundle.main.path(forResource: "api.openai.com", ofType: "cer") {
            openAI = OpenAIKit(apiToken: apiToken, organization: nil, sslCerificatePath: filePath)
        }
        
        #if DEBUG
        createSampleJSONFiles()
        #endif
        
        //UserDefaults.standard.removeObject(forKey: "dream")
        FirebaseApp.configure()
        
        return true
    }
    
    func createSampleJSONFiles() {
        let newsData01: [[String: Any]] = [
            [
                "id": UUID().uuidString,
                "title": "회사를 설립하다",
                "date": "2025-05-20",
                "content": "이준호는 1994년생으로, 현재 예비창업가로서 '바텐더리그'라는 바텐더 이적 시장 서비스를 만들고 있었다. 서비스의 초기 버전은 이미 베타 테스트 단계에 접어들었고, 몇몇 바텐더와 바 업주들 사이에서 호평을 받고 있었다. 그는 2025년 5월 20일, 드디어 '바텐더리그'로 회사를 설립하게 되었다.",
                "isCompleted": true

            ],
            [
                "id": UUID().uuidString,
                "title": "첫 투자 유치",
                "date": "2025-06-01",
                "content": "2025년 6월 1일, 준호는 드디어 첫 투자를 유치했다. 박선영과의 미팅 이후, 그녀는 5억 원의 초기 투자를 결정했다. 이 소식은 준호의 팀에게 큰 희망을 주었고, 이제 본격적으로 서비스를 확장할 수 있는 발판이 마련되었다.",
                "isCompleted": true

            ]
        ]

        let newsData02: [[String: Any]] = [
            [
                "id": UUID().uuidString,
                "title": "서비스 정식 론칭",
                "date": "2025-09-15T12:34:56Z",
                "content": "2025년 9월 15일, 드디어 '바텐더리그' 서비스가 정식으로 론칭되었다. 준호와 그의 팀은 지난 몇 달 동안 수많은 밤을 새며 일해왔다. 그들은 버그를 수정하고, 사용자 피드백을 반영해 서비스를 최적화했다. 이제 모든 준비가 끝났고, 세상에 '바텐더리그'를 공개할 시간이었다.",
                "isCompleted": true
            ],
            [
                "id": UUID().uuidString,
                "title": "숨겨진 도전",
                "date": "2026-02-20T12:34:56Z",
                "content": "2026년 2월 20일, 준호는 사무실에서 혼자 남아 깊은 생각에 잠겨 있었다. 바텐더리그의 성공적인 첫 해를 보낸 후에도, 그는 여전히 많은 도전과 압박에 시달리고 있었다. 특히, 최근 들어 몇몇 경쟁사들이 비슷한 서비스를 출시하면서 경쟁이 치열해지고 있었다.",
                "isCompleted": true
            ],
            [
                "id": UUID().uuidString,
                "title": "투자자의 의구심",
                "date": "2026-04-10T12:34:56Z",
                "content": "2026년 4월 10일, 준호는 주요 투자자인 박선영과의 미팅을 준비하고 있었다. 박선영은 최근 경쟁사들의 성장을 우려하며, 바텐더리그의 미래에 대해 의구심을 품고 있었다. 준호는 그녀를 설득하기 위해 철저한 준비를 했다.",
                "isCompleted": true
            ],
            [
                "id": UUID().uuidString,
                "title": "1주년 기념",
                "date": "2026-05-20T12:34:56Z",
                "content": "2026년 5월 20일, '바텐더리그'는 설립 1주년을 맞이했다. 지난 1년 동안, 서비스는 빠르게 성장했고, 많은 바 업주들과 바텐더들이 '바텐더리그'를 통해 새로운 기회를 찾았다. 준호는 이 날을 기념하기 위해 특별한 이벤트를 준비했다.",
                "isCompleted": true
            ],
            [
                "id": UUID().uuidString,
                "title": "팀 내부의 갈등",
                "date": "2026-06-25T12:34:56Z",
                "content": "2026년 6월 25일, 준호는 팀 내부의 갈등으로 골머리를 앓고 있었다. 최근 들어 몇몇 팀원들이 업무 분담과 관련하여 불만을 표출하기 시작했다. 특히, 개발팀과 마케팅팀 사이의 협업 문제는 심각한 수준에 이르렀다.",
                "isCompleted": true
            ],
            [
                "id": UUID().uuidString,
                "title": "예상치 못한 장애물",
                "date": "2026-07-15T12:34:56Z",
                "content": "2026년 7월 15일, '바텐더리그'는 예상치 못한 장애물에 부딪혔다. 서비스의 주요 서버에 문제가 발생해, 몇 시간 동안 접속이 불가능해진 것이다. 사용자들의 불만이 폭주했고, 준호는 긴급 대응에 나섰다.",
                "isCompleted": true
            ],
            [
                "id": UUID().uuidString,
                "title": "국제 시장 진출",
                "date": "2026-08-01T12:34:56Z",
                "content": "2026년 8월 1일, 준호는 '바텐더리그'의 첫 해외 진출을 앞두고 있었다. 일본 시장에서의 런칭 이벤트를 위해 그는 도쿄에 도착했다. 도쿄의 여름은 덥고 습했지만, 준호는 이번 기회를 통해 '바텐더리그'를 국제적으로 확장할 수 있다는 생각에 흥분을 감출 수 없었다.",
                "isCompleted": true
            ],
            [
                "id": UUID().uuidString,
                "title": "예상치 못한 장애물",
                "date": "2026-07-15T12:34:56Z",
                "content": "2026년 7월 15일, '바텐더리그'는 예상치 못한 장애물에 부딪혔다. 서비스의 주요 서버에 문제가 발생해, 몇 시간 동안 접속이 불가능해진 것이다. 사용자들의 불만이 폭주했고, 준호는 긴급 대응에 나섰다.",
                "isCompleted": true
            ],
            [
                "id": UUID().uuidString,
                "title": "새로운 시작",
                "date": "2026-08-20T12:34:56Z",
                "content": "2026년 8월 20일, 준호는 새로운 결의를 다졌다. 지난 몇 달 동안 겪은 도전과 어려움은 그를 더욱 강하게 만들었다. 그는 '바텐더리그'를 더 큰 성공으로 이끌기 위해 새로운 전략을 구상했다.",
                "isCompleted": true
            ],
            [
                "id": UUID().uuidString,
                "title": "첫 국제 컨퍼런스",
                "date": "2026-11-15T12:34:56Z",
                "content": "2026년 11월 15일, '바텐더리그'는 첫 국제 컨퍼런스를 개최했다. 서울에서 열린 이 행사에는 전 세계 각지에서 온 바 업계 전문가들이 참석했다. 준호는 이 행사에서 글로벌 네트워크를 구축하고, '바텐더리그'의 국제적 성장을 도모할 계획이었다.",
                "isCompleted": true
            ],
            [
                "id": UUID().uuidString,
                "title": "새로운 도전",
                "date": "2027-02-10T12:34:56Z",
                "content": "2027년 2월 10일, 준호는 또 다른 도전을 앞두고 있었다. '바텐더리그'는 이제 가상 현실(VR) 기술을 도입해, 바텐더 교육과 트레이닝을 혁신하려고 했다. 준호는 팀원들과 함께 이 새로운 프로젝트를 준비하며, 흥분과 긴장감 속에서 하루하루를 보냈다.",
                "isCompleted": true
            ]
        ]

        saveJSONToFile(data: newsData01, fileName: "news_01.json")
        saveJSONToFile(data: newsData02, fileName: "news_02.json")
    }

    func saveJSONToFile(data: [[String: Any]], fileName: String) {
        let fileManager = FileManager.default
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                try jsonData.write(to: fileURL)
                print("Successfully saved \(fileName) to \(fileURL)")
            } catch {
                print("Failed to save \(fileName): \(error)")
            }
        }
    }
}

@main
struct DreamMegazinApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
