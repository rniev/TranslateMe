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
import FirebaseFirestore // <-- Import Firestore framework
import FirebaseFirestoreSwift // <-- Import additional FirebaseSwift framework


struct TranslationsView: View {
    
    let db = Firestore.firestore()
    
    @State var savedTranslations: [SavedTranslation] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(savedTranslations, id: \.self) { translation in
                    TranslationCard(savedTranslation: translation)
                }
            }
            .padding()
        }
        .onAppear {
                // Fetch data from Firestore when the view appears
                fetchSavedTranslations()
            }
        
        
        // Clear All Translations button
        Button(action: {
                    savedTranslations.removeAll()  // Clear all translations
                    deleteAllTranslations()        // Delete all translations from Firestore
                }) {
                    Text("Clear All Translations")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
        }
    
    // fetches translations from Firestore
    private func fetchSavedTranslations() {
        // Access the `translations` collection group on Firestore
        db.collection("translations").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }
            
            // debugging
            print("Fetched \(documents.count) documents")
            
            // Map Firestore documents to SavedTranslations objects
            let savedTranslations = documents.compactMap { document in
                do {
                    // Decode translation document to the SavedTranslation model
                    return try document.data(as: SavedTranslation.self)
                } catch {
                    print("Error decoding document into translation: \(error)")
                    return nil
                }
                
            }
            
            // debugging
            print("Decoded \(savedTranslations.count) translations")
            
            //  Update the savedTranslations property with fetched translations
             self.savedTranslations = savedTranslations
            
        }
    }
    
    // Function to delete all translations from Firestore
    private func deleteAllTranslations() {
        // Access the `translations` collection group on Firestore
        db.collection("translations").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            // Check if there are any documents to delete
            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }
            
            // Iterate over each document and delete it
            for document in documents {
                // Delete the document from Firestore
                self.db.collection("translations").document(document.documentID).delete { error in
                    if let error = error {
                        print("Error deleting document: \(error)")
                    } else {
                        print("Document successfully deleted")
                    }
                }
            }
        }
    }
}

#Preview {
    TranslationsView()
}
