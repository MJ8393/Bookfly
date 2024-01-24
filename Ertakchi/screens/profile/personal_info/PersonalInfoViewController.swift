//
//  PersonalInfoViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 13/01/24.
//

import UIKit
import Alamofire

protocol PersonalInfoViewControllerDelegate: AnyObject {
    func profileUpdated(info: ProfileInfo)
}


class PersonalInfoViewController: UIViewController {
    
    weak var delegate: PersonalInfoViewControllerDelegate?
    
    var info: ProfileInfo? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    let topView = TopView()
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
        
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(PersonalInfoTableViewCell.self, forCellReuseIdentifier: String.init(describing: PersonalInfoTableViewCell.self))
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        initViews()
        configureNavBar()
        configureNotifications()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    let saveButton = CustomBuyButtonView("save".translate())
    
    private func configureNavBar() {
        let backButton = CustomBarButtonView(image: UIImage(systemName: "arrow.backward")!)
        backButton.buttonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        saveButton.isHidden = true
        saveButton.buttonAction = { [weak self] in
            if let cell = self?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PersonalInfoTableViewCell {
                self?.updateProfile(fullname: cell.getFullname(), username: cell.getUsername(), password: cell.getEmail())
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }

}

extension PersonalInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        topView.delegate = self
        if let info = info {
            topView.usernameLabel.text = info.username
        }
        
        if let info = info, let url = info.photoUrl {
            topView.setImageWith(url: url)
        }
        return topView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: PersonalInfoTableViewCell.self), for: indexPath) as? PersonalInfoTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if let info = info {
            cell.setData(info: info)
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}

extension PersonalInfoViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            // Adjust content inset of the tableView by the height of the keyboard
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            tableView.contentInset = contentInset
            tableView.scrollIndicatorInsets = contentInset
            
            // Calculate the scroll position to ensure the active input field is visible
            var rect = self.view.frame
            rect.size.height -= keyboardHeight
            if let activeField = findActiveTextField(in: self.view) {
                tableView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // Reset content inset to its original position when the keyboard is hidden
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = contentInset
        tableView.scrollIndicatorInsets = contentInset
    }

    // Helper function to find the active text field
    private func findActiveTextField(in view: UIView) -> UITextField? {
        for subview in view.subviews {
            if let textField = subview as? UITextField, textField.isFirstResponder {
                return textField
            } else if let foundTextField = findActiveTextField(in: subview) {
                return foundTextField
            }
        }
        return nil
    }


}

extension PersonalInfoViewController: TopViewDelegate {
    func profileTapped() {
    }
    
   
}

extension PersonalInfoViewController: PersonalInfoTableViewCellDelegate {
    
    func resetButtonTapped() {
        let vc = ResetViewController()
        self.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    func deleteButtonTapped() {
        let alertController = UIAlertController(title: "delete".translate(), message: "delete_desc".translate(), preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "delete".translate(), style: .destructive) { (action) in
            API.shared.deleteAccount() { result in
                switch result {
                case .some(_):
                    self.showAlert(title: "failure".translate(), message: "error_delete_acc".translate())
                case .none:
                    UD.token = ""
                    UD.mode = ""
                    LanguageManager.setApplLang(.English)
                    self.goLoginPage()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "cancel".translate(), style: .cancel, handler: nil)
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func textFieldDidChange() {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PersonalInfoTableViewCell {
            if let info = info {
                if info.name != cell.getFullname() || info.username != cell.getUsername() || info.email != cell.getEmail() {
                    saveButton.isHidden = false
                } else {
                    saveButton.isHidden = true
                }
            } else {
                saveButton.isHidden = true
            }
        } else {
            saveButton.isHidden = true
        }

    }
}

extension PersonalInfoViewController {
    private func updateProfile(fullname: String, username: String, password: String) {
        if isValidEmail(password) {
            showLoadingView()
            view.endEditing(true)
            API.shared.updateProfile(fullname: fullname, username: username, password: password) { loginModel, error in
                self.dissmissLoadingView()
                if !username.isEmpty, !password.isEmpty {
                    if let model = loginModel {
                        UD.token = model.token
                        self.info?.username = username
                        self.info?.email = password
                        self.info?.name = fullname
                        self.saveButton.isHidden = true
                        if let info = self.info {
                            self.delegate?.profileUpdated(info: info)
                        }
                    } else if let error = error {
                        self.showAlert(title: "failure".translate(), message: "error_update_profile".translate())
                    } else {
                        self.showAlert(title: "failure".translate(), message: "error_update_profile".translate())
                    }
                } else {
                    self.showAlert(title: "failure".translate(), message: "error_update_profile".translate())
                }
            }
        } else {
            self.showAlert(title: "failure".translate(), message: "email_not_valid".translate())
        }
    }
}

extension PersonalInfoViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
