//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Huynh Huyen on 7/8/25.
//

import Foundation

class TriviaQuestionService {
    static func fetchQuestions(amount: Int, completion: (([TriviaQuestion]) -> Void)? = nil)  {
        let url = URL(string: "https://opentdb.com/api.php?amount=\(amount)")!
        
        // create a data task and pass in the URL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
          // this closure is fired when the response is received
          guard error == nil else {
            assertionFailure("Error: \(error!.localizedDescription)")
            return
          }
          guard let httpResponse = response as? HTTPURLResponse else {
            assertionFailure("Invalid response")
            return
          }
          guard let data = data, httpResponse.statusCode == 200 else {
            assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
            return
          }
            // Parse the data
            guard let questions = parse(data: data) else {
                assertionFailure("Failed to parse trivia questions")
                return
            }

            // Return the parsed questions on the main thread
            DispatchQueue.main.async {
                completion?(questions)
            }
         
        }
        task.resume()
        
    }
    private static func parse(data: Data) -> [TriviaQuestion]? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(TriviaResponse.self, from: data)
            return response.results
        } catch {
            assertionFailure("Error parsing JSON: \(error)")
            return nil
        }
    }
}
