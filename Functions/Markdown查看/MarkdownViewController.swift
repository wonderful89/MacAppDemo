//
//  MarkdownViewController.swift
//  FirstMac
//
//  Created by qianzhao on 2020/3/10.
//  Copyright © 2020 qianzhao. All rights reserved.
//

import Cocoa
import WebKit
import cmark_gfm_swift

@objc class MarkdownViewController: NSViewController, WKNavigationDelegate {
    
    @objc public var contentStr: String?
    
    @IBOutlet weak var webPreview: WKWebView!
    /// The current directory that external assets can load from
    private var permissionDirectory: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        webPreview.navigationDelegate = self
        webPreview.setValue(false, forKey: "drawsBackground")
        webPreview.wantsLayer = true;
        webPreview.layer?.backgroundColor = NSColor.black.cgColor
        
        
        let markdownTextString = contentStr!;
        let markdownText = markdownTextString.replacingOccurrences(of: "\\", with: "\\\\")
        DispatchQueue.global(qos: .userInitiated).async {
          if let parsed = Node(
            markdown: markdownText,
            options: preferences.markdownOptions,
            extensions: preferences.markdownExtensions
          )?.html {
            DispatchQueue.main.async {
              self.captureScroll {
//                let doc = self.windowController?.document as? Document
//                let fileURL = doc?.fileURL ?? URL(fileURLWithPath: "/")

                let styledHTML = html.getHTML(
                  with: parsed
//                  direction: self.markdownTextView.baseWritingDirection
                )
//                self.setPermissions(for: fileURL)
                self.setContent(with: styledHTML)
              }
            }
          }
        }
        
//        let url:URL = URL(string: "https://baidu.com")!
//        webPreview.load(URLRequest(url: url))
        
        #if DEBUG
        // When developing we want to be able to inspect element in the preview
        webPreview.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        #endif
    }
    
    /// A closure that returns the y scoll position of the webview
    public func captureScroll(completion: @escaping () -> Void) {
        webPreview.evaluateJavaScript("window.scrollY;") { (response, err) in
            if let pos = response as? Int {
                html.y = pos
                completion()
            }
        }
    }
    
    public func scrollTo(percentage: Float) {
        let jsString = """
        var height = document.body.clientHeight - window.innerHeight + 30;
        window.scrollTo(0, height * \(percentage));
        """
        
        webPreview.evaluateJavaScript(jsString)
    }
    
    /// Set the content of the preview to a HTML string
    public func setContent(with html: String) {
        self.webPreview.loadHTMLString(html, baseURL: self.permissionDirectory ?? nil)
    }
    
    /// Set the permissions of the preview for a given file
    public func setPermissions(for url: URL) {
        let base = url.deletingLastPathComponent().standardizedFileURL
        
        // If same permissions directory return early,
        // we don't want to load another request if we don't have to
        if base == self.permissionDirectory {
            return
        }
        
        // Set permissions directory
        self.permissionDirectory = base
        self.webPreview.load(URLRequest(url: url))
    }
    
    // Handle when a link is clicked
    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let url = navigationAction.request.url else { return }
        
        let urlString = url.absoluteString
        
        if urlString.isWebLink {
            decisionHandler(.cancel)
//            NSWorkspace.shared.open(url)
        } else if urlString.isMarkdown {
            decisionHandler(.cancel)
            print("openMarkdownFile")
            //      (NSDocumentController.shared as? NSDocumentController)?.openMarkdownFile(withContentsOf: url)
        } else {
            decisionHandler(.allow)
        }
    }
    
}
