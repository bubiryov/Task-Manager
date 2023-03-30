//
//  Extensions.swift
//  Task Manager
//
//  Created by Egor Bubiryov on 01.03.2023.
//

import Foundation
import SwiftUI
import CoreData

extension Color {
    static let tabBarColor = Color("TabBarColor")
    static let backgroundColor = Color("BackgroundColor")
    static let textColor = Color("TextColor")
}

// Меняет цвет TextField
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension Date {
    func formatted() -> String {
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMM yyyy HHmm")
        return dateFormatter.string(from: self)
    }
}

//Сворачивает клавиатуру
extension UIApplication {
    func endEditing(_ force: Bool) {
        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .endEditing(force)
    }
}

//Ответ с gitgub, убирающий ошибки в консоли
public extension NSManagedObject {

    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
