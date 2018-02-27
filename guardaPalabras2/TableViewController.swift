//
//  TableViewController.swift
//  guardaPalabras2
//
//  Created by victor sotelo on 2/9/18.
//  Copyright © 2018 victor sotelo. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var managedObjects:[NSManagedObject] = []
    
    //Cada un de los objetos de este arreglo es del tipo NSManagedObject y representa un objeto guardado en Core Data, estos objetos se utilizan para crear, guardar, editar y eliminar datos persistentes en core data.
    //Los objetos de NSManagedObject (como los de este arreglo) pueden tomar diferentes formas, es decir que pueden tomar la forma de cualquier entidad “Entity” de tu “data model” (representado en el archivo: guardaPalabras.xcdatamodeld) y se apropiara de cualquier atributo o relacion que tu definas en dicho “data model”
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //A
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        //B fetch = ir a buscar || traer || extraer
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Lista")
        
        //C
        do {
            managedObjects = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("No pude recuperar los datos guardados. El error fue: \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return managedObjects.count
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Configure the cell...
        
        
        let managedObject = managedObjects[indexPath.row]
        
        cell.textLabel?.text = managedObject.value(forKey: "palabra") as? String
        
        return cell
    }
    
    
    
    
    
    @IBAction func agregarPalabras(_ sender: Any) {
        let alerta = UIAlertController(title: "Nueva Palabra", message: "Por favor Agrega Palabra Nueva", preferredStyle: .alert)
        
        
        let guardar = UIAlertAction(title: "Agregar", style: .default, handler: { (UIAlertAction) -> Void in
            
            let textField = alerta.textFields!.first
            self.guardarPalabra(palabra: textField!.text!)
            self.tableView.reloadData()
            
        })
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .default)
        {(action: UIAlertAction) -> Void in }
        
        alerta.addTextField {(textField:UITextField) -> Void in}
        
        alerta.addAction(guardar)
        
        alerta.addAction(cancelar)
        
        
        present(alerta, animated: true, completion: nil)
        
    }
    
    
    func guardarPalabra(palabra:String){
        // A)Para guardar o recuperar datos en Core Data necesitamos un objeto del tipo "managedObjectContext", podemos verlo como una libreta de apuntes o borradores donde trabajas con objetos del tipo "NS managed Object".
        
        //Puedes verlo como que primero pones un nuevo objeto del tipo "managed Object" dentro de tu "libreta de apuntes o borradores" (managedObjectContext) y una vez que tengas preparado tu objeto "NS managed Object" a como tu lo quieres ya le puedes decir a tu "libreta de apuntes" (managedObjectContext) que guarde los cambios en el "disco duro" de tu app.
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        
        
        // B)Entonces creamos un objeto del tipo "NSManagedObject" por medio de la definicion de clase "Entity" y con la ayuda de tu objeto de tipo "managedObjectContext"
        
        let entity = NSEntityDescription.entity(forEntityName: "Lista", in: managedContext)!
        
        
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        
        
        
        
        // C) Le añadimos valores a las propiedades de dicho objeto (en este caso solo tenemos la propiedad de "palabra")
        
        managedObject.setValue(palabra, forKeyPath: "palabra")
        
        
        //D) Y con la ayuda de nuestro objeto del tipo "managedObjectContext" (libreta de apuntes o borradores), guardamos los cambios
        do {
            
            try managedContext.save()
            managedObjects.append(managedObject)
            
        } catch let error as NSError {
            print("No se pudo guardar, error: \(error), \(error.userInfo)")
        }
        
    }
    
}


    


