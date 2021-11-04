import SwiftUI

// let markdown = "_Hamlet_ by **William Shakespeare**"

extension AttributedString {
    mutating func style(
        text: String,
        configure: (inout AttributedSubstring) -> Void
    ) {
        if let range = self.range(of: text) {
            configure(&self[range])
        }
    }
}

extension Text {
    init(_ string: String, configure: (inout AttributedString) -> Void) {
        var attributedString = AttributedString(string)
        configure(&attributedString) // configure using the closure
        self.init(attributedString) // create a `Text`
    }
}

struct ContentView: View {
    /*
     let attributedString =
         try! AttributedString(markdown: markdown)
     */

    // Using extension to AttributedString
    var demo: AttributedString {
        var s = AttributedString("Red Green Blue")
        s.style(text: "Red") {
            $0.foregroundColor = .red
        }
        s.style(text: "Green") {
            $0.foregroundColor = .green
        }
        s.style(text: "Blue") {
            $0.foregroundColor = .blue
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
