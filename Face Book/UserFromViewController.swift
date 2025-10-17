////
////  UserFromViewController.swift
////  Face Book
////
////  Created by Xufeng Zhang on 16/10/25.
////
//
//import UIKit
//
//private let reuseIdentifier = "Cell"
//
//protocol UserFromViewControllerDelegate: AnyObject {
//    func didAddVisit(_ user: User)
//    func didUpdateVisit(_ user: User)
//}
//
//extension UserFromViewControllerDelegate {
//    func didAddVisit(_ user: User) {}
//    func didUpdateVisit(_ user: User) {}
//}
//
//class UserFromViewController: UITableViewController {
//    
//    var user: User?
//    weak var delegate: UserFromViewControllerDelegate?
//    
//    init(user: User? = nil) {
//        self.user = user
//        super.init(style: .insetGrouped)
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    let titleField = UITextField()
//    private lazy var userControl: UISegmentedControl = {
//        var items = User.CodingKeys.allCases.map { $0.description}
//        let sc = UISegmentedControl(items: items)
//        return sc
//    }()
//    
////    private let distanceField = UITextField()
////    private let datePicker = UIDatePicker()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        if user == nil {
//            textField.becomeFirstResponder()
//        }
////        addDoneToolbar(to: distanceField)
////        title = (visit == nil) ? "New Visit" : "Edit Visit"
////        navigationItem.leftBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
////        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,   target: self, action: #selector(saveTapped))
////
////        distanceField.keyboardType = .numberPad
////        datePicker.datePickerMode = .dateAndTime
//        if let u = user{
//            titleField.text = u.FirstName
//            if let idx = User.CodingKeys.allCases.firstIndex(of: u.)
//        }
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
//
//    /*
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        // Configure the cell...
//
//        return cell
//    }
//    */
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
