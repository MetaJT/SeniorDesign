import UIKit

class NavigateSectionView: UIView {
    
    private let selectLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Location"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()

    private let yourLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Location"
        label.font = UIFont(name: "DMSans-Regular", size: 12)
        label.textColor = UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1.0)
        return label
    }()

    private let setLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "Building 3"
        label.font = UIFont(name: "DMSans-Regular", size: 12)
        label.textColor = .black
        return label
    }()

    private let searchBuildingLocation: UILabel = {
        let label = UILabel()
        label.text = "Search Building Location"
        label.font = UIFont(name: "DMSans-Regular", size: 12)
        label.textColor = UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1.0)
        return label
    }()

    private let searchRoomLocation: UILabel = {
        let label = UILabel()
        label.text = "Search Room Location"
        label.font = UIFont(name: "DMSans-Regular", size: 12)
        label.textColor = UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1.0)
        return label
    }()

    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        textField.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        return textField
    }()

    private let searchTextField2: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        textField.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        return textField
    }()

    private let navigateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Navigate", for: .normal)
        button.titleLabel?.font = UIFont(name: "few-Regular", size: 18)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        let xPos = 0
        let yPos = 600
        
        let overlayView = UIView()
        overlayView.frame = CGRect(x: xPos, y: yPos, width: 400, height: 450)
        overlayView.backgroundColor = backgroundColor
        addSubview(overlayView)
        addSubview(selectLocationLabel)
        selectLocationLabel.frame = CGRect(x: xPos + 20, y: yPos + 8, width: 200, height: 40)
        
        addSubview(yourLocationLabel)
        yourLocationLabel.frame = CGRect(x: xPos + 16, y: yPos + 45, width: 160, height: 25)
        addSubview(setLocationLabel)
        setLocationLabel.frame = CGRect(x: xPos + 20, y: yPos + 66, width: 150, height: 25)

        addSubview(searchBuildingLocation)
        searchBuildingLocation.frame = CGRect(x: xPos + 16, y: yPos + 87, width: 200, height: 25)

        addSubview(searchRoomLocation)
        searchRoomLocation.frame = CGRect(x: xPos + 216, y: yPos + 87, width: 200, height: 25)

        addSubview(searchTextField)
        searchTextField.frame = CGRect(x: xPos + 16, y: yPos + 111, width: 180, height: 30)
        addSubview(searchTextField2)
        searchTextField2.frame = CGRect(x: xPos + 216, y: yPos + 111, width: 180, height: 30)

        addSubview(navigateButton)
        navigateButton.frame = CGRect(x: xPos + 16, y: yPos + 165, width: 360, height: 60)
    }
}
