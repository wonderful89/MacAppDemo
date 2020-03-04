//
//  WKCookieWebView.swift
//  FirstMac
//
//  Created by qianzhao on 2020/3/3.
//  Copyright © 2020 qianzhao. All rights reserved.
//

import Cocoa

import Foundation
import WebKit

@objc class WKCookieWebView : WKWebView {

    private let useRedirectCookieHandling: Bool

    @objc init(frame: CGRect, configuration: WKWebViewConfiguration, useRedirectCookieHandling: Bool = false) {
        self.useRedirectCookieHandling = useRedirectCookieHandling
        super.init(frame: frame, configuration: configuration)
    }

    required init?(coder: NSCoder) {
        self.useRedirectCookieHandling = false
        super.init(coder: coder)
    }

    override func load(_ request: URLRequest) -> WKNavigation? {
        guard useRedirectCookieHandling else {
            return super.load(request)
        }

        requestWithCookieHandling(request, success: { (newRequest , response, data) in
            DispatchQueue.main.async {
                self.syncCookiesInJS()
                if let data = data, let response = response {
                    let _ = self.webViewLoad(data: data, response: response)
                } else {
                    self.syncCookies(newRequest, nil, { (cookieRequest) in
                        let _ = super.load(cookieRequest)
                    })
                }
            }
        }, failure: {
            // let WKWebView handle the network error
            DispatchQueue.main.async {
                self.syncCookies(request, nil, { (newRequest) in
                    let _ = super.load(newRequest)
                })
            }
        })

        return nil
    }

    private func requestWithCookieHandling(_ request: URLRequest, success: @escaping (URLRequest, HTTPURLResponse?, Data?) -> Void, failure: @escaping () -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                failure()
            } else {
                if let response = response as? HTTPURLResponse {

                    let code = response.statusCode
                    if code == 200 {
                        // for code 200 return data to load data directly
                        success(request, response, data)

                    } else if code >= 300 && code <  400  {
                        // for redirect get location in header,and make a new URLRequest
                        guard let location = response.allHeaderFields["Location"] as? String, let redirectURL = URL(string: location) else {
                            failure()
                            return
                        }

                        let request = URLRequest(url: redirectURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
                        success(request, nil, nil)

                    } else {
                        success(request, response, data)
                    }
                }
            }
        }
        task.resume()
    }

    private func webViewLoad(data: Data, response: URLResponse) -> WKNavigation! {
        guard let url = response.url else {
            return nil
        }

        let encode = response.textEncodingName ?? "utf8"
        let mine = response.mimeType ?? "text/html"

        return self.load(data, mimeType: mine, characterEncodingName: encode, baseURL: url)
    }
}

extension WKCookieWebView {
    // sync HTTPCookieStorage cookies to URLRequest
    private func syncCookies(_ request: URLRequest, _ task: URLSessionTask? = nil, _ completion: @escaping (URLRequest) -> Void) {
        var request = request
        var cookiesArray = [HTTPCookie]()

        if let task = task {
            HTTPCookieStorage.shared.getCookiesFor(task, completionHandler: { (cookies) in
                if let cookies = cookies {
                    cookiesArray.append(contentsOf: cookies)

                    let cookieDict = HTTPCookie.requestHeaderFields(with: cookiesArray)
                    if let cookieStr = cookieDict["Cookie"] {
                        request.addValue(cookieStr, forHTTPHeaderField: "Cookie")
                    }
                }
                completion(request)
            })
        } else  if let url = request.url {
            if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
                cookiesArray.append(contentsOf: cookies)
            }
            let cookieDict = HTTPCookie.requestHeaderFields(with: cookiesArray)
            if let cookieStr = cookieDict["Cookie"] {
                request.addValue(cookieStr, forHTTPHeaderField: "Cookie")
            }
            completion(request)

        }
    }

    // MARK: - JS Cookie handling
    private func syncCookiesInJS(for request: URLRequest? = nil) {
        if let url = request?.url,
            let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            let script = jsCookiesString(for: cookies)
            let cookieScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            self.configuration.userContentController.addUserScript(cookieScript)

        } else if let cookies = HTTPCookieStorage.shared.cookies {
            let script = jsCookiesString(for: cookies)
            let cookieScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            self.configuration.userContentController.addUserScript(cookieScript)
        }
    }

    private func jsCookiesString(for cookies: [HTTPCookie]) -> String {
        var result = ""
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"

        for cookie in cookies {
            result += "document.cookie='\(cookie.name)=\(cookie.value); domain=\(cookie.domain); path=\(cookie.path); "
            if let date = cookie.expiresDate {
                result += "expires=\(dateFormatter.string(from: date)); "
            }
            if (cookie.isSecure) {
                result += "secure; "
            }
            result += "'; "
        }
        return result
    }
}

extension WKCookieWebView : URLSessionTaskDelegate {

    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {

        syncCookies(request) { (newRequest) in
            completionHandler(newRequest)
        }
    }
}
