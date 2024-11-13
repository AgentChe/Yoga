//
//  Fonts.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

struct Fonts {
    // MARK: Inter
    struct Inter {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Inter-Bold", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Inter-Medium", size: size)!
        }
        
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "Inter-SemiBold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Inter-Regular", size: size)!
        }
        
        static func boldItalic(size: CGFloat) -> UIFont {
            UIFont(name: "Inter-BoldItalic", size: size)!
        }
    }
    
    // MARK: PlusJakartaSans
    struct PlusJakartaSans {
        static func extraBold(size: CGFloat) -> UIFont {
            UIFont(name: "PlusJakartaSans-ExtraBold", size: size)!
        }
        
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "PlusJakartaSans-Bold", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "PlusJakartaSans-Medium", size: size)!
        }
        
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "PlusJakartaSans-SemiBold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "PlusJakartaSans-Regular", size: size)!
        }
    }
}
