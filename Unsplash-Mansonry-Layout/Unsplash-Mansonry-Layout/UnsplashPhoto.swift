//
//  UnsplashPhoto.swift
//  Unsplash-Mansonry-Layout
//
//  Created by Aitor Pagán on 24/10/24.
//

import Foundation

enum UnsplashPhoto {
    struct Photo: Decodable {
        let id: String
        let slug: String?
        let alternativeSlugs: [String: String]?
        let createdAt: String
        let updatedAt: String
        let promotedAt: String?
        let width: Int
        let height: Int
        let color: String
        let blurHash: String?
        let description: String?
        let altDescription: String?
        let assetType: String?
        let publicDomain: Bool?
        let tags: [Tag]?
        let urls: Urls
        let links: Links
        let likes: Int
        let likedByUser: Bool
        let currentUserCollections: [Collection]
        let user: User
        let exif: Exif
        let location: Location?
        let topicSubmissions: TopicSubmissions?
        let sponsorship: Sponsorship?
        let views: Int?
        let downloads: Int?
        
        enum CodingKeys: String, CodingKey {
            case id
            case slug
            case alternativeSlugs = "alternative_slugs"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case promotedAt = "promoted_at"
            case width
            case height
            case color
            case blurHash = "blur_hash"
            case description
            case altDescription = "alt_description"
            case assetType = "asset_type"
            case publicDomain = "public_domain"
            case tags
            case urls
            case links
            case likes
            case likedByUser = "liked_by_user"
            case currentUserCollections = "current_user_collections"
            case user
            case exif
            case location
            case topicSubmissions = "topic_submissions"
            case sponsorship
            case views
            case downloads
        }
    }

    struct Tag: Decodable {
        let type: String
        let title: String
    }

    struct Sponsorship: Decodable {
        let sponsor: User?
    }

    struct TopicSubmissions: Decodable {
        let people: SubmissionStatus?
        let fashionBeauty: SubmissionStatus?
        
        enum CodingKeys: String, CodingKey {
            case people
            case fashionBeauty = "fashion-beauty"
        }
    }

    struct SubmissionStatus: Decodable {
        let status: String
        let approvedOn: String?
        
        enum CodingKeys: String, CodingKey {
            case status
            case approvedOn = "approved_on"
        }
    }


    struct Exif: Decodable {
        let make: String?
        let model: String?
        let exposureTime: String?
        let aperture: String?
        let focalLength: String?
        let iso: Int?

        enum CodingKeys: String, CodingKey {
            case make
            case model
            case exposureTime = "exposure_time"
            case aperture
            case focalLength = "focal_length"
            case iso
        }
    }

    struct Location: Decodable {
        let name: String?
        let city: String?
        let country: String?
        let position: Position?
    }

    struct Position: Decodable {
        let latitude: Double?
        let longitude: Double?
    }

    struct Collection: Decodable {
        let id: Int
        let title: String
        let publishedAt: String
        let lastCollectedAt: String
        let updatedAt: String
        let coverPhoto: String?
        let user: String?

        enum CodingKeys: String, CodingKey {
            case id
            case title
            case publishedAt = "published_at"
            case lastCollectedAt = "last_collected_at"
            case updatedAt = "updated_at"
            case coverPhoto = "cover_photo"
            case user
        }
    }

    struct Urls: Decodable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }

    struct Links: Decodable {
        let selfLink: String
        let html: String
        let download: String
        let downloadLocation: String

        enum CodingKeys: String, CodingKey {
            case selfLink = "self"
            case html
            case download
            case downloadLocation = "download_location"
        }
    }

    struct User: Decodable {
        let id: String
        let updatedAt: String
        let username: String
        let name: String
        let portfolioUrl: String?
        let bio: String?
        let location: String?
        let totalLikes: Int
        let totalPhotos: Int
        let totalCollections: Int
        let instagramUsername: String?
        let twitterUsername: String?
        let links: UserLinks

        enum CodingKeys: String, CodingKey {
            case id
            case updatedAt = "updated_at"
            case username
            case name
            case portfolioUrl = "portfolio_url"
            case bio
            case location
            case totalLikes = "total_likes"
            case totalPhotos = "total_photos"
            case totalCollections = "total_collections"
            case instagramUsername = "instagram_username"
            case twitterUsername = "twitter_username"
            case links
        }
    }

    struct UserLinks: Decodable {
        let selfLink: String
        let html: String
        let photos: String
        let likes: String
        let portfolio: String

        enum CodingKeys: String, CodingKey {
            case selfLink = "self"
            case html
            case photos
            case likes
            case portfolio
        }
    }

}
