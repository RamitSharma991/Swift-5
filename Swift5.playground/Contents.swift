import UIKit

// Result type in Standard Library giving simpler and clearer way for handling complex code like asynchronous code
// Swift Result type is implemented as an enum having twi cases success and failure using generics
// Failure must conform to swift error type

enum NetworkError: Error {
    case badURL
}
    func fetchUnreadCount(from urlString: String, completionHandler: @escaping (Result<Int, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else { completionHandler(.failure(.badURL))
            return
        }
        print("Fetching \(url.absoluteString)....")
        completionHandler(.success(5))
    }
fetchUnreadCount(from: "www.developer.apple.com") { result in
    switch result {
    case .success(let count):
        print("\(count) unread message")
    case .failure(let error):
        print(error.localizedDescription)
    }

}

fetchUnreadCount(from: "www.Apple.com") { result in
    if let count = try? result.get() {
        print("\(count) unread messages")
    }
}


//Nested oprtionals falttened to become regular optionals
// works similar to conditional chaining and typecast
struct User {
    var id: Int
    init?(id: Int) { // failable init
        if id < 1 {
            return nil
        }
        self.id = id
        
    }
    func getMessages() throws -> String {
        return "No messages"
    }
}
let user = User(id: 1)
let messages = try? user?.getMessages() // Nested Optional
//can use optional chaining many times in a single line of code  but wont end up with nested optionals
// while using optional chaining with as? also leads to  one level optionality



// Raw Strings
//  \ and " are treated as literal symbols rather than eascape characters or String terminators
// helps regular expressions
// put one or  more # or $ before string

let rain = #"She "sells" sea "shells" on the sea shore."#
let keypath = #" Swift Keypaths such as \Person.name hold uninvoked refrences to properties."#

let answer = 32
let dontPanic = #"The answer to life is \#(answer)."#
// add the extra # for string interpolation
