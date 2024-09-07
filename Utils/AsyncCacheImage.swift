import SwiftUI

struct CacheAsyncImage<Content>: View where Content: View {
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    private let desiredWidth: CGFloat
    private let desiredHeight: CGFloat

    init(url: URL,
         scale: CGFloat = 1.0,
         transaction: Transaction = Transaction(),
         desiredWidth: CGFloat = 100,
         desiredHeight: CGFloat = 100,
         @ViewBuilder content: @escaping (AsyncImagePhase) -> Content)
    {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.desiredWidth = desiredWidth
        self.desiredHeight = desiredHeight
        self.content = content
    }

    var body: some View {
        if let cached = ImageCache[url] {
            content(.success(cached))
                .frame(width: desiredWidth, height: desiredHeight)
                .scaledToFit()
        } else {
            AsyncImage(url: url, scale: scale, transaction: transaction) { phase in
                cacheAndRender(phase: phase)
            }
            .frame(width: desiredWidth, height: desiredHeight)
            .scaledToFit()
        }
    }

    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            ImageCache[url] = image
        }
        return content(phase)
            .frame(width: desiredWidth, height: desiredHeight)
    }
}

private class ImageCache {
    private static var cahce: [URL: Image] = [:]

    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cahce[url]
        }
        set {
            ImageCache.cahce[url] = newValue
        }
    }
}
