import Flutter
import UIKit
import Photos
import BSImagePicker
    
public class SwiftMultiImagePickerPlugin: NSObject, FlutterPlugin {
    var controller: FlutterViewController!
    var imagesResult: FlutterResult?
    var messenger: FlutterBinaryMessenger;
    
    let genericError = "500"
    
    init(cont: FlutterViewController, messenger: FlutterBinaryMessenger) {
        self.controller = cont;
        self.messenger = messenger;
        super.init();
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "multi_image_picker", binaryMessenger: registrar.messenger())
        
        let app =  UIApplication.shared
        let controller : FlutterViewController = app.delegate!.window!!.rootViewController as! FlutterViewController;
        let instance = SwiftMultiImagePickerPlugin.init(cont: controller, messenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "pickImages":
            let vc = BSImagePickerViewController()
            let arguments = call.arguments as! Dictionary<String, AnyObject>
            let maxImages = arguments["maxImages"] as! Int
            let options = arguments["iosOptions"] as! Dictionary<String, String>
            vc.maxNumberOfSelections = maxImages

            if let backgroundColor = options["backgroundColor"] {
                if (!backgroundColor.isEmpty) {
                    vc.backgroundColor = hexStringToUIColor(hex: backgroundColor)
                }
            }
            
            if let selectionFillColor = options["selectionFillColor"] {
                if (!selectionFillColor.isEmpty) {
                    vc.selectionFillColor = hexStringToUIColor(hex: selectionFillColor)
                }
            }
            
            if let selectionShadowColor = options["selectionShadowColor"] {
                if (!selectionShadowColor.isEmpty) {
                    vc.selectionShadowColor = hexStringToUIColor(hex: selectionShadowColor)
                }
            }
            
            if let selectionStrokeColor = options["selectionStrokeColor"] {
                if (!selectionStrokeColor.isEmpty) {
                    vc.selectionStrokeColor = hexStringToUIColor(hex: selectionStrokeColor)
                }
            }

            if let selectionTextColor = options["selectionTextColor"] {
                if (!selectionTextColor.isEmpty) {
                    vc.selectionTextAttributes[NSAttributedStringKey.foregroundColor] = hexStringToUIColor(hex: selectionTextColor)
                }
            }

            if let selectionCharacter = options["selectionCharacter"] {
                if (!selectionCharacter.isEmpty) {
                    vc.selectionCharacter = Character(selectionCharacter)
                }
            }

            controller!.bs_presentImagePickerController(vc, animated: true,
                select: { (asset: PHAsset) -> Void in

                }, deselect: { (asset: PHAsset) -> Void in

                }, cancel: { (assets: [PHAsset]) -> Void in
                    result([])
                }, finish: { (assets: [PHAsset]) -> Void in
                    var results = [NSDictionary]();
                    for asset in assets {
                        results.append([
                            "identifier": asset.localIdentifier,
                            "width": asset.pixelWidth,
                            "height": asset.pixelHeight,
                            "filePath" : "",
                        ]);
                    }
                    result(results);
                }, completion: nil)
        case "requestThumbnail":
            let arguments = call.arguments as! Dictionary<String, AnyObject>
            let identifier = arguments["identifier"] as! String
            let width = arguments["width"] as! Int
            let height = arguments["height"] as! Int
            
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            
            options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
            options.resizeMode = PHImageRequestOptionsResizeMode.exact
            options.isSynchronous = false
            options.isNetworkAccessAllowed = true
            
            let assets: PHFetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
            
            if (assets.count > 0) {
                let asset: PHAsset = assets[0];
                
                let ID: PHImageRequestID = manager.requestImage(
                    for: asset,
                    targetSize: CGSize(width: width, height: height),
                    contentMode: PHImageContentMode.aspectFill,
                    options: options,
                    resultHandler: {
                        (image: UIImage?, info) in
                        self.messenger.send(onChannel: "multi_image_picker/image/" + identifier, message: UIImageJPEGRepresentation(image!, 1.0))
                        })
                
                if(PHInvalidImageRequestID != ID) {
                    result(true);
                }
            }
        case "requestOriginal":
            let arguments = call.arguments as! Dictionary<String, AnyObject>
            let identifier = arguments["identifier"] as! String
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            
            options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
            options.isSynchronous = false
            options.isNetworkAccessAllowed = true
            
            let assets: PHFetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
            
            if (assets.count > 0) {
                let asset: PHAsset = assets[0];
                
                let ID: PHImageRequestID = manager.requestImage(
                    for: asset,
                    targetSize: PHImageManagerMaximumSize,
                    contentMode: PHImageContentMode.aspectFill,
                    options: options,
                    resultHandler: {
                        (image: UIImage?, info) in
                        self.messenger.send(onChannel: "multi_image_picker/image/" + identifier, message: UIImageJPEGRepresentation(image!, 1.0))
                })
                
                if(PHInvalidImageRequestID != ID) {
                    result(true);
                }
            }
        case "refreshImage":
            result(true) ;
            break ;
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
