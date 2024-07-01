import Foundation

struct Message: Codable, Identifiable {
    var id = UUID()
    let role: String
    let content: String
}

class ChatGPTSession: ObservableObject {
    @Published var messages: [Message] = []
    
    init() {
        loadMessages()
    }
    
    func sendMessage(_ prompt: String, completion: @escaping (String?) -> Void) {
        let userMessage = Message(role: "user", content: prompt)
        messages.append(userMessage)
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "model": "gpt-4",
            "messages": messages.map { ["role": $0.role, "content": $0.content] },
            "max_tokens": 6000
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        func handleResponse(data: Data?, error: Error?, attempt: Int) {
            guard let data = data, error == nil else {
                if attempt < 3 {
                    print("Error: \(error?.localizedDescription ?? "Unknown error"), retrying (\(attempt))...")
                    performRequest(attempt: attempt + 1)
                } else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error"), maximum retry attempts reached.")
                    DispatchQueue.main.async {
                        completion("Error: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
                    let assistantMessage = Message(role: "assistant", content: trimmedContent)
                    DispatchQueue.main.async {
                        self.messages.append(assistantMessage)
                        self.saveMessages()
                        print("==> \(trimmedContent)")
                        completion(trimmedContent)
                    }
                } else {
                    print("Invalid JSON response")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } catch {
                print("JSON Serialization error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion("JSON Serialization error: \(error.localizedDescription)")
                }
            }
        }
        
        func performRequest(attempt: Int = 1) {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                handleResponse(data: data, error: error, attempt: attempt)
            }
            task.resume()
        }
        
        performRequest()
    }

    private func saveMessages() {
        let filePath = getFilePath()
        do {
            let data = try JSONEncoder().encode(messages)
            try data.write(to: filePath)
        } catch {
            print("Failed to save messages: \(error.localizedDescription)")
        }
    }

    private func loadMessages() {
        let filePath = getFilePath()
        do {
            let data = try Data(contentsOf: filePath)
            messages = try JSONDecoder().decode([Message].self, from: data)
        } catch {
            print("Failed to load messages: \(error.localizedDescription)")
        }
    }

    private func getFilePath() -> URL {
        return getDocumentsDirectory().appendingPathComponent("chatgpt_session.json")
    }
    
    private func getFilePathOf(name:String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(name)
    }
    
    func saveFileToPath(_ path:String, content: String){
        do {
            let data = try JSONEncoder().encode(content)
            try data.write(to: getFilePathOf(name: path))
        } catch {
            print("Failed to save messages: \(error.localizedDescription)")
        }
    }
    
}
