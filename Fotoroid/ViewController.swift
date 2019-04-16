//
//  ViewController.swift
//  Fotoroid
//
//  Created by Denis Janoto on 19/03/2019.
//  Copyright © 2019 Denis Janoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! EffectsViewController
        vc.image = sender as! UIImage
    }
    
    //SOBE UM POPUP PERGUNTANDO AO USUÁRIO DA ONDE ELE QUER PEGAR A FOTO PARA EDIÇÃO (CAMERA,ALGUMDE FOTOS OU BIBLIOTECAS DE FOTOS)
    @IBAction func selectSource(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Selecionar Foto", message: "De onde voce quer escolher a sua foto", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de Fotos", style: .default) { (action) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de Fotos", style: .default) { (action) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //METODO RESPONSÁVEL POR ABRIR DE FATO AO ALBUM OU CAMERA OU BIBLIOTECA DE FOTOS
    func selectPicture(sourceType:UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    //HIDE NAVIGATION BAR
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
}

extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //É disparado quando o usuário selecionou um arquivo de media
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            //REDUZ O TAMANHO DA IMAGEM
            let originalWidth = image.size.width
            let aspectRatio = originalWidth / image.size.height
            var smallSize:CGSize
            
            //SE FOR MAIOR QUE 1 A IMAGEM ESTÁ EM LANDSCAPE, SE MENOR EM PORTRAIT
            if aspectRatio > 1{
                smallSize = CGSize(width: 1000, height: 1000/aspectRatio)
            }else{
                smallSize = CGSize(width: 1000*aspectRatio, height: 1000)
            }
            
            //CRIA UMA AREA PARA TRABALHAR A IMAGEM 
            UIGraphicsBeginImageContext(smallSize)
            image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
            let smallImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            
            //FECHA A TELA ATUAL E ABRE A TELA DE EFEITOS
            dismiss(animated: true) {
                self.performSegue(withIdentifier: "telaEfeitos", sender: smallImage)
            }
        }
    }
}

