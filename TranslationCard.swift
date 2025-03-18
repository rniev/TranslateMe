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

struct TranslationCard: View {
    
    @State private var textToBeTranslated = "Hi"
    @State private var translation = "Bonjour"
    @State private var selectedLanguage = "French"
    
    // Add property to hold the SavedTranslation
    let savedTranslation: SavedTranslation
    
    // Add an initializer to accept a SavedTranslation
    init(savedTranslation: SavedTranslation) {
        self.savedTranslation = savedTranslation
    }
    
    
    var body: some View {
        
        VStack {
            HStack {                            // <-- contains the text and the check
                Text("English")
                
                Image(systemName: "arrow.right")
                
                Text(savedTranslation.selectedLanguage)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.blue)
            .font(.system(size: 12))
            .padding(.bottom, 5)
         
            
            Text(savedTranslation.textToBeTranslated)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider() // Add a line between the texts
            
            Text(savedTranslation.translation)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .padding()
        .font(.system(size: 16))
        .frame(width: 370)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(10)
        
     
    }
}

#Preview {
    TranslationCard(savedTranslation: SavedTranslation(selectedLanguage: "French", textToBeTranslated: "Hi", translation: "Bonjour"))
}
