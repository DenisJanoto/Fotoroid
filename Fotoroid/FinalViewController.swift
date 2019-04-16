//
//  FinalViewController.swift
//  Fotoroid
//
//  Created by Denis Janoto on 19/03/2019.
//  Copyright © 2019 Denis Janoto. All rights reserved.
//

import UIKit
import Photos

class FinalViewController: UIViewController {

    
    @IBOutlet weak var ivPhoto: UIImageView!
    var image:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ivPhoto.image = image
        ivPhoto.layer.borderWidth = 10
    }

    //SALVAR IMAGEM NA BIBLIOTECA
    func saveToAlbum(){
        PHPhotoLibrary.shared().performChanges({
            let criationRequest = PHAssetChangeRequest.creationRequestForAsset(from: self.image)
            let addAssetRequest = PHAssetCollectionChangeRequest()
            addAssetRequest.addAssets([criationRequest.placeholderForCreatedAsset]as NSArray)
        }) { (success, error) in
            if !success{
                print(error?.localizedDescription)
            }else{
                let alert = UIAlertController(title: "SUCESSO", message: "Foto salva com sucesso", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status{
            case .authorized:
                self.saveToAlbum()
            default:
                let alert = UIAlertController(title: "ERRO", message: "Você precisa autorizar o acesso ao álbum para salvar a foto", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
    
        }
    }
    
    
    @IBAction func restart(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
