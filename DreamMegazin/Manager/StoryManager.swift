//
//  StoryManager.swift
//  DreamMegazin
//
//  Created by martin on 6/25/24.
//
import Foundation
import OpenAIKit
import UIKit

class StoryManager {
    static let shared = StoryManager()
    private init() {}
    let chatSession = ChatGPTSession()
    func makeTodayStory(partCount:Int) {
        
    }

    // 초기 셋팅
    func makeWholeStory(_ partCount:Int, completion: @escaping (Bool?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let myDream = UserDefaults.standard.integer(forKey: "dream")
        let year = UserDefaults.standard.integer(forKey: "TIME_YEAR")
        let month = UserDefaults.standard.integer(forKey: "TIME_MONTH")
        let myDreamDetail = UserDefaults.standard.integer(forKey: "DREAM_DETAIL")
        
        // 오늘 날짜에 연도와 월을 더한 날짜 계산
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        
        let koreanDateFormatter = DateFormatter()
        koreanDateFormatter.dateFormat = "yyyy년 MM월 dd일"
        var dreamDateString = ""
        if let futureDate = Calendar.current.date(byAdding: dateComponents, to: Date()) {
            dreamDateString = koreanDateFormatter.string(from: futureDate)
        }
        let prompt = """
        나는 미래의 일들을 생생하게 써내려가는 소설가야. 미래에 실제로 일어날 만한 사건들을 상상해서 사람들의 이야기를 써줘. 실제 날짜를 적고, 시간변화에 따른 스토리도 써. 사람들의 미래를 상상하는 것을 좋아하고, 그들의 꿈을 생생하게 소설로 써주는 것을 좋아해.
        이제 너는 글을 쓰는 작가고 사람들의 미래에 대한 소설을 써. 그 소설에는 실제 일어날법한 사건들이 생생하게 적혀있어. 사람들의 과거에 대해서는 쓰지마. 소설에는 스토리가 있어야 해. 특별한 사건이 있어야해.

        ** 내용에 대해 설명하자면
        나는 \(myDream)가 되고 싶어. 내 이름은 \(UserManager.shared.meUser?.name)고,
        나이는 \(UserManager.shared.meUser?.birthYear)년생이야. \(myDreamDetail).
        \(dreamDateString)에 일어나는 내 미래에 대한 소설을 실제와 같이 생생하게 써줘.

        *** 형식은 json으로
        "title": "",
        "date": "yyyy-mm-yy",
        "content": "소설내용"
        모양이었으면 좋겠어
        각 content마다 200자 이상 써줘.
        """
        chatSession.sendMessage(prompt) { response in
            if let response = response {
                self.chatSession.saveFileToPath("wholeStory.json", content:response)
                completion(true)
            } else {
                //self.resultLabel.text = "응답을 가져오지 못했습니다."
            }
        }
    }
    // STORY 폴더를 생성
    private func createStoryFolder() {
        let storyFolderURL = getDocumentsDirectory().appendingPathComponent("STORY")
        if !FileManager.default.fileExists(atPath: storyFolderURL.path) {
            do {
                try FileManager.default.createDirectory(at: storyFolderURL, withIntermediateDirectories: true, attributes: nil)
                print("STORY 폴더가 생성되었습니다.")
            } catch {
                print("STORY 폴더를 생성하는 데 실패했습니다: \(error.localizedDescription)")
            }
        }
    }

    func makeTodayStory(completion: @escaping (Bool?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDateString = dateFormatter.string(from: Date())
        let todayFileName = "\(todayDateString).json"
        
        let storyFolderURL = getDocumentsDirectory().appendingPathComponent("STORY")
        let todayFileURL = storyFolderURL.appendingPathComponent(todayFileName)
        if !FileManager.default.fileExists(atPath: todayFileURL.path) {
            
        } else {
            do {
                let jsonData = try Data(contentsOf: todayFileURL)
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    print("읽어온 JSON 데이터: \(json)")
                    
                    if let isSimple = json["isSimple"] as? String {
                        if isSimple == "NO" {
                            let source = json["content"]
                            print("isSimple 필드가 NO입니다.")
                            let prompt = """
                            아래 너가 준 이야기를 가지고 조금 더 풍부하게 이야기를 늘려줘.
                            그 스토리 속에서 조금이라도 꿈을 위해 성장하는 과정이 들어있으면 좋겠군
                            *** 소스가 되는 이야기는 아래와 같고,
                            \(String(describing: source))
                            *** 형식은 json으로
                            "title": "",
                            "date": "yyyy-mm-yy",
                            "content": "소설내용"
                            "isSimple": "NO"
                            모양이었으면 좋겠어
                            content는 2000자 이상 써줘.
                            """
                            chatSession.sendMessage(prompt) { response in
                                DispatchQueue.main.async {
                                    if let response = response {
                                        print("\(response)")
                                        var prompt = "아래 이야기와 어울리는 그림을 그려줘. 말풍선이 없는 웹툰 형식으로 한장짜리 였으면 좋겠어"
                                        Task {
                                            let result = await self.generateImage(prompt: "해가 그러져있는 이미지를 보여줘")
                                            completion(true)
                                        }
                                    } else {
                                        //self.resultLabe
                                    }
                                }
                            }
                        } else {
                            print("isSimple 필드가 YES입니다.")
                        }
                    } else {
                        print("isSimple 필드가 없습니다.")
                    }
                } else {
                    print("\(todayFileName) 파일을 읽는 데 실패했습니다.")
                }
            } catch {
                print("\(todayFileName) 파일을 읽는 데 실패했습니다: \(error.localizedDescription)")
            }
        }
    }

    
    func loadLastConversation() {
        if let lastMessage = chatSession.messages.last?.content {
            //resultLabel.text = lastMessage
        } else {
            //resultLabel.text = "이전 대화가 없습니다."
        }
    }
    
    func generateImage(prompt: String) async -> UIImage? {
        guard let openAi else { return nil }

        do {
            let params = ImageParameters(
                prompt: prompt,
                resolution: .medium,
                responseFormat: .base64Json
            )
            let result = try await openAi.createImage(
                parameters: params
            )
            return try openAi.decodeBase64Image(
                result.data[0].image
            )
        }
        catch {
            print(String(describing: error))
            return nil
        }
    }
    
    
    
    func getAIImage(){
        let userMessage = Message(role: "user", content: "나무 그림을 보여줘")
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "model": "dall-e-3",
            "messages": [userMessage].map { ["role": $0.role, "content": $0.content] },
            "max_tokens": 6000
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
             guard let data = data, error == nil else {
                 print("Error: \(error?.localizedDescription ?? "Unknown error")")
                 return
             }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let imageUrl = (json["data"] as? [[String: Any]])?.first?["url"] as? String {
                    print("Generated Image URL: \(imageUrl)")
                } else {
                    print("Failed to get image URL from response")
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
            }
         }

         task.resume()
     }
    func scheduleNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests() // 기존 알림 제거

        let days = [2, 4, 6] // 월, 수, 금 (2, 4, 6은 Calendar.Component.weekday에서 월, 수, 금에 해당)

        for day in days {
            let content = UNMutableNotificationContent()
            content.title = "정기 알림"
            content.body = "월, 수, 금 아침 8시 알림"
            content.sound = UNNotificationSound.default

            var dateComponents = DateComponents()
            dateComponents.hour = 8
            dateComponents.minute = 0
            dateComponents.weekday = day // 1: 일요일, 2: 월요일, ..., 7: 토요일

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: "notification_\(day)", content: content, trigger: trigger)

            center.add(request) { (error) in
                if let error = error {
                    print("Error adding notification: \(error)")
                }
            }
        }
    }
    func removeAllScheduledNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
}
