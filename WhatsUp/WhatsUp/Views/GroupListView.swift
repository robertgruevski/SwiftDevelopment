//
//  GroupListView.swift
//  WhatsUp
//
//  Created by Robert Gruevski on 10/11/25.
//

import SwiftUI

struct GroupListView: View {
    
    let groups: [Group]
    
    var body: some View {
        List(groups) { group in
            NavigationLink {
                GroupDetailView(group: group)
            } label: {
                HStack {
                    Image(systemName: "person.2")
                    Text(group.subject)
                }
            }
        }
    }
}

#Preview {
    GroupListView(groups: [])
}
