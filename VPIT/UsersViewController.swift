//
//  UsersViewController.swift
//  VPIT
//
//  Created by Alhanouf Khalid on 05/12/1442 AH.
//

import UIKit
import SQLite3


class UsersViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Variables
    var usersList : [User] = []
    var db : DBHelper = DBHelper()
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
        
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Activate delegate and datasourse of table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        self.showSpinner()
        // Loading json data from url string
        let urlString = "https://gorest.co.in/public-api/users"
        self.loadJson(fromURLString: urlString) { (result) in
            switch result {
            case .success(let data):
                // If the loading done successfully, parse the data
                self.parse(jsonData: data)
            case .failure(let error):
                print(error)
            }
        }
    }



    // MARK: - Json parsing
    private func parse(jsonData: Data) {
        do {
            // decode Output struct, which exis in userData along with data which is an array of User struct
            let output = try JSONDecoder().decode(Output.self, from: jsonData)
            // Assign the result of user data from json to the local userList array
            self.usersList = output.data
            for user in usersList {
                // Insert each user in user table in SQL database
                self.db.insert(id: user.id, name: user.name, email: user.email, gender: user.gender, status: user.status)
            }
        } catch let error {
            print("decode error", error.localizedDescription)
        }
    }
    
    //MARK: - Json Loading
    private func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    // Handle network connection issues
                    DispatchQueue.main.async {
                        self.showAlert(title: "No Interne!", message: "Please check your internet connection.", actionStr: "Ok")
                        self.removeSpinner()
                    }
                }
                if let data = data {
                    completion(.success(data))
                    DispatchQueue.main.async{
                        // Reload table view with loaded data from json file to reflect it in the tableview
                        self.removeSpinner()
                        self.tableView.reloadData()
                    }
                }
            }
            urlSession.resume()
        }
    }
    
    //MARK: - TableView datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Make the number of rows in table view equal to the number of users fetched from json file
        return self.usersList.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserTableViewCell
        // Setup the appearance of table view cells
        cell.background.layer.cornerRadius = 10
        cell.background.layer.shadowColor = UIColor.systemGray.cgColor
        cell.background.layer.shadowRadius = 1.5
        cell.background.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        cell.background.layer.shadowOpacity = 0.5
        cell.background.clipsToBounds = false
        
        // Reflect the data of each user in the cell
        cell.name.text = self.usersList[indexPath.row].name
        cell.email.text = self.usersList[indexPath.row].email
        cell.status.text = self.usersList[indexPath.row].status
        cell.gender.text = self.usersList[indexPath.row].gender
        cell.email.adjustsFontSizeToFitWidth = true
        cell.gender.text = cell.gender.text?.capitalized
        cell.status.text = cell.status.text?.capitalized

        // Handle the color of gender text based on the gender type
        if cell.gender.text == "Female" {
            cell.gender.textColor = .systemPink
        } else {
            cell.gender.textColor = .systemBlue
        }
        return cell
    }
    
    
    
} // End of the class
