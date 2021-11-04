import SwiftUI

extension AttributedString {
    // Style the range occupied by a given substring using a closure.
    mutating func style(
        text: String,
        style: (inout AttributedSubstring) -> Void
    ) {
        if let range = self.range(of: text) {
            style(&self[range])
        }
    }
}

extension Text {
    // Creates a Text from a String and styles the entire value.
    init(_ string: String, style: (inout AttributedString) -> Void) {
        var attributedString = AttributedString(string)
        style(&attributedString) // style using the closure
        self.init(attributedString) // create a `Text`
    }
}

struct ContentView: View {
    @Environment(\.font) var font // default font
    
    // Using extension to AttributedString
    var demo: AttributedString {
        var s = AttributedString("Red Green Blue")
        s.style(text: "Red") {
            $0.foregroundColor = .red
            $0.font = .body.italic() // italic version of body font
        }
        s.style(text: "Green") {
            $0.foregroundColor = .green
        }
        s.style(text: "Blue") {
            $0.foregroundColor = .purple
            // Use the italic version of either the default or body font.
            $0.font = (font ?? .body).italic()
        }
        return s
    }
    
    var body: some View {
        VStack {
            // Using built-in Markdown support
            Text("plain *italic* **bold** ~strike~ `code`, [link](https://apple.com)")
            
            // Using a computed property defined above
            Text(demo)
            
            // Concatenating Text views that each have their own styles.
            Text("Hello").foregroundColor(.red) +
                Text(", ") +
                Text("World").foregroundColor(.green) +
                Text("!")
            
            HStack {
                // Using extension to Text.
                Text("Red") {
                    $0.foregroundColor = .red
                    $0.font = Font.system(size: 24).bold().italic()
                }
                Text("Green") {
                    $0.foregroundColor = .green
                    $0.font = Font.system(size: 36, design: .monospaced)
                }
                Text("Blue") {
                    $0.foregroundColor = .blue
                    $0.underlineColor = .green // doesn't work
                }
            }
            
            // Using extension to Text.
            Text("Apple") {
                $0.link = URL(string: "https://apple.com")
                $0.underlineColor = .blue // doesn't work
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
