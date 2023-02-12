//
//  AddedEditViewController.swift
//  PlaytoPlay
//
//  Created by Humberto Rodrigues on 16/12/22.
//

import UIKit
import CoreData
import PhotosUI


class AddedEditViewController: UIViewController {
    
    var game: Game!
    var consoles: [Console] = []
    
    @IBOutlet weak var btChooseCape: UIButton!
    @IBOutlet weak var btChooseImages: UIButton!
    @IBOutlet weak var tfVersionConsole: UITextField!
    @IBOutlet weak var tfLinkTrailer: UITextField!
    @IBOutlet weak var tfNomedoJogo: UITextField!
    @IBOutlet weak var ivCapadoJogo: UIImageView!
    @IBOutlet weak var tfConsole: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var ivAdicionarImagens: UIImageView!
    @IBOutlet weak var btAddEdit: UIButton!
    
    var imageWasChoose = false
    var imagesWasChoose = false
    
    var imgArray: [UIImage] = []
    
    var itemProviders: [NSItemProvider] = [] // Criamos um array de NSItemProvider, assim consigo armazenar minhas imagens

    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tintColor = .black
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadConsoles()
        formatToolbar()
        
    }
    
    func loadConsoles () {
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescritor]
        
        do {
           consoles = try context.fetch(fetchRequest)
        } catch {
            print (error)
        }
    }
    
    func formatToolbar () {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.backgroundColor = .white
        toolbar.tintColor = .black
        
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btFlexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [btDone, btFlexible, btCancel]
        tfConsole.inputView = pickerView
        tfConsole.inputAccessoryView = toolbar
        
    }
    
    @objc func done(){
        tfConsole.text = consoles[pickerView.selectedRow(inComponent: 0)].name
        cancel()
    }
    
    @objc func cancel() {
        dismiss(animated: true)
        tfConsole.resignFirstResponder()
    }
    
    @IBAction func AddOrEdit(_ sender: UIButton) {
        if game == nil {
            game = Game(context: context)
        }
        
        game.title = tfNomedoJogo.text
        game.date = datePicker.date
        game.galleryIMG = imgArray as NSObject
        game.link = tfLinkTrailer.text
        if !tfConsole.text!.isEmpty {
            let console = consoles[pickerView.selectedRow(inComponent: 0)]
            tfVersionConsole.text = console.version
            game.console = console
        }
        game.capeIMG = ivCapadoJogo.image
        
        do{
            try context.save()
        }catch {
            print (error)
        }
        navigationController?.popViewController(animated: true)
        
    }
    @IBAction func selectGamePhotos(_ sender: UIButton) {
        let alert = UIAlertController(title: "Adicionar Imagem", message: "Selecione o local da Imagem", preferredStyle: .alert)
        
        let libraryAction = UIAlertAction(title: "Galeria de Fotos", style: .default) { (action) in
            self.selectPhotos()
            self.imagesWasChoose = true
        }
        alert.addAction(libraryAction)
        
        let pictureAction = UIAlertAction(title: "Album de Fotos", style: .default) { (action) in
            self.selectPhotos()
            self.imagesWasChoose = true
        }
        alert.addAction(pictureAction)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
    
    @IBAction func selectCapePhoto(_ sender: UIButton) {
        let alert = UIAlertController(title: "Adicionar Imagem", message: "Selecione local da Imagem", preferredStyle: .alert)
        
        let libraryAction = UIAlertAction(title: "Galeria de Fotos", style: .default) { (action) in
            self.selectPhoto(sourceType: .photoLibrary)
            self.imageWasChoose = true
        }
        alert.addAction(libraryAction)
        
        let pictureAction = UIAlertAction(title: "Album de Fotos", style: .default) { (action) in
            self.selectPhoto(sourceType: .savedPhotosAlbum)
            self.imageWasChoose = true
        }
        alert.addAction(pictureAction)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
    
    func selectPhoto (sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true)
    }
    
    func selectPhotos() {
        var PHconfiguration = PHPickerConfiguration()
        PHconfiguration.selectionLimit = 0
        PHconfiguration.filter = .images
        let picker = PHPickerViewController(configuration: PHconfiguration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension AddedEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //print(consoles.count)
        return consoles.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let console = consoles[row]
        
        return console.name
    }
}

extension AddedEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if imageWasChoose == true {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            ivCapadoJogo.image = image
            btChooseCape.setTitle("", for: .normal)
            imageWasChoose = false
            dismiss(animated: true)
        }
        
        if imagesWasChoose == true {
            let image2 = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            ivAdicionarImagens.image = image2
            btChooseImages.setTitle("", for: .normal)
            imagesWasChoose = false
            dismiss(animated: true)
        }
        
    }
}

extension AddedEditViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        dismiss(animated: true) // Desselecionei a Picker
        
        let itemProviders = results.map(\.itemProvider)
        
        for itemProvider in itemProviders {
            itemProvider.canLoadObject(ofClass: UIImage.self)
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image,error in
                if error == nil {
                    DispatchQueue.main.async {
                        guard let self = self, let image = image as? UIImage else {return}
                        self.imgArray.append(image)
                    }
                }
            }
            
        }
        
        if let itemProvider = itemProviders.first {
            itemProvider.canLoadObject(ofClass: UIImage.self)
            let previousImage = ivAdicionarImagens.image
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                if error == nil {
                    DispatchQueue.main.async {
                        guard let self = self, let image = image as? UIImage, self.ivAdicionarImagens.image == previousImage else {return}
                        self.ivAdicionarImagens.image = image
                    }
                    
                }
            }
        }
        
        
    }
}
