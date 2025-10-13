//
//  Model.swift
//  WhatsUp
//
//  Created by Robert Gruevski on 10/11/25.
//

import FirebaseAuth
import Combine
import FirebaseFirestore

@MainActor
class Model: ObservableObject {
    
    @Published var displayName: String = ""
    @Published var groups: [Group] = []
    @Published var chatMessages: [ChatMessage] = []
    
    var firestoreListener: ListenerRegistration?
    
    private func updateUserInfoForAllMessages(uid: String, updatedInfo: [AnyHashable: Any]) async throws {
        
        let db = Firestore.firestore()
        let groupDocuments = try await db.collection("groups").getDocuments().documents
        
        for groupDoc in groupDocuments {
            let messages = try await groupDoc.reference.collection("messages")
                .whereField("uid", isEqualTo: uid)
                .getDocuments().documents
            
            for message in messages {
                try await message.reference.updateData(updatedInfo)
            }
        }
    }
    
    func updateDisplayName(for user: User, displayName: String) async throws {
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        try await request.commitChanges()
        try await updateUserInfoForAllMessages(uid: user.uid, updatedInfo: ["displayName": user.displayName ?? "Guest"])
    }
    
    func detachFirebaseListener() {
        self.firestoreListener?.remove()
    }
    
    func updatePhotoUrl(for user: User, photoUrl: URL) async throws {
        
        let request = user.createProfileChangeRequest()
        request.photoURL = photoUrl
        try await request.commitChanges()
        
        // update UserInf for all messages
        try await updateUserInfoForAllMessages(uid: user.uid, updatedInfo: ["photoPhotoURL": photoUrl.absoluteString])
    }
    
    func listenForChatMessages(in group: Group) {
        
        let db = Firestore.firestore()
        chatMessages.removeAll()
        
        guard let documentId = group.documentId else { return }
        
        self.firestoreListener = db.collection("groups")
            .document(documentId)
            .collection("messages")
            .order(by: "dateCreated", descending: false)
            .addSnapshotListener({ [weak self] snapshot, error in
                guard let snapshot = snapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                
                snapshot.documentChanges.forEach { diff in
                    if diff.type == .added {
                        let chatMessage = ChatMessage.fromSnapshot(snapshot: diff.document)
                        
                        if let chatMessage {
                            let exists = self?.chatMessages.contains(where: { cm in
                                cm.documentId == chatMessage.documentId
                            })
                            
                            if !exists! {
                                self?.chatMessages.append(chatMessage)
                            }
                        }
                    }
                }
            })
    }
    
    func populateGroups() async throws {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("groups")
            .getDocuments()
        
        groups = snapshot.documents.compactMap { snapshot in
            Group.fromSnapshot(snapshot: snapshot)
        }
    }
    
    func saveChatMessageToGroup(chatMessage: ChatMessage, group: Group) async throws {
        
        let db = Firestore.firestore()
        guard let groupDocumentId = group.documentId else { return }
        let _ = try await db.collection("groups")
            .document(groupDocumentId)
            .collection("messages")
            .addDocument(data: chatMessage.toDictionary())
    }
    
    /*
    func saveChatMessageToGroup(text: String, group: Group, completion: @escaping (Error?) -> Void) {
        
        
        db.collection("groups")
            .document(groupDocumentId)
            .collection("messages")
            .addDocument(data: ["chatText": text]) { error in
                completion(error)
            }
    }*/
    
    func saveGroup(group: Group, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        var docRef: DocumentReference? = nil
        docRef = db.collection("groups")
            .addDocument(data: group.toDictionary()) { [weak self] error in
                if error != nil {
                    completion(error)
                } else {
                    if let docRef {
                        var newGroup = group
                        newGroup.documentId = docRef.documentID
                        self?.groups.append(newGroup)
                        completion(nil)
                    } else {
                        completion(nil)
                    }
                }
            }
    }
    
}
