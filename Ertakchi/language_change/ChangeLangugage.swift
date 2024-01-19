//
//  ChangeLangugage.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 09/01/24.
//

import UIKit
import PanModal

struct Language {
    let image: UIImage
    let name: String
    let language: AppLanguage
}

struct Mode {
    let image: UIImage
    let name: String
    let mode: AppMode
}

enum AppMode {
    case dark
    case light
    case system
}

let languages: [Language] = [
    Language(image: UIImage(named: "uz")!, name: "uzb".translate(), language: .Uzbek),
    Language(image: UIImage(named: "us")!, name: "eng".translate(), language: .English),
]

class ChangeLanguage: UIViewController {
    
    let modes: [Mode] = [
        Mode(image:  UIImage(systemName: "platter.filled.bottom.iphone")!, name: "same_as".translate(), mode: .system),
        Mode(image: UIImage(systemName: "moon.stars")!, name: "always_dark".translate(), mode: .dark),
        Mode(image:  UIImage(systemName: "sun.min")!, name: "always_light".translate(), mode: .light),
    ]

    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    var isModeChange: Bool = false
    
    var contentHeight = 250.0
    
    lazy var chooseLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose language"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChangeLanguageCell.self, forCellReuseIdentifier: String.init(describing: ChangeLanguageCell.self))
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setContentHeight()
    }
    
    private func initViews() {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(chooseLanguageLabel)
        chooseLanguageLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(25)
        }
        
        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(chooseLanguageLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
        }
        
        if isModeChange {
            chooseLanguageLabel.text = "design_settings".translate()
        } else {
            chooseLanguageLabel.text = "language_change".translate()
        }
    }
    
    private func setContentHeight() {
        self.contentHeight = tableView.contentSize.height + 25 + 22 + 20
        self.panModalSetNeedsLayoutUpdate()
        self.panModalTransition(to: .shortForm)
    }

}

extension ChangeLanguage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isModeChange {
            return modes.count
        }
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: ChangeLanguageCell.self), for: indexPath) as? ChangeLanguageCell else { return UITableViewCell() }
        if isModeChange {
            cell.setMode(mode: modes[indexPath.row], index: indexPath.row)
            cell.iconImageView.tintColor = .label
            if indexPath.row == getChoosedIndex() {
                cell.chooseImageView.isHidden = false
            } else {
                cell.chooseImageView.isHidden = true
            }
        } else {
            cell.setData(language: languages[indexPath.row])
        }
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        return cell
    }
    
    func getChoosedIndex() -> Int {
        let mode = UD.mode
        var index = 0
        if mode == "light" {
            index = 2
        } else if mode == "dark" {
            index = 1
        } else {
            index = 0
        }
        return index
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isModeChange {
            if indexPath.row == 0 {
                UD.mode = "system"
                let deviceMode = Functions.getDeviceMode()
                if deviceMode == .light {
                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
                } else if deviceMode == .dark {
                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
                } else {
                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
                }
            } else if indexPath.row == 1 {
                UD.mode = "dark"
                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
            } else {
                UD.mode = "light"
                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
                
            }
            dismiss(animated: true)
        } else {
            let language = languages[indexPath.row]
            var langCode = "en"
            switch language.language {
            case .English:
                langCode = "en"
            case .Uzbek:
                langCode = "uz"
            case .lanDesc:
                langCode = "en"
            }
        
            self.showLoadingView()
            API.shared.changeLang(lang: langCode) { [weak self] result in
                self?.dissmissLoadingView()
                DispatchQueue.main.async {
                    switch result {
                    case .some(_):
                        self?.showAlert(title: "failure".translate(), message: "change_lan_err".translate()) {
                            self?.dismiss(animated: true)
                        }
                    case .none:
                        LanguageManager.setApplLang(language.language)
                        NotificationCenter.default.post(name: NSNotification.Name("ChangeTabBar"), object: nil)
                        NotificationCenter.default.post(name: .languageDidChange, object: nil)
                        tableView.reloadData()
                        self?.dismiss(animated: true)
                    }
                }
            }
            
            
        }
    }
}

extension ChangeLanguage: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return tableView
    }

    var longFormHeight: PanModalHeight {
        if contentHeight > UIWindow().bounds.height {
            return .maxHeight
        }
        return .contentHeight(CGFloat(contentHeight))
    }

    var shortFormHeight: PanModalHeight {
        if contentHeight > UIWindow().bounds.height {
            return .maxHeight
        }
        return .contentHeight(CGFloat(contentHeight))
    }

    var cornerRadius: CGFloat {
        return 22
    }

    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.5)
    }
}

// MARK: - Cell
class ChangeLanguageCell: UITableViewCell {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    lazy var chooseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "choose")!
        imageView.isHidden = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.width.equalTo(30)
        }
        
        subView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(15)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-30)
        }
        
        subView.addSubview(chooseImageView)
        chooseImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(22)
        }
    }
    
    func setData(language: Language) {
        iconImageView.image = language.image
        nameLabel.text = language.name
        if language.language == LanguageManager.getAppLang() {
            chooseImageView.isHidden = false
        } else {
            chooseImageView.isHidden = true
        }
    }
    
    func setMode(mode: Mode, index: Int) {
        iconImageView.image = mode.image
        nameLabel.text = mode.name
       
    }
}

import UIKit

enum DeviceMode {
    case light
    case dark
    case noMode
}

class Functions {
    static func getDeviceMode() -> DeviceMode {
        if #available(iOS 12.0, *) {
            let currentTraitCollection = UIScreen.main.traitCollection
            if currentTraitCollection.userInterfaceStyle == .light {
                return DeviceMode.light
            } else {
                return DeviceMode.dark
            }
        } else {
            return DeviceMode.light
        }
    }
}
