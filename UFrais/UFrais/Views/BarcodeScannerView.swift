import SwiftUI
import VisionKit

/// Scanner EAN / QR via VisionKit (appareil réel). Saisie manuelle en secours.
struct BarcodeScannerSheet: View {
    var onCode: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var manual = ""
    @State private var scannerAvailable = DataScannerViewController.isSupported
        && DataScannerViewController.isAvailable

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if scannerAvailable {
                    DataScannerRepresentable { code in
                        onCode(code)
                        dismiss()
                    }
                    .ignoresSafeArea(edges: .bottom)
                } else {
                    ContentUnavailableView(
                        "Caméra indisponible",
                        systemImage: "barcode.viewfinder",
                        description: Text("Utilise la saisie manuelle ci-dessous (simulateur ou appareil sans scan).")
                    )
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Ou saisir le code-barres")
                        .font(UFont.body(13, weight: .semibold))
                        .foregroundStyle(UColor.ardoise)
                    HStack {
                        TextField("Ex. 3017620422003", text: $manual)
                            .keyboardType(.numberPad)
                            .font(UFont.body(16, weight: .semibold))
                        Button("OK") {
                            let cleaned = manual.filter(\.isNumber)
                            guard cleaned.count >= 8 else { return }
                            onCode(cleaned)
                            dismiss()
                        }
                        .font(UFont.body(15, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(UColor.rouge, in: Capsule())
                    }
                    .padding(12)
                    .background(UColor.creme, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding(16)
                .background(.ultraThinMaterial)
            }
            .navigationTitle("Scanner")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") { dismiss() }
                }
            }
        }
    }
}

struct DataScannerRepresentable: UIViewControllerRepresentable {
    var onCode: (String) -> Void

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.barcode()],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: false,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        if !uiViewController.isScanning {
            try? uiViewController.startScanning()
        }
    }

    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onCode: onCode)
    }

    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        let onCode: (String) -> Void
        private var didEmit = false

        init(onCode: @escaping (String) -> Void) {
            self.onCode = onCode
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            emit(from: item, scanner: dataScanner)
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            guard let first = addedItems.first else { return }
            emit(from: first, scanner: dataScanner)
        }

        private func emit(from item: RecognizedItem, scanner: DataScannerViewController) {
            guard !didEmit else { return }
            if case .barcode(let barcode) = item, let value = barcode.payloadStringValue {
                let digits = value.filter(\.isNumber)
                guard digits.count >= 8 else { return }
                didEmit = true
                scanner.stopScanning()
                onCode(digits)
            }
        }
    }
}
