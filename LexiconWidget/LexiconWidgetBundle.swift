//
//  LexiconWidgetBundle.swift
//  LexiconWidget
//
//  Created by Jade Allen Cook on 9/6/25.
//

import WidgetKit
import SwiftUI

@main
struct LexiconWidgetBundle: WidgetBundle {
    var body: some Widget {
        LexiconWidget()
        LexiconWidgetControl()
        LexiconWidgetLiveActivity()
    }
}
