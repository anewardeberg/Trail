//
//  ViewController.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 02/11/2021.
//

import UIKit
import CoreData

class ContactListViewController: UITableViewController, UITabBarDelegate {
     
     
#warning("TODO: Lag egen funksjon for å lagre bilder")
     var contactList = [ContactStorage]()
     var contactModels = [ContactModel]()
     var selectedContact: ContactStorage?
     
     override func viewWillAppear(_ animated: Bool) {
          self.navigationItem.setHidesBackButton(true, animated: true)
          
          API.shared.getRandomContacts{ [weak self] result in
               switch result {
               case .success(let contacts):
                    DispatchQueue.main.async {
                         ContactStorage.saveContacts(contacts: contacts, context: ModelManager.sharedManager.persistentContainer.viewContext)
                         self?.tableView.reloadData()
                    }
               case .failure(let error):
                    print(error)
               }
          }
          
          let fetchRequest = NSFetchRequest<ContactStorage>(entityName: "ContactStorage")
          
          ModelManager.sharedManager.persistentContainer.viewContext.perform {
               do {
                    let results = try fetchRequest.execute()
                    self.contactList = results
               } catch {
                    print(error)
               }
          }
          
          // https://stackoverflow.com/questions/27651507/passing-data-between-tab-viewed-controllers-in-swift
          let navController = self.tabBarController!.viewControllers![1] as! UINavigationController
          let vc = navController.topViewController as! MapViewController
          vc.contactModels = contactModels
          
     }
     
     
#warning("TODO: Fix this")
     private func tabBar(_ tabBar: UITabBar, didSelect navigationController: UINavigationController) {
          if navigationController.restorationIdentifier == "contactListNC"{
               print("==== CONTACT LIST VIEW CONTROLLER")
          } else if navigationController.restorationIdentifier == "mapNC" {
               print("==== MAP VIEW CONTROLLER")
          }
     }
     
     
     //     func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
     //          if viewController.isKind(of: MapViewController.self as AnyClass) {
     //               let viewController = tabBarController.viewControllers?[1] as! MapViewController
     //               viewController.contacts = self.contactModels
     //          }
     //          return true
     //     }
     //
     
     //     func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
     //          <#code#>
     //     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return contactList.count
     }
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(
               withIdentifier: "ContactCell",
               for: indexPath
          )
          cell.imageView?.loadImage2(urlString: contactList[indexPath.row].imgMedium)
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
               }
          }
          
          //         if segue.identifier == "goToMapView" {
          //             let destinationVC = segue.destination as! UINavigationController
          //             let targetController = destinationNC.navigationController?.topViewController
          //         }
     }
     
     
     
}

