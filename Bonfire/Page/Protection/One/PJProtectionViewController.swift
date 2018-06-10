//
//  PJProtectionViewController.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/6/7.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

class PJProtectionViewController: PJBaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let dateArray = ["10", "20", "30", "40", "50", "60", "手动停止"]

    private var datePickerView: UIPickerView?
    private var dateLabel: UILabel?
    private var addButton: UIButton?
    private var minusButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {
        title = "保护时间"
        view.backgroundColor = .black
        navigationController?.navigationBar.shadowImage = UIImage.init()

        leftBarButtonItemAction(action: #selector(cancelBarButtonClick))
        rightBatButtonItemAction(action: #selector(nextVC), title: "下一步")
        
        datePickerView = {
            let pickerView = UIPickerView.init(frame: CGRect.init(x: 0, y: (navBar?.height)!, width: PJSCREEN_WIDTH * 0.8, height: PJSCREEN_WIDTH * 0.8))
            pickerView.centerX = view.centerX
            pickerView.setValue(UIColor.red, forKeyPath: "textColor")
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.selectRow(0, inComponent: 0, animated: true)
            view.addSubview(pickerView)
            
            return pickerView
        }()
        
        dateLabel = {
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: PJSCREEN_WIDTH / 2, height: 50))
            label.centerX = view.centerX
            label.bottom = (datePickerView?.bottom)! + 100
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            label.text = dateArray[0]
            label.layer.cornerRadius = 8.0
            label.layer.borderColor = UIColor.darkGray.cgColor
            label.layer.borderWidth = 1
            view.addSubview(label)
            
            return label
        }()
        
        minusButton = {
            let button = UIButton.init(frame: CGRect.init(x: 0, y: (dateLabel?.y)!,
                                                          width: 50, height: 50))
            button.x = ((dateLabel?.x)! - 50) / 2
            button.addTarget(self, action: #selector(minusButtonClick), for: .touchUpInside)
            button.backgroundColor = UIColor.darkGray
            button.setTitle("－", for: .normal)
            button.layer.cornerRadius = 8.0
            view.addSubview(button)
            
            return button
        }()
        
        addButton = {
            let button = UIButton.init(frame: CGRect.init(x: 0, y: (dateLabel?.y)!,
                                                          width: 50, height: 50))
            button.x = (PJSCREEN_WIDTH - (dateLabel?.right)! - 50) / 2 + (dateLabel?.right)!
            button.addTarget(self, action: #selector(addButtonClick), for: .touchUpInside)
            button.backgroundColor = UIColor.darkGray
            button.setTitle("＋", for: .normal)
            button.layer.cornerRadius = 8.0
            view.addSubview(button)
            
            return button
        }()
        
    }
    
    @objc private func cancelBarButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func nextVC() {
        let vc = PJBlockProcessViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: button methon
    
    @objc private func addButtonClick() {
        let time = Int((dateLabel?.text)!)! + 1
        dateLabel?.text = "\(time)"
    }
    
    @objc private func minusButtonClick() {
        var time = Int((dateLabel?.text)!)! - 1
        if time <= 0 {
            time = 0
        }
        dateLabel?.text = "\(time)"
    }
    
    // MARK: pickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dateArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = dateArray[row]
        if row == dateArray.count - 1 {
            return NSAttributedString(string: string,
                                      attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        }
        return NSAttributedString(string: string + "分钟",
                                  attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dateLabel?.text = dateArray[row]
        if dateLabel?.text == "手动停止" {
            UIView.animate(withDuration: 0.25, animations: {
                self.addButton?.alpha = 0
                self.minusButton?.alpha = 0
            }) { (animated) in
                if animated {
                    self.addButton?.isHidden = true
                    self.minusButton?.isHidden = true
                }
            }
        } else {
            self.addButton?.isHidden = false
            self.minusButton?.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                self.addButton?.alpha = 1
                self.minusButton?.alpha = 1
            })
        }
    }
    
}
