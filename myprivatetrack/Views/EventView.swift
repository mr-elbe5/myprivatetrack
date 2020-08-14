//
//  EventView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 04.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import SwiftUI

struct EventView: View {
    
    @EnvironmentObject var settings: Settings
    
    var event: EventData
    
    var body: some View {
        
        VStack{
            Text("event \(String.getDateTimeString(date: event.eventDate!))")
        }.navigationBarTitle("event", displayMode: .inline)
    }
    
}

struct EventView_Previews: PreviewProvider {
    @State static var event = EventData()
    static var previews: some View {
        EventView(event: event)
    }
}
