import Combine
import UIKit
import SnapKit
import SafariServices

class DetailViewController: UIViewController {
    
    
    private var searchId = ""
    private let btnPressedPublisher = PassthroughSubject<URL, Never>()
    
    private var subscriber = Set<AnyCancellable>()
    
    private var url: URL?
    
    private var imgView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "placeholder")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private var nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Name"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 20)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = .label
        return lbl
    }()
    
    private var ratingLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Rating"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = .label
        return lbl
    }()
    
    
    private var linkBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemRed
        btn.setTitle("Link", for: .normal)
        btn.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
        return btn
    }()
    
    //stackview for labels
    private let lblStackView: UIStackView = {
        let stck = UIStackView()
        stck.axis = .vertical
        stck.distribution = .fillProportionally
        stck.spacing = 40
        stck.translatesAutoresizingMaskIntoConstraints = false
        return stck
    }()
    //stackview for img and stackview
    private let contentStackView: UIStackView = {
        let stck = UIStackView()
        stck.axis = .vertical
        stck.distribution = .fill
        stck.spacing = 10
        stck.translatesAutoresizingMaskIntoConstraints = false
        return stck
    }()
    
    init(searchResult: SearchResult) {
        super.init(nibName: nil, bundle: nil)
        self.searchId = searchResult.id
        self.imgView.getImg(url: searchResult.gifUrl)
        self.nameLbl.text = "\(searchResult.title)"
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        title = "Gif Info"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        combineSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func btnPressed() {
        guard let url = url else { return }
        btnPressedPublisher.send(url)
    }
}

extension DetailViewController {
    
    func layout() {
        contentStackView.addArrangedSubview(imgView)
        lblStackView.addArrangedSubview(nameLbl)
        lblStackView.addArrangedSubview(ratingLbl)
        lblStackView.addArrangedSubview(linkBtn)
        contentStackView.addArrangedSubview(lblStackView)
        self.view.addSubview(contentStackView)
        
        contentStackView.snp.makeConstraints { (content) in
            content.top.equalTo(self.view.snp.top).offset(100)
            content.centerX.equalTo(self.view.snp.centerX)
        }
        
        imgView.snp.makeConstraints { (img) in
            img.height.equalTo(self.view.frame.height * 0.4)
            img.width.equalTo(self.view.frame.width * 0.8)
        }
    }
    
    func combineSetup() {
        //needs to be a tuple because the function/viewmodel takes a tuple. 
        let (data, btnData) = detailViewModel(lookupID: searchId, buttonTapped: btnPressedPublisher.eraseToAnyPublisher())
        
        data
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] value in
                print(value)
                guard let self = self else { return }
                self.ratingLbl.text = "Rating: \(value.rating)"
                self.url = value.url
                
            })
            .store(in: &subscriber)
        
        btnData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (url) in
                guard let self = self else { return }
                self.openSafari(for: url)
            }
            .store(in: &subscriber)
    }
    
    func openSafari(for url: URL) {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = true
        let safariVC = SFSafariViewController(url: url, configuration: configuration)
        present(safariVC, animated: true)
    }
}
