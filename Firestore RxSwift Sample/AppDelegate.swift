import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        let settings = Firestore.firestore().settings
        settings.areTimestampsInSnapshotsEnabled = true
        Firestore.firestore().settings = settings

        return true
    }
}

