//
//  ProfileViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 09/01/24.
//

import UIKit
import Alamofire

struct Profile {
    let image: UIImage
    let name: String
}

extension String {
    func translate() -> String {
        return self.localized()
    }
}

let profilesx = [
    Profile(image: UIImage(systemName: "info.circle")!, name: "per_info".translate()),
    Profile(image: UIImage(systemName: "network")!, name: "language_change".translate()),
    Profile(image: UIImage(systemName: "moon.stars")!, name: "design_settings".translate()),
    Profile(image: UIImage(systemName: "envelope")!, name: "share_feed".translate()),
    Profile(image: UIImage(systemName: "star")!, name: "rate_app".translate()),
]

class ProfileViewController: BaseViewController {
    
    var info: ProfileInfo?
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    let topView = TopView()
    
    var profiles = [
        Profile(image: UIImage(systemName: "info.circle")!, name: "per_info".translate()),
        Profile(image: UIImage(systemName: "network")!, name: "language_change".translate()),
        Profile(image: UIImage(systemName: "moon.stars")!, name: "design_settings".translate()),
        Profile(image: UIImage(systemName: "envelope")!, name: "share_feed".translate()),
        Profile(image: UIImage(systemName: "star")!, name: "rate_app".translate()),
    ]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: String.init(describing: ProfileTableViewCell.self))
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileInfo()
        view.backgroundColor = .systemBackground
        initViews()
        configureNavBar()
    }
    
    private func initViews() {
        imagePicker.delegate = self
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureNavBar() {
        let likeButton = CustomBarButtonView(image: UIImage(systemName: "rectangle.portrait.and.arrow.right")!)
        
        likeButton.buttonAction = { [weak self] in
            guard let self = self else { return }
            let alertController = UIAlertController(title: "log_out".translate(), message: "log_desc".translate(), preferredStyle: .alert)
            let logoutAction = UIAlertAction(title: "log_out".translate(), style: .destructive) { (action) in
                UD.token = ""
                UD.mode = ""
                LanguageManager.setApplLang(.English)
                self.goLoginPage()
            }
            let cancelAction = UIAlertAction(title: "cancel".translate(), style: .cancel, handler: nil)
            alertController.addAction(logoutAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: likeButton), UIBarButtonItem(customView: likeButton)]
    }

    override func languageDidChange() {
        
        self.profiles = [
            Profile(image: UIImage(systemName: "info.circle")!, name: "per_info".translate()),
            Profile(image: UIImage(systemName: "network")!, name: "language_change".translate()),
            Profile(image: UIImage(systemName: "moon.stars")!, name: "design_settings".translate()),
            Profile(image: UIImage(systemName: "envelope")!, name: "share_feed".translate()),
            Profile(image: UIImage(systemName: "star")!, name: "rate_app".translate())
        ]
        tableView.reloadData()
    }
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: ProfileTableViewCell.self), for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.setProfile(profile: profiles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        topView.delegate = self
        return topView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            if let info = info {
                let vc = PersonalInfoViewController()
                vc.delegate = self
                vc.hidesBottomBarWhenPushed = true
                vc.info = info
                navigationController?.pushViewController(vc, animated: true)
            }
        case 1:
            let vc = ChangeLanguage()
            vc.isModeChange = false
            navigationController?.presentPanModal(vc)
        case 2:
            let vc = ChangeLanguage()
            vc.isModeChange = true
            navigationController?.presentPanModal(vc)
        case 3:
            let email = "mekhriddinjumaev@gmail.com"
            if let url = URL(string: "mailto:\(email)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        case 4:
            guard let url = URL(string: "itms-apps://itunes.apple.com/app/" + "6476115243") else {
                return
            }
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            } else {
                UIApplication.shared.openURL(url)
            }
        default:
            let vc = UIViewController()
            present(UINavigationController(rootViewController: vc), animated: true)
        }
    }
}

extension ProfileViewController: TopViewDelegate {
    func profileTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        dismiss(animated: true, completion: nil)
        uploadImage(image: chosenImage)
        topView.setImage(image: chosenImage)
    }
    
    private func uploadImage(image: UIImage) {
        let url = URL(string: API.shared.API_URL_ADD_PHOTO)!
        var request = URLRequest(url: url)
        let boundary = UUID().uuidString
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField:"Content-Type")
        request.setValue("Bearer \(UD.token ?? "")", forHTTPHeaderField: "Authorization") // Add your token here
        request.httpMethod = "POST"
        guard let mediaImage = Media(withImage: image, forKey: "file") else { return }
        let dataBody = createDataBody(withParameters: nil, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        self.showLoadingView()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.dissmissLoadingView()
            if let httpResponse = response as? HTTPURLResponse {
                let jsonResponse = data?.prettyPrintedJSONString
                if httpResponse.statusCode == 401 {
                } else if httpResponse.statusCode == 204 {
                }
            }
        }
        
        task.resume()
    }
    
    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
       let lineBreak = "\r\n"
       var body = Data()
       if let parameters = params {
          for (key, value) in parameters {
              body.append("--\(boundary + lineBreak)".data(using: .utf8)!)
             body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)".data(using: .utf8)!)
             body.append("\(value as! String + lineBreak)".data(using: .utf8)!)
          }
       }
       if let media = media {
          for photo in media {
             body.append("--\(boundary + lineBreak)".data(using: .utf8)!)
             body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)".data(using: .utf8)!)
             body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)".data(using: .utf8)!)
             body.append(photo.data)
             body.append(lineBreak.data(using: .utf8)!)
          }
       }
       body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
       return body
    }
}

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "imagefile.jpg"
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString
    }
}

extension ProfileViewController {
    func getProfileInfo() {
        // Dispatch the API call to a background thread
        DispatchQueue.global(qos: .background).async { [weak self] in
            API.shared.getProfileInfo { [weak self] info, error in
                // Switch back to the main thread to update the UI
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if let info = info {
                        self.info = info
                        self.topView.usernameLabel.text = info.username
                        if let url = info.photoUrl {
                            self.topView.setImageWith(url: url)
                        }
                    } else if let error = error {
                        self.showAlert(title: "failure".translate(), message: "error_profile_info".translate())
                    } else {
                        self.showAlert(title: "failure".translate(), message: "error_profile_info".translate())
                    }
                }
            }
        }
    }
}

extension ProfileViewController: PersonalInfoViewControllerDelegate {
    func profileUpdated(info: ProfileInfo) {
        self.info = info
        tableView.reloadData()
    }
    
}
