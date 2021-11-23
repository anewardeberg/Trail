import UIKit
import CoreData

class ContactListViewController: UITableViewController, UITabBarDelegate {
     
#warning("TODO: Lag egen funksjon for å lagre bilder")
     var contactList = [ContactStorage]() {
          didSet {
                contactList = contactList.sorted(by: {  $0.lastName < $1.lastName })
             }
     }
     var selectedContact: ContactStorage?
     var entityIsEmpty = false
     
     override func viewDidLoad() {
          checkEntityIsEmpty()
          super.viewDidLoad()
          print("==== [CONTACT LIST] VIEW DID LOAD")
          
          if(entityIsEmpty) {
               print("==== [CONTACT LIST] FROM FETCH API")
               API.shared.getRandomContacts{ [weak self] result in
                    switch result {
                    case .success(let contacts):
                         DispatchQueue.main.async {
                              ContactStorage.saveContacts(contacts: contacts, context: ModelManager.sharedManager.persistentContainer.viewContext)
                              print("==== [CONTACT LIST] SAVED CONTACTS")
                              self?.tableView.reloadData()
                         }
                    case .failure(let error):
                         print(error)
                    }
               }
          } else {
               print("==== [CONTACT LIST] FROM CORE DATA")
               let fetchRequest = NSFetchRequest<ContactStorage>(entityName: "ContactStorage")
               
               ModelManager.sharedManager.persistentContainer.viewContext.perform {
                    do {
                         let results = try fetchRequest.execute()
                         self.contactList = results
                         self.tableView.reloadData()
                    } catch {
                         print(error)
     #warning("alert user")
                    }
               }
          }
          
     }
     
     override func viewWillAppear(_ animated: Bool) {
          checkEntityIsEmpty()
          print("==== [CONTACT LIST] VIEW DID APPEAR")
          self.navigationItem.setHidesBackButton(true, animated: true)
          
          let fetchRequest = NSFetchRequest<ContactStorage>(entityName: "ContactStorage")
          
          ModelManager.sharedManager.persistentContainer.viewContext.perform {
               do {
                    let results = try fetchRequest.execute()
                    self.contactList = results
                    self.tableView.reloadData()
               } catch {
                    print(error)
#warning("alert user")
               }
          }
          
          // https://stackoverflow.com/questions/27651507/passing-data-between-tab-viewed-controllers-in-swift
          let navController = self.tabBarController!.viewControllers![1] as! UINavigationController
          let vc = navController.topViewController as! MapViewController
          
     }
     
     func checkEntityIsEmpty() {
          var context = ModelManager.sharedManager.persistentContainer.viewContext
          do {
               var request = NSFetchRequest<ContactStorage>(entityName: "ContactStorage")
               let count = try context.count(for: request)
               if count == 0 {
                    entityIsEmpty = true
               }
          } catch {
              entityIsEmpty = false
          }
     }
     
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return contactList.count
     }
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(
               withIdentifier: "ContactCell",
               for: indexPath
          )
          cell.imageView?.loadImage(urlString: contactList[indexPath.row].imgMedium)
          cell.textLabel?.text = "\(indexPath.row) \(contactList[indexPath.row].firstName) \(contactList[indexPath.row].lastName)"
          
          return cell
     }
     
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          selectedContact = contactList[indexPath.row]
          
          self.performSegue(withIdentifier: "goToContactDetail", sender: self)
          
          
          
          
     }
     
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "goToContactDetail" {
               let destinationVC = segue.destination as! ContactDetailViewController
               if let selectedContact = selectedContact {
                    destinationVC.contact = selectedContact
                    destinationVC.managedObjectContext = ModelManager.sharedManager.persistentContainer.viewContext
               }
          }
     }
     
     
     
}

