//
//  TopView.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 17.03.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


protocol TopViewSearchDelegate : AnyObject {
    func searchWeather(for city: String)
}

final class TopView : BaseView {
    
    //MARK: - Properties
    weak var delegate : TopViewSearchDelegate?
    private let disposeBag = DisposeBag()
    
    // Свойство для определения активного состояния searchBar.
    // isSearching = true при нажатии кнопки и раскрытии searchBar.
    // isSearching = false когда жмем энтер в серчбаре
    private var isSearching: Bool = false {
        didSet {
            if isSearching {
                setIsSearching()
            } else {
                setNotSearching()
            }
            updateSearchingConstraints()
            animateSearchBarWidthChange()
        }
    }
    
    // Свойство для хранения ширины searchBar и searchButton
    private var searchBarWidth: CGFloat = 0
    private var searchButtonWidth: CGFloat = 0
    
    //MARK: - UI Elementes

    private let searchButton = UIButton()
    private let cityLabel = UILabel()
    private lazy var searchBar = UISearchBar()
    
    //MARK: - Public methods

    // Установка извне лейбла городка
    public func setCity(name: String) {
        cityLabel.text = name
    }
    
    public func stopEditing() {
        searchBar.resignFirstResponder()
        isSearching = false
        searchBar.text = nil
    }

    //MARK: - Private methods
    /// Conifuring animations
    
    // отрабатывает в обсервере isSearching = true
    private func setIsSearching() {
        searchBar.becomeFirstResponder()
        searchButtonWidth = 0
        searchBarWidth = frame.width - C.Offset.medium*2
        changeAlpha(view: searchBar, alpha: 1)
        changeAlpha(view: cityLabel, alpha: 0)
    }
    
    // отрабатывает в обсервере isSearching = false
    private func setNotSearching() {
        searchBar.resignFirstResponder()
        searchBarWidth = 0
        searchButtonWidth = frame.height*0.75
        changeAlpha(view: searchBar, alpha: 0)
        changeAlpha(view: cityLabel, alpha: 1)
    }
    
    // Меняет прозрачность компонентов, необходимо для плавности анимации
    private func changeAlpha(view: UIView, alpha: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            view.alpha = alpha
        }
    }
    
    // Метод для анимации изменения ширины searchBar
    private func animateSearchBarWidthChange() {
      UIView.animate(withDuration: 0.5) {
          self.layoutIfNeeded()
      }
    }
    
    // вызывается в обсервере isSearching каждый раз и меняет ширину Search элементов в зависимости от состояния isSearching и searchBarWidth&searchButtonWidth
    private func updateSearchingConstraints() {
        searchBar.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(C.Offset.medium)
            make.height.equalToSuperview().multipliedBy(0.75)
            make.width.equalTo(searchBarWidth) // Используем searchBarWidth для ширины
        }
        
        searchButton.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(C.Offset.medium)
            make.height.equalToSuperview().multipliedBy(0.75)
            make.width.equalTo(searchButtonWidth) // Используем searchBarWidth для ширины
        }
    }
    
    /// SettingUP UI Elements
    private func configSearchBar() {
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = C.Colors.text
        searchBar.keyboardType = .alphabet
    }
    
    private func configCityLabel() {
        cityLabel.font = UIFont.C.poppins(size: 24, weight: .title)
        cityLabel.textColor = C.Colors.text
    }
    
    private func configSearchButton() {
        searchButton.setImage(C.Image.search, for: .normal)
        searchButton.contentMode = .scaleAspectFit
        searchButton.tintColor = C.Colors.text
        
        searchButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.isSearching = true
            print("yay")
        }).disposed(by: disposeBag)
    }

}

extension TopView {
    
    override func configureAppearance() {
        configSearchBar()
        configCityLabel()
        configSearchButton()
    }
    
    override func addSubviews() {
        addSubview(searchButton)
        addSubview(cityLabel)
        addSubview(searchBar)
    }
    
    override func layoutConstraints() {
        
        searchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(C.Offset.medium)
            make.width.equalTo(searchButton.snp.height).multipliedBy(1.0) // Устанавливаем пропорциональную ширину
            make.height.equalToSuperview().multipliedBy(0.75)
        }
        
        cityLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(C.Offset.medium)
        }
        
        searchBar.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(C.Offset.medium)
            make.height.equalToSuperview().multipliedBy(0.75)
            make.width.equalTo(searchButton.snp.height).multipliedBy(0) // Устанавливаем пропорциональную ширину
        }
    }
}

extension TopView : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        delegate?.searchWeather(for: text)
        stopEditing()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        stopEditing()
    }
    
    // устанавливаем свой шрифт и цвет для текста в UISearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if let textField = searchBar.value(forKey: "searchField") as? UITextField {
                textField.font = UIFont.C.avantGarge(size: 20, weight: .medium)
                textField.textColor = C.Colors.text
            }
        }
    
}
