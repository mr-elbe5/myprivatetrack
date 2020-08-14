//
//  MainTabView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 05.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import SwiftUI

enum ViewTag{
    case events, map, settings, info
}

struct MainTabView: View {
    
    @State private var currentTab = ViewTag.events
    
    var body: some View {
        TabView(selection: $currentTab){
            MainView(currentTab: $currentTab)
                .tabItem{
                    VStack {
                        Image(systemName: "rectangle.stack")
                        Text("events")
                    }
            }.tag(ViewTag.events)
            MapView(currentTab: $currentTab)
                .tabItem{
                    VStack {
                        Image(systemName: "globe")
                        Text("map")
                    }
            }.tag(ViewTag.map)
            SettingsView(currentTab: $currentTab)
                .tabItem{
                    VStack {
                        Image(systemName: "slider.horizontal.3")
                        Text("settings")
                    }
            }.tag(ViewTag.settings)
            InfoView(currentTab: $currentTab)
                .tabItem{
                    VStack {
                        Image(systemName: "info")
                        Text("info")
                    }
            }.tag(ViewTag.info)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

