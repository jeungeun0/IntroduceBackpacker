//
//  Model.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/13.
//

import Foundation
import UIKit

struct Response: Codable {
    let resultCount: Int
    let results: [Datums]
    
    struct Datums: Codable {
        let ipadScreenshotUrls: [String]
        let appletvScreenshotUrls: [String]
        let advisories: [String]
        let features: [String]
        let supportedDevices: [String]
        let kind: String
        let artworkUrl60: String
        let artworkUrl512: String
        let artworkUrl100: String
        let artistViewUrl: String
        let screenshotUrls: [String]
        let isGameCenterEnabled: Bool
        let currency: String
        let currentVersionReleaseDate: String
        let releaseNotes: String
        let releaseDate: String
        let description: String
        let genreIds: [String]
        let primaryGenreName: String
        let primaryGenreId: Int
        let bundleId: String
        let sellerName: String
        let trackId: Int
        let trackName: String
        let version: String
        let wrapperType: String
        let trackViewUrl: String
        let minimumOsVersion: String
        let trackCensoredName: String
        let languageCodesISO2A: [String]
        let fileSizeBytes: String
        let formattedPrice: String
        let contentAdvisoryRating: String
        let averageUserRatingForCurrentVersion: Double
        let userRatingCountForCurrentVersion: Int
        let averageUserRating: Double
        let trackContentRating: String
        let isVppDeviceBasedLicensingEnabled: Bool
        let artistId: Int
        let artistName: String
        let genres: [String]
        let price: CGFloat
        let userRatingCount: Int
        var sellerUrl: String?
    }
}

enum Language: String {
    case ko
    case el
    case nl
    case no
    case da
    case de
    case ru
    case ro
    case ms
    case vi
    case sv
    case es
    case sk
    case ar
    case en
    case uk
    case it
    case id
    case ja
    case zh
    case cs
    case ca
    case hr
    case th
    case tr
    case pt
    case pl
    case fr
    case fi
    case hu
    case he
    case hi
    
    
    func getLanguageString() -> String {
        switch self {
        case .ko: return "한국어"
        case .el: return "그리스어"
        case .nl: return "네덜란드어"
        case .no: return "노르웨이어"
        case .da: return "덴마크어"
        case .de: return "독일어"
        case .ru: return "러시아어"
        case .ro: return "루마니아어"
        case .ms: return "말레이어"
        case .vi: return "베트남어"
        case .sv: return "스웨덴어"
        case .es: return "스페인어"
        case .sk: return "슬로바키아어"
        case .ar: return "아랍어"
        case .en: return "영어"
        case .uk: return "우크라이나어"
        case .it: return "이탈리아어"
        case .id: return "인도네시아어"
        case .ja: return "일본어"
        case .zh: return "중국어"
        case .cs: return "체코어"
        case .ca: return "카탈로니아어"
        case .hr: return "크로아티아어"
        case .th: return "태국어"
        case .tr: return "터키어"
        case .pt: return "포르투갈어"
        case .pl: return "폴란드어"
        case .fr: return "프랑스어"
        case .fi: return "핀란드어"
        case .hu: return "헝가리어"
        case .he: return "히브리어"
        case .hi: return "힌디어"
        }
    }
    
    static func getLanguageCode(_ with: String) -> LanguageString? {
        return LanguageString.init(rawValue: with)
    }
}

enum LanguageString: String {
    case ko = "한국어"
    case el = "그리스어"
    case nl = "네덜란드어"
    case no = "노르웨이어"
    case da = "덴마크어"
    case de = "독일어"
    case ru = "러시아어"
    case ro = "루마니아어"
    case ms = "말레이어"
    case vi = "베트남어"
    case sv = "스웨덴어"
    case es = "스페인어"
    case sk = "슬로바키아어"
    case ar = "아랍어"
    case en = "영어"
    case uk = "우크라이나어"
    case it = "이탈리아어"
    case id = "인도네시아어"
    case ja = "일본어"
    case zh = "중국어"
    case cs = "체코어"
    case ca = "카탈로니아어"
    case hr = "크로아티아어"
    case th = "태국어"
    case tr = "터키어"
    case pt = "포르투갈어"
    case pl = "폴란드어"
    case fr = "프랑스어"
    case fi = "핀란드어"
    case hu = "헝가리어"
    case he = "히브리어"
    case hi = "힌디어"
    
}
