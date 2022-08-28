//
//  NotificationManager.swift
//  GiorgiPilishvili_Homework25
//
//  Created by GIORGI PILISSHVILI on 27.08.22.
//

import UIKit

struct NotificationManager {
    
    static let shared = NotificationManager()
    
    func register(notification: Notification, userInfo: [AnyHashable:Any], date: Date, repeats: Bool) {
        let userNotification = UNUserNotificationCenter.current()
        
        userNotification.requestAuthorization(options: [.badge, .alert]) { granted, error in
            guard error == nil else { return }
            
            if granted {
                DispatchQueue.main.async {
                    addNotification(notification: notification, userInfo: userInfo, date: date, repeats: repeats)
                }
            }
            
        }
        
    }
    
    func addNotification(notification: Notification, userInfo: [AnyHashable:Any], date: Date, repeats: Bool) {
        
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.message
        content.sound = .default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        content.userInfo = userInfo
                
//        let dateComponents = Calendar.current.dateComponents(Set(arrayLiteral: Calendar.Component.year, Calendar.Component.month, Calendar.Component.day), from: date)
        
        let targetDate = date
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                
        let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { error in
            
            guard error == nil else { return }
            
        }
        
    }
    
}
