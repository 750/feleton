//
//  ContentView.swift
//  feleton
//
//  Created by jarvis-hmac on 16.03.2025.
//

import SwiftUI
import SwiftData
import WebKit
import Defaults

struct WebView: NSViewRepresentable {

    let view: WKWebView = WKWebView()
  
    var url_raw: String;

    var request: URLRequest {
        get{
            var url: URL = URL(string: url_raw)!
            
          let clipboard = NSPasteboard.general.string(forType: .string)
          
            url.append(queryItems: [URLQueryItem(name: "clipboard", value: clipboard)])
            
          
            url.append(queryItems: [URLQueryItem(name: "clipboard", value: "soccer")])
            print(url_raw)
            let request: URLRequest = URLRequest(url: url)
            return request
        }
    }

    func makeNSView(context: Context) -> WKWebView {
        view.load(request)
        return view
    }

    func updateNSView(_ view: WKWebView, context: Context) {
        view.load(request)
      
    }
  
  func reload() {
    self.view.reload()
  }
  
    

}


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
  let iframe = WebView(url_raw: Defaults[.url] )
  
  var body: some View {
    ZStack {
      iframe
      Button(action: {iframe.reload()}, label: { Text("CheckNow") })
        .frame(width: 0, height: 0).opacity(0).hidden()
        .keyboardShortcut(KeyboardShortcut("r", modifiers: .command))
    }}

}
