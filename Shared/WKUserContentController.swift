import WebKit
import Sleuth

extension WKUserContentController {
    private static var _cookies: WKContentRuleList?
    private static var _ads: WKContentRuleList?
    private static var _blockers: WKContentRuleList?
    private static var _dark: WKContentRuleList?
    private static var _secure: WKContentRuleList?
    
    func cookies() {
        if let _cookies = Self._cookies {
            add(_cookies)
        } else {
            WKContentRuleListStore.default()!.compileContentRuleList(forIdentifier: "cookies", encodedContentRuleList: Block.cookies) { [weak self] list, _ in
                self?.add(list!)
                Self._cookies = list!
            }
        }
    }
    
    func ads() {
        let a = """
[
    {
        "trigger": {
            "url-filter": "^https?://+([^:/]+\\\\.)?google\\\\.com[:/]",
            "url-filter-is-case-sensitive": true,
            "if-domain": ["*google.com"],
            "resource-type": ["document"],
            "load-type": ["first-party"]
        },
        "action": {
            "type": "css-display-none",
            "selector": "#taw, #rhs, #tadsb, .commercial, .Rn1jbe, .kxhcC, .isv-r.PNCib.BC7Tfc, .isv-r.PNCib.o05QGe"
        }
    }
]
"""
        if let _ads = Self._ads {
            add(_ads)
        } else {
            WKContentRuleListStore.default()!.compileContentRuleList(forIdentifier: "ads", encodedContentRuleList: a) { [weak self] list, _ in
                self?.add(list!)
                Self._ads = list!
            }
        }
    }
    
    func blockers() {
        if let _blockers = Self._blockers {
            add(_blockers)
        } else {
            WKContentRuleListStore.default()!.compileContentRuleList(forIdentifier: "blockers", encodedContentRuleList: Block.blockers) { [weak self] list, _ in
                self?.add(list!)
                Self._blockers = list!
            }
        }
        
        addUserScript(.init(source: Scripts.scroll, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
    }
    
    func dark() {
        if let _dark = Self._dark {
            add(_dark)
        } else {
            WKContentRuleListStore.default()!.compileContentRuleList(forIdentifier: "dark", encodedContentRuleList: Block.dark) { [weak self] list, _ in
                self?.add(list!)
                Self._dark = list!
            }
        }
        
        addUserScript(.init(source: Scripts.dark, injectionTime: .atDocumentStart, forMainFrameOnly: true))
    }
    
    func secure() {
        if let _secure = Self._secure {
            add(_secure)
        } else {
            WKContentRuleListStore.default()!.compileContentRuleList(forIdentifier: "secure", encodedContentRuleList: Block.secure) { [weak self] list, _ in
                self?.add(list!)
                Self._secure = list!
            }
        }
    }
    
    func location() {
        addUserScript(.init(source: Scripts.location, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
    }
}
