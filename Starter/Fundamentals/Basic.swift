//
//  Basic.swift
//  Starter
//
//  Created by Ye Lynn Htet on 30/01/2022.
//

import Foundation
//array declaration
var colorList = ["red", "green", "blue"]
//set declaration
var regionList: Set = ["Yangon", "Mandalay"]
//dictionary declaration
var townshipList = ["Yangon": ["Tamwe", "Yankin", "Hlaing"]]

var doOnNext: (String) -> String = {_ ->String in ""}

func main() {
    
    //mutable variables
    var name = "Co Rae"
    name = "Ko Ye"
    debugPrint(name)
    
    //append in list
    colorList.append("orange")
    
    //get data from dictionary
    let townships = townshipList["Yangon"]
    debugPrint(townships ?? [])
    
    //for in loop
    for color in colorList {
        debugPrint(color)
    }
    
    //while loop
    var indexForWhile = 0
    while indexForWhile < 3 {
        debugPrint(colorList[indexForWhile])
        indexForWhile += 1
    }
    
    //repeat while loop
    var indexForRepeatWhile = 0
    repeat {
        debugPrint(colorList[indexForRepeatWhile])
        indexForRepeatWhile += 1
    } while(indexForRepeatWhile < 3)
    
    
    doOnNext = { name -> String in
        return "Hello \(name)"
    }
    
    debugPrint(doOnNext(name))
    
    
    //trailing closure
    decrease(total: 10) {
        debugPrint("Do Decrease")
    }
}

func increment(amount: Int)->()->Int {
    var total = 0
    func doProcess()->Int{
        total += amount
        return total
    }
    return doProcess
}

func decrease(total: Int, doDecrease: ()->Void)->Void {
    debugPrint("decrease")
}
