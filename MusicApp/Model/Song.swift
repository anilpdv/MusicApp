
import Foundation

struct Song: Decodable {
    let tracks: Tracks
}

struct Tracks: Decodable {
    let href: String
    let items: [Track]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}

struct Track: Decodable {
    let album: Album
    let artists: [Artist]
    let availableMarkets: [String]
    let discNumber: Int
    let durationMs: Int
    let explicit: Bool
    let externalIds: ExternalIds
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let isLocal: Bool
    let name: String
    let popularity: Int
    let previewUrl: String?
    let trackNumber: Int
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case album
        case artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case explicit
        case externalIds = "external_ids"
        case externalUrls = "external_urls"
        case href
        case id
        case isLocal = "is_local"
        case name
        case popularity
        case previewUrl = "preview_url"
        case trackNumber = "track_number"
        case type
        case uri
    }
}

struct Album: Decodable {
    let albumType: String
    let artists: [Artist]
    let availableMarkets: [String]
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let images: [ImageUrl]
    let name: String
    let releaseDate: String
    let releaseDatePrecision: String
    let totalTracks: Int
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href
        case id
        case images
        case name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type
        case uri
    }
}

struct Artist: Decodable {
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let name: String
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href
        case id
        case name
        case type
        case uri
    }
}

struct ImageUrl: Decodable {
    let height: Int
    let url: String
    let width: Int
}

struct ExternalIds: Decodable {
    let isrc: String
}

struct ExternalUrls: Decodable {
    let spotify: String
}

struct RelatedSongs: Decodable {
    let tracks: [Track]
}
