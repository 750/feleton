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
  
    @Default(.url) var url_raw

    func prepareRequest() -> URLRequest {
//        print(url_raw)
      var url: URL
        if let url_: URL = URL(string: (url_raw.isEmpty ? "http://ya.ru" : url_raw)) {
          url = url_
        } else {
          url = URL(string: "http://ya.ru")!
        }
        let clipboard = NSPasteboard.general.string(forType: .string)
//        print(url)
      
        if Defaults[.sendClipboard] {
          url.append(queryItems: [URLQueryItem(name: "clipboard", value: clipboard)])
        }
        
        let request: URLRequest = URLRequest(url: url)
        return request
    }

  
    func makeNSView(context: Context) -> WKWebView {
        print("created ")
        view.load(prepareRequest())
        return view
    }

  func updateNSView(_ view: WKWebView, context: Context) {
      print("updated ")
      view.load(prepareRequest())
    }
  
    func reload() {
      print("reload")
      view.load(prepareRequest())
//      self.updateNSView(view, nil)
//      self.view.reload()
    }

}


struct ContentView: View {
    
  let iframe = WebView()
  
  func reload() {
    iframe.reload()
  }
  
  var body: some View {
    ZStack {
      iframe
      Button(action: {iframe.reload()}, label: { Text("CheckNow") })
        .frame(width: 0, height: 0).opacity(0).hidden()
        .keyboardShortcut(KeyboardShortcut("r", modifiers: .command))
      
    }}

}
