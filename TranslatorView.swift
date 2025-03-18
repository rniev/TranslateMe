//=============================================================================
// PROGRAMMER: Rafael Nieves
// PANTHER ID: 6326371
//
// CLASS: COP4655
// SECTION: RTEA RVC 1251
// SEMESTER: The current semester: Spring 2025
// CLASSTIME: Your COP4655 course meeting time :Online
//
// Assignment: Project 6
// DUE: 17 MAR 2025
//
// CERTIFICATION: I certify that this work is my own and that
// none of it is the work of any other person.
//=============================================================================

import SwiftUI
import Firebase
import FirebaseFirestore  // Import FirebaseFirestore

struct TranslatorView: View {
    
    @State private var textToBeTranslated = ""
    @State private var translation = ""
    @State private var selectedLanguage = "French"
    
    // Firestore instance
    let db = Firestore.firestore()
    
    // string keys representing the language codes and string values representing the corresponding language names
    let languageDictionary: [String: String] = [
        "fr": "French",
        "es": "Spanish",
        "de": "German",
        "it": "Italian",
        "ar": "Arabic",
        "zh-CN": "Chinese (simplified)"
    ]
    
    
    var body: some View {
        
        NavigationView {
            // Target language selection
            VStack {
                Menu {
                    ForEach(languageDictionary.values.sorted(), id: \.self) { language in
                        
                        Button(action: {
                            selectedLanguage = language
                            
                            print("Selected language: \(language)")
                        }) {
                            Text(language)
                        }
                    }
                } label : {
                    HStack {                            // <-- Displays the selected language next to globe icon
                         Image(systemName: "globe")
                             .font(.system(size: 24))
                         Text(selectedLanguage)
                     }
                }
                    
                    
                // TextField for user input
                TextField("Enter text", text: $textToBeTranslated)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                
                // Button to perform translation
                Button(action: {
                    Task {
                        await fetchTranslation()
                        
                        // After translation is fetched, save to Firestore
                        await saveTranslationToFirestore()
                    }
                }) {
                    Text("Translate")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8.0)
                }
                
                // Label to display the translated text
                VStack(alignment: .center) {
                    Text(translation)
                        .padding()
                        .frame(width: 370, height: 300)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(8.0)
                        .font(.system(size: 30))
                        .bold()
                        .opacity(translation.isEmpty ? 0 : 1) // Hide text when translation is empty
                        .animation(.easeInOut(duration: 0.5)) // Add fade animation
                    
            
                    }
                
                // Button to view saved translations
                NavigationLink(destination: TranslationsView()) {
                    Text("View Saved Translations")
                        .padding()
                
                }
        }
            .navigationTitle("Translate Me")
        }
        
        
        
    }
    
    // fetches the text translation from the MyMemoryAPI
    private func fetchTranslation() async {
        // API endpoint parameters
        let targetLang = findLanguageCode()
        let textToBeTranslated = textToBeTranslated
        
        // URL for API Endpoint
        let url = URL(string: "https://api.mymemory.translated.net/get?q=\(textToBeTranslated)&langpair=en|\(targetLang)")!
        
        // wrap in do-catch block since URL session can throw errors
        do {
            let (data, _ ) = try await URLSession.shared.data(from: url)
            
            // Decode JSON data into MyMemoryAPIResponse type
            let translationResponse = try JSONDecoder().decode(MyMemoryAPIResponse.self, from: data)
            
            // get the translated text from the response
            let translation = translationResponse.responseData.translatedText
            
            // set the translation state property
            self.translation = translation
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // finds the language code for the selected language
    private func findLanguageCode() -> String {
        if let langCode = languageDictionary.first(where: { $0.value == selectedLanguage })?.key {
            return langCode
        } else {
            return "fr"     // default target language is "fr" for French
        }
    }
    
    // saves translation to Firestore
    private func saveTranslationToFirestore() async {
        do {
                 let data: [String: Any] = [
                     "selectedLanguage": selectedLanguage,
                     "textToBeTranslated": textToBeTranslated,
                     "translation": translation,
                     "createdAt ": Date()
                 ]
                 
                 // Add a new document with a generated ID
                 _ = try await db.collection("translations").addDocument(data: data)
                 print("Translation saved to Firestore")
             } catch {
                 print("Error saving translation to Firestore: \(error)")
             }
    }
}

#Preview {
    TranslatorView()
}
