//
//  CurrentCountryView.swift
//  Scratch Map
//
//  Created by Hugh Bellamy on 09/03/2018.
//  Copyright © 2018 Hugh Bellamy. All rights reserved.
//

import UIKit

public class CurrentCountryView : UIView {
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var nameDateConstraint: NSLayoutConstraint!
    @IBOutlet var dateBottomConstraint: NSLayoutConstraint!
    @IBOutlet var nameBottomConstraint: NSLayoutConstraint!

    public func setDateString(_ dateString: String?) {
        dateLabel.text = dateString

        let hasDate = dateString != nil
        nameBottomConstraint.isActive = !hasDate
        nameDateConstraint.isActive = hasDate

        UIView.animate(withDuration: 0.25, animations: {
            self.superview?.layoutIfNeeded()
        })
    }

    public func setHidden(_ hidden: Bool) {
        if isHidden == hidden {
            return
        }
        
        if !hidden {
            isHidden = false
        }
        
        heightConstraint.isActive = hidden
        UIView.animate(withDuration: 0.25, animations: {
            self.superview?.layoutIfNeeded()
        }, completion: { completed in
            if hidden {
                self.isHidden = true
            }
        })
    }
}
