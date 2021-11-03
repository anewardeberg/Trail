//
//  ViewController.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 02/11/2021.
//

import UIKit

class ContactListViewController: UITableViewController, UITabBarDelegate {
     
     
     // MARK: Egen funksjon som lagrer bilder
     
     private var contactModels = [ContactModel]()
     var selectedContact: ContactModel?
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          // Do any additional setup after loading the view.
          
          API.shared.getRandomContacts{ [weak self] result in
               switch result {
               case .success(let contacts):
                    self?.contactModels = contacts.compactMap({
                         
                         ContactModel(
                              firstName: $0.name.first,
                              lastName: $0.name.last,
                              age: $0.dob.age,
                              date: $0.dob.date,
                              city: $0.location.city,
                              state: $0.location.state,
                              postcode: $0.location.postcode,
                              latitude: $0.location.coordinates.latitude,
                              longitude: $0.location.coordinates.latitude,
                              cell: $0.cell,
                              email: $0.email,
                              imgMedium: $0.picture.medium,
                              imgLarge: $0.picture.large,
                              imgThumb: $0.picture.thumbnail
                              
                         )})
                    
                    DispatchQueue.main.async {
                         self?.tableView.reloadData()
                    }
               case .failure(let error):
                    print(error)
               }
          }
          
          
     }
     
     //TODO: Fix this.
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
          return contactModels.count
     }
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(
               withIdentifier: "ContactCell",
               for: indexPath
          )
          cell.imageView?.loadImage(urlString: contactModels[indexPath.row].imgMedium)
          cell.textLabel?.text = "\(contactModels[indexPath.row].firstName) \(contactModels[indexPath.row].lastName)"
          
          return cell
     }
     
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          selectedContact = contactModels[indexPath.row]
          
          // TODO: Format dates
          print("====== BIRTHDAY")
          print(selectedContact?.date)
          
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

