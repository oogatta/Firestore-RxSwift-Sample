import UIKit
import Firebase
import RxSwift

class ViewController: UIViewController {
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        startObserving()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopObserving()
    }
    
    private func startObserving() {
        hotSandsObservable()
            .subscribe(onNext: { hotSands in
                print(hotSands)
            })
            .disposed(by: disposeBag)
    }
    
    private func stopObserving() {
        disposeBag = DisposeBag()
    }
    
    private func hotSandsObservable() -> Observable<[HotSand]> {
        return Observable.create { emitter in
            let listenerRegistration = Firestore.firestore()
                .collection("netsuretsu-hot-sands")
                .addSnapshotListener { (querySnapshot, error) in
                    if let error = error { print(error.localizedDescription) }
                    guard let querySnapshot = querySnapshot else { return }
                    
                    let hotSands = querySnapshot.documents.compactMap { (queryDocumentSnapshot: QueryDocumentSnapshot) -> HotSand? in
                        if let data = queryDocumentSnapshot.data() as? [String: Timestamp], let onAir = data.values.first {
                            return HotSand(onAir: onAir)
                        }
                        return nil
                    }
                    emitter.onNext(hotSands)
            }
            return Disposables.create { listenerRegistration.remove() }
        }
    }
}

struct HotSand {
    let onAir: Timestamp
    
    init(onAir: Timestamp) {
        self.onAir = onAir
    }
}
