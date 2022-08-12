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
