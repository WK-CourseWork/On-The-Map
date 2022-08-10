//
//  ListViewController.swift
//  OnTheMap2.0
//
//  Created by Waylon Kumpe on 8/3/22.
//

import Foundation
import UIKit

class ListViewController: UITableViewController {

    @IBOutlet weak var studentTableView: UITableView!

    var students = [TheStudentInformation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getTheStudentsInformation()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)

        let student = students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL ?? "")"

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        openLink(student.mediaURL ?? "")
    }

    @IBAction func reloadButtonPressed(_ sender: Any) {
        getTheStudentsInformation()
    }

    func getTheStudentsInformation() {
        APIClient.getStudentLocation { students, _ in
            self.students = students ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
