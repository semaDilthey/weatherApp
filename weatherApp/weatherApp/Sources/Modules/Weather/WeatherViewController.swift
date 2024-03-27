//
//  WeatherViewController.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 16.03.2024.
//

import UIKit
import SnapKit
import RxSwift

private extension String {
    static let tableHeader = "Detailed forecast"
}

fileprivate enum Constants {
    enum Radius {
        static let backgroundWhiteView : CGFloat = 58
        static let weatherCard : CGFloat = 30
    }
    
    enum Sizes {
        static let topViewHeigt : CGFloat = 80
        static let collectionViewMultiplier : CGFloat = 0.15
        static let backgroundWhiteViewTopOffset : CGFloat = 150
        static let weatherCardHeightMultiplier : CGFloat = 0.38
    }
}

final class WeatherViewController: BaseViewController {
    
    //MARK: - Properties
    private(set) var viewModel : WVMProtocol
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialization

    init(viewModel: WVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupScrollView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupScrollView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // опять же костыль, но без него при возвращении с экрана DetailedForecast scrollView увеличивает свою высотку поинтов на 200
        scrollView.contentSize.height = 0
    }

    //MARK: - UI Elements

    private lazy var scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let topView = TopView()
    private lazy var collectionView = UICollectionView(frame: .zero, 
                                                       collectionViewLayout: UICollectionViewFlowLayout())
    
    private let backgroundWhiteView = UIView()
    private let weatherCardView = WeatherCardView()
    private let tableView = UITableView()
        
    //MARK: - Private methods

    private func getLocationWhenLaunch() {
        do {
            try viewModel.loadUserLocation()
        } catch let error {
            print(error)
        }
    }
    
    private func subscribeOnChanges() {
        viewModel.weatherModel
            .subscribe { [weak self] weatherModel in
                DispatchQueue.main.async { [weak self] in
                    guard let weatherModel else { return }
                    self?.topView.setCity(name: weatherModel.name)
                    self?.tableView.reloadData()
                    self?.collectionView.reloadData()
                    self?.setSelectedCell(weather: weatherModel)
                    
                    self?.setupScrollView() // костыль (или нет), но без него при обновлении города scroll вью к текущей высоте таблицы плюсует еще одну
                }
        }
        .disposed(by: disposeBag)
    }
    
    private func setSelectedCell(weather: WeatherModel) {
        let indexPath = IndexPath(row: 0, section: 0)
        DispatchQueue.main.async {
            self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
            self.bindWeatherCard(at: indexPath)
        }
    }
    
    private func bindWeatherCard(at indexPath: IndexPath) {
        let weatherModel = viewModel.getWeatherCardModel(forCellAt: indexPath)
        weatherCardView.configure(with: weatherModel)
    }
    
    //MARK: - SettingUp UI Elements

    private func setupScrollView() {
        scrollView.contentSize = CGSize(width: view.frame.width,
                                        height: view.frame.height + tableView.frame.height + 20)
    
    }
    
    private func configTopView() {
        topView.delegate = self
        self.setupToHideKeyboardOnTapOnView(action: #selector(stopSearchingByTap))
    }
    
    private func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.frame = .zero
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        
        collectionView.register(WeatherCollectionCell.self, forCellWithReuseIdentifier: WeatherCollectionCell.identifier)
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(WeatherTableCell.self, forCellReuseIdentifier: WeatherTableCell.identifier)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
    }
    
    private func configBackgroundWhiteView() {
        backgroundWhiteView.backgroundColor = .white
        backgroundWhiteView.layer.cornerRadius = Constants.Radius.backgroundWhiteView
        backgroundWhiteView.clipsToBounds = true
        backgroundWhiteView.layer.zPosition = -1
        backgroundWhiteView.isUserInteractionEnabled = false
    }
    
    private func configWeatherCardView() {
        weatherCardView.layer.cornerRadius = Constants.Radius.weatherCard
    }
    
    
    //MARK: - @objc Methods
    
    @objc private func stopSearchingByTap() {
        topView.stopEditing()
    }
}

extension WeatherViewController {

    //MARK: - Overriding parent methods
    
    override func configure() {
        super.configure()
        getLocationWhenLaunch()
        subscribeOnChanges()
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        configTopView()
        configCollectionView()
        configBackgroundWhiteView()
        configWeatherCardView()
        configTableView()
    }
    
    override func addSubviews() {
        view.addSubview(topView)
        view.addSubview(scrollView)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(backgroundWhiteView)
        scrollView.addSubview(weatherCardView)
        scrollView.addSubview(tableView)
    }
    
    override func layoutConstraints() {
        
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.leading.equalTo(view)
            make.height.equalTo(Constants.Sizes.topViewHeigt)
        }
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(view.snp.height).multipliedBy(Constants.Sizes.collectionViewMultiplier)
        }
        
        backgroundWhiteView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(C.Offset.big*3)
            make.top.equalTo(collectionView.snp.bottom).offset(Constants.Sizes.backgroundWhiteViewTopOffset)
            make.leading.trailing.equalTo(view)
        }
        
        weatherCardView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(view.frame.height*0.08).priority(.low)
            make.leading.equalTo(view).offset(C.Offset.medium)
            make.trailing.equalTo(view).inset(C.Offset.medium)
            make.height.equalTo(view).multipliedBy(Constants.Sizes.weatherCardHeightMultiplier)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
            make.top.equalTo(weatherCardView.snp.bottom).offset(C.Offset.medium)
        }
    }
}

//MARK: - Working with UICollectionView

extension WeatherViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionCell.identifier, for: indexPath) as! WeatherCollectionCell
        let cellModel = viewModel.getCollectionCellModel(at: indexPath)
        cell.setView(with: cellModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        bindWeatherCard(at: indexPath)
    }
}

//MARK: - Working with UITableView

extension WeatherViewController : UITableViewDelegate, UITableViewDataSource {
    
    private enum Table {
        static let cellHeightMultiplier : CGFloat = 0.09
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableCell.identifier, for: indexPath) as! WeatherTableCell
        let cellModel = viewModel.getTableCellModel(at: indexPath)
        cell.setView(with: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let multiplier = Table.cellHeightMultiplier
        return view.frame.height*multiplier + C.Offset.medium
    } 
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        return String.tableHeader
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.presentDetailedForecast(navigationController, at: indexPath)
    }
}

//MARK: - Working with TopViewDelegate

extension WeatherViewController : TopViewSearchDelegate {
    
    func searchWeather(for city: String) {
        viewModel.getWeather(for: city)
    }
    
}



