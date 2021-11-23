import UIKit
import CoreData

class ContactListViewController: UITableViewController, UITabBarDelegate {
     var contactList = [ContactStorage]() {
          didSet {
               contactList = contactList.sorted(by: {  $0.lastName < $1.lastName })
          }
     }
     
     let context = ModelManager.sharedManager.persistentContainer.viewContext
     
     var selectedContact: ContactStorage?
     var entityIsEmpty = false
     
     override func viewDidLoad() {
          checkEntityIsEmpty()
          super.viewDidLoad()
          let context = self.context
          
          if(entityIsEmpty) {
               API.shared.getRandomContacts{ [weak self] result in
                    switch result {
                    case .success(let contacts):
                         DispatchQueue.main.async {
                              ContactStorage.saveContacts(contacts: contacts, context: context)
                              
                              let fetchRequest = NSFetchRequest<ContactStorage>(entityName: "ContactStorage")
                              
                              context.perform {
                                   do {
                                        let results = try fetchRequest.execute()
                                        self?.contactList = results
                                        self?.tableView.reloadData()
                                   } catch {
                                        print(error)
                                        let alert = UIAlertController(title: "Could not fetch contacts", message: "Try again later", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                                        
                                        self?.present(alert, animated: true)
                                   }
                              }
                         }
                    case .failure(let error):
                         print(error)
                    }
               }
          } else {
               let fetchRequest = NSFetchRequest<ContactStorage>(entityName: "ContactStorage")
               
               context.perform {
                    do {
                         let results = try fetchRequest.execute()
                         self.contactList = results
                         self.tableView.reloadData()
                    } catch {
                         print(error)
                    }
               }
          }
          
     }
     
     override func viewWillAppear(_ animated: Bool) {
          checkEntityIsEmpty()
          self.navigationItem.setHidesBackButton(true, animated: true)
          
          let fetchRequest = NSFetchRequest<ContactStorage>(entityName: "ContactStorage")
          
          ModelManager.sharedManager.persistentContainer.viewContext.perform {
               do {
                    let results = try fetchRequest.execute()
                    self.contactList = results
                    self.tableView.reloadData()
               } catch {
                    print(error)
                    let alert = UIAlertController(title: "Could not fetch contacts", message: "Try again later", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
               }
          }
          
          let navController = self.tabBarController!.viewControllers![1] as! UINavigationController
          _ = navController.topViewController as! MapViewController
     }
     
     func checkEntityIsEmpty() {
          let context = ModelManager.sharedManager.persistentContainer.viewContext
          do {
               let request = NSFetchRequest<ContactStorage>(entityName: "ContactStorage")
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
          cell.textLabel?.text = "\(contactList[indexPath.row].firstName) \(contactList[indexPath.row].lastName)"
          
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

