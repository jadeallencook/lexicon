//
//  LexiconWidgetLiveActivity.swift
//  LexiconWidget
//
//  Created by Jade Allen Cook on 9/6/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LexiconWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct LexiconWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LexiconWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension LexiconWidgetAttributes {
    fileprivate static var preview: LexiconWidgetAttributes {
        LexiconWidgetAttributes(name: "World")
    }
}

extension LexiconWidgetAttributes.ContentState {
    fileprivate static var smiley: LexiconWidgetAttributes.ContentState {
        LexiconWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: LexiconWidgetAttributes.ContentState {
         LexiconWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: LexiconWidgetAttributes.preview) {
   LexiconWidgetLiveActivity()
} contentStates: {
    LexiconWidgetAttributes.ContentState.smiley
    LexiconWidgetAttributes.ContentState.starEyes
}
