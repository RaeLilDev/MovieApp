//
//  BaseRepository.swift
//  Starter
//
//  Created by Ye Lynn Htet on 29/03/2022.
//

import Foundation

import Foundation
import CoreData

class BaseRepository: NSObject {
    let coreData = CoreDataStack.shared
    
    func handleCoreDataError(_ anError: Error?) -> String {
        if let anError = anError,
           (anError as NSError).domain == "NSCocoaErrorDomain" {
            let nsError = anError as NSError
            
            var errors: [AnyObject] = []
            
            if nsError.code == NSValidationMultipleErrorsError {
                errors = nsError.userInfo[NSDetailedErrorsKey] as? [AnyObject] ?? [AnyObject]()
            } else {
                errors = [nsError].compactMap { $0 }
            }
            
            return errors.reduce("Reason(s):\n") { result, error -> String in
                guard let error = error as? Error else {
                    return ""
                }
                let entityName = ((error as NSError).userInfo["NSValidationErrorObject"] as! NSManagedObject).entity.name
                let attributeName = (error as NSError).userInfo["NSValidationErrorKey"]!
                var msg: String = ""
                switch (error as NSError).code {
                case NSManagedObjectValidationError:
                    msg = "Generic validation error."
                    
                case NSValidationMissingMandatoryPropertyError:
                    msg = "The attribute '\(attributeName)' mustn't be empty."
                    
                case NSValidationRelationshipLacksMinimumCountError:
                    msg = "The relationship \(attributeName) doesn't have enough entries."
                    
                case NSValidationRelationshipExceedsMaximumCountError:
                    msg = "The relationship \(attributeName) has too many entries."
                    
                case NSValidationRelationshipDeniedDeleteError:
                    msg = "To delete, the relationship \(attributeName) must be empty."
                    
                case NSValidationNumberTooLargeError:
                    msg = "The number of the attribute '\(attributeName)' is too large."
                    
                case NSValidationNumberTooSmallError:
                    msg = "The number of the attribute '\(attributeName)' is too small."
                    
                case NSValidationDateTooLateError:
                    msg = "The date of the attribute '\(attributeName)' is too late."
                    
                case NSValidationDateTooSoonError:
                    msg = "The date of the attribute '\(attributeName)' is too soon."
                    
                case NSValidationInvalidDateError:
                    msg = "The date of the attribute '\(attributeName)' is invalid."
                    
                case NSValidationStringTooLongError:
                    msg = "The text of the attribute '\(attributeName)' is too long."
                    
                case NSValidationStringTooShortError:
                    msg = "The text of the attribute '\(attributeName)' is too short."
                    
                case NSValidationStringPatternMatchingError:
                    msg = "The text of the attribute '\(attributeName)' doesn't match the required pattern."
                    
                default:
                    msg = String(format:"Unknown error (code %i).", (error as NSError).code)
                    
                }
                return "\(result)\(String(describing: entityName)):\(msg)\n"
            }
            
        } else {
            return "undefined error: coredata error nil"
        }
    }
}
