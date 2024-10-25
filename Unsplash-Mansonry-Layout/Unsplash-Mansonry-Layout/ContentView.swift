//
//  ContentView.swift
//  Unsplash-Mansonry-Layout
//
//  Created by Aitor Pagán on 24/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var layouts: [AnyLayout] = [AnyLayout(UnsplashLayout(rowsOrColumns: 3, spacing: 4))
                                               , AnyLayout(UnsplashLayout(rowsOrColumns: 3, spacing: 4, axis: .horizontal))]
    @State private var photos: [UnsplashPhoto.Photo] = []
    private let api: UnsplashAPI = UnsplashAPI()
    @State private var alertMessage: String = ""
    @State private var isAlertMessagePresent: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                AnyLayout(layouts[0]) {
                    ForEach(photos, id: \.id) { photo in
                        LazyAsyncImageView(url: URL(string: photo.urls.small))
                            .aspectRatio(contentMode: .fill)
                    }
                }
            }
            .scrollIndicators(.hidden, axes: .vertical)
            .border(.indigo, width: 1)
            .clipShape(.rect(cornerRadius: 8))
            ScrollView(.horizontal) {
                AnyLayout(layouts[1]) {
                    ForEach(photos, id: \.id) { photo in
                        LazyAsyncImageView(url: URL(string: photo.urls.small))
                            .aspectRatio(contentMode: .fill)
                    }
                }
            }
            .scrollIndicators(.hidden, axes: .horizontal)
            .border(.indigo, width: 1)
            .clipShape(.rect(cornerRadius: 8))
        }
        .padding()
        .task {
            do {
                photos = try await api.randomPhotos()
            } catch {
                alertMessage = error.localizedDescription
                isAlertMessagePresent = true
            }
        }
        .refreshable {
            do {
                photos = try await api.randomPhotos()
            } catch {
                alertMessage = error.localizedDescription
                isAlertMessagePresent = true
            }
        }
        .alert(alertMessage,
               isPresented: $isAlertMessagePresent) {
            Button("Ok") {
                isAlertMessagePresent = false
            }
        }
    }
}

struct LazyAsyncImageView: View {
    let url: URL?
    @StateObject private var cache = ImageCache.shared
    
    var body: some View {
        if let url,
           let image = cache.image(for: url) {
            image
                .resizable()
                .scaledToFit()
        } else {
            AsyncImage(url: url) { newPhase in
                imageView(from: newPhase)
            }
        }
    }
    
    @ViewBuilder
    private func imageView(from phase: AsyncImagePhase) -> some View {
        switch phase {
        case .empty:
            ProgressView()
        case .success(let image):
            image
                .resizable()
                .scaledToFit()
                .onAppear {
                    if let url {
                        cache.cacheImage(image, for: url)
                    }
                }
        case .failure(_):
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
}

class ImageCache: ObservableObject {
    public static let shared = ImageCache()
    @Published var cache: [URL: Image] = [:]
    
    func image(for url: URL) -> Image? {
        return cache[url]
    }
    
    func cacheImage(_ image: Image, for url: URL) {
        cache[url] = image
    }
}

#Preview {
    ContentView()
}
