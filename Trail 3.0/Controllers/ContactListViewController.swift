//
//  ViewController.swift
//  Trail 3.0
//
//  Created by Ane Wardeberg on 02/11/2021.
//

import UIKit

class ContactListViewController: UITableViewController {
     
     
     // MARK: Egen funksjon som lagrer bilder
     
     private var contactViewModels = [ContactCellViewModel]()
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          // Do any additional setup after loading the view.
          API.shared.getRandomContacts{ [weak self] result in
               switch result {
               case .success(let contacts):
                    self?.contactViewModels = contacts.compactMap({
                         ContactCellViewModel(
                              firstName: $0.name.first,
                              lastName: $0.name.last ,
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
     
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return contactViewModels.count
     }
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(
               withIdentifier: "ContactCell",
               for: indexPath
          )
          cell.textLabel?.text = "\(contactViewModels[indexPath.row].firstName) \(contactViewModels[indexPath.row].lastName)"
          return cell
     }
     
     
     
     
}

