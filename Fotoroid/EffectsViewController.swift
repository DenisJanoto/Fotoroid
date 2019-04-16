//
//  EffectsViewController.swift
//  Fotoroid
//
//  Created by Denis Janoto on 19/03/2019.
//  Copyright © 2019 Denis Janoto. All rights reserved.
//

import UIKit

class EffectsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viLoad: UIView!
    @IBOutlet weak var ivPhoto: UIImageView!
    
    var image:UIImage!
    lazy var filterManager:FilterManager = {
        let filterManager = FilterManager(image: image)
        return filterManager
    }()
    
    
    let filterImageNames = [
        "comic","sepia","halftone","crystallize","vignette","noir"
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ivPhoto.image = image
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! FinalViewController
        vc.image = ivPhoto.image
    }
    
    //SHOW NAVIGATION BAR
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MOSTRA A TELA DE LOADING
    func showLoading(_ show:Bool){
        viLoad.isHidden = !show
    }
}

extension EffectsViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    //METODOS PARA CRIAR A COLLECTIONVIEW (SIMILAR AO TABLEVIEW)
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterManager.filterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.ivEffect.image = UIImage(named: filterImageNames[indexPath.row])
        
        return cell
    }
    
    
    //DISPARA AO SELECIONAR ALGUM ITEM
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let type = FilterType(rawValue: indexPath.row){
            showLoading(true)
            
            /*CRIAÇÃO DE OUTRA THREAD PARA APLICAÇÃO DO FILTRO
             ASYNC - Processos são excutados paralelamente
             SYNC - Processos são executados um após o outro
             OBS - Todos os elementos visuais (UIimage,texfield e etc) são executados na main thread e não podem serem manipulados em outra thread
             */
            DispatchQueue.global(qos:.userInitiated).async {
                let filteredImage = self.filterManager.applyFilter(type: type)
                DispatchQueue.main.async {
                    self.ivPhoto.image = filteredImage
                    self.showLoading(false)
                }
                
            }
            
            
        }
        
    }
}




