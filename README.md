MacOS app to turn a webpage into a native accessory app. Basically a WKWebView wrapper for a url.

App visibility is toggled with a shortcut

App always resides in menubar. Menubar item contains a user-defined text.

Page reload triggers on cmd+r, esc/enter cause the app to hide

WKWebViewSafari/WebKit/WKWebView do not allow clipboard reading without Transient Action - as a workaround a `clipboard=<clipboard>` is passed in url query param (TODO make it toggleable)

Need to research custom url schemas as a way to communicate with Feleton. 
