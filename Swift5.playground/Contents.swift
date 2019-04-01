import UIKit

// Result type in Standard Library giving simpler and clearer way for handling complex code like asynchronous code
// Swift Result type is implemented as an enum having two cases success and failure using generics
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

fetchUnreadCount(from: "www.apple.com") { result in
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
        //complicated code
        return "No messages"
    }
}
let user = User(id: 1)
let messages = try? user?.getMessages() // Nested Optional
//try wont wrap values in an optional if already an optional
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


let str = ##"my dog said "woof"#goodDog"##
let multiline = #"""
the answer to life,
the universe,
and everything is \#(answer)
"""#

//with raw strings we can use half the back slashes
let regex = "\\\\[A-Z]+[A-Za-z]+\\.[a-z]+"
let newRegex = #"\\[A-Z]+[A-Za-z]+\[a-z]+"#


//@dynamicCallable: mark a type as directy callable
// helps swift to work with dynamic languages like paython and javascript

@dynamicCallable
struct RandomNumberGeneratorr {
    //
    func dynamicallyCall(withKewordArguments args: KeyValuePairs<String, Int>) -> Double {
        let numberOfZeros = Double(args.first?.value ?? 0)
        let maximum = pow(10, Double(numberOfZeros))
        return Double.random(in: 0...maximum) // 1zero- 1-10, 2 Zeros - 1-100
    }
    func dynamicallyCall(withArguments args: [Int]) -> Double {
        let numberOffZeros = Double(args[0])
        let maximum = pow(10, numberOffZeros)
        return Double.random(in: 0...maximum)
    }
    // if we implement only the first func the type can still be called without parameter labels but the string will be empty
}
let random = RandomNumberGeneratorr()
let result = random(0)



//Checking for integer multiples: checking one number is a multiple of another
// can be listed in co-completion code options in Xcode which aids discoverability
let rowNumber = 4

if rowNumber.isMultiple(of: 2) {
    print("Even")
} else {
    print("Odd")
}


// Improved String Interpolation
struct Users {
    var name: String
    var age: Int
}

extension String.StringInterpolation {
    mutating func apependInterpolation(_ value: Users) {
        appendInterpolation("My name is \(value.name) and i'm \(value.age)")
    }
}

let newUser = Users(name: "Johny Littlebucket", age: 19)
print("User details: \(newUser)")

// custom interpolation can take as many parameters as you can
extension String.StringInterpolation {
    mutating func appendInterpolation(_ number: Int, style: NumberFormatter.Style) {
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        
        if let result = formatter.string(from: number as NSNumber) { // reading result from formatter
            appendInterpolation(result)
        }
    }
    
}

// repeating a string value as many times
let number = Int.random(in: 0...100)
let lucky = "This weeks lucky number is \(number, style: .spellOut)"
print(lucky)

extension String.StringInterpolation {
    mutating func appendInterpolation(repeat str: String, _ count: Int) {
        for _ in 0 ..< count {
            appendInterpolation(str)
        }
    }
    
}
print("Baby shark \(repeat: "doo", 4)")


// interpolation that joins array of string together but if the array is empty excuse the closure and return the string
extension String.StringInterpolation {
    mutating func appendInterpolation(_ values: [String], empty defaultValue: @autoclosure() -> String) {
        //@autoclosure() means use simple values like no one or complex values but none can be done as values.count = 0
        
        if values.count == 0 {
            appendInterpolation(defaultValue())
        } else {
            appendInterpolation(values.joined(separator: ", "))
        }
    }
}
let names = ["Harry, Ron, Hermoine"]
print("List of students: \(names, empty: "No one").")
// for really big code use express by string literal and express by string interpolation to create whole new types using string interpolation and adding custom string convertable we can make those types print strings however we want to.


struct HTMLComponent: ExpressibleByStringLiteral, ExpressibleByStringInterpolation, CustomStringConvertible {
    var description: String
    
    
    struct StringInterpolation: StringInterpolationProtocol {
        var Output = ""
        
        //allocate enough space to hold twicw the amaount of literal text
        init(literalCapacity: Int, interpolationCount: Int) {
            Output.reserveCapacity(literalCapacity * 2)
        }
        // hard coded text
        mutating func appendLiteral(_ literal: String) {
            print("Appending \(literal)")
            Output.append(literal)
        }
        // a Twitter username - add it as a link
        mutating func appendInterpolation(twitter: String) {
            print("Appending \(twitter)")
            Output.append("<a href=\"http://twitter.com/\(twitter)\">@\(twitter)</a>")
        }
        
        //an email address - add using mailto:
        mutating func appendInterpolation(email: String) {
            print("Appending \(email)")
            Output.append("<a href=\"mailto:\(email)\">(email)</a>")
        }
    }
    //the finished text  for the whole component
    //    let descriPtion: String
    
    //create instance from literal string
    init(stringLiteral value: String) {
        description = value
    }
    //create instance from interpolated string
    init(stringInterpolation: StringInterpolation) {
        description = stringInterpolation.Output
    }
    
}
let text: HTMLComponent = "You should follow me on Twitter \(twitter: "@guggusharma")), or you can email me at \(email: "ramitsharma991@gmail.com")."
print(text)





//compacti dictionary  values : compact map functionality
let times = [
    "Coady": "34",
    "Jonah": "42",
    "Dilbert": "35",
    "Billy": "DNF"
]

let finishers1 = times.compactMapValues { Int($0) }
let finishers2 = times.compactMapValues(Int.init)

let people = [
    "Richie": "29",
    "Sam": "7",
    "enigo": "6",
    "barry": nil
]
let knownAges = people.compactMapValues { $0 }



// Non-exhaustive enums

enum PasswordError: Error {
    case short
    case obvious
    case simple
}

func showOld(error: PasswordError) {
    switch error {
    case .short:
        print("Your password was too short.")
    case .obvious:
        print("Your password was too simple.")
    @unknown default:
        print("Your password wasn't suitable.")
    }
}

