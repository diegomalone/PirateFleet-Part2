//
//  ControlCenter.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 9/2/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

struct GridLocation {
    let x: Int
    let y: Int
}

struct Ship {
    let length: Int
    let location: GridLocation
    let isVertical: Bool
    let isWooden: Bool
    

    var cells: [GridLocation] {
        get {
            let start = self.location
            let end: GridLocation = ShipEndLocation(self)
            
            var occupiedCells = [GridLocation]()
            
            for i in 0 ..< self.length {
                var x = start.x
                var y = start.y
                
                if start.x != end.x {
                    x += i
                } else {
                    y += i
                }
                
                occupiedCells.append(GridLocation(x: x, y: y))
            }

            return occupiedCells
        }
    }
    
    var hitTracker: HitTracker

    var sunk: Bool {
        get {
            for gridLocation in cells {
                if hitTracker.cellsHit[gridLocation] == false {
                    return false
                }
            }
         
            return true
        }
    }

    init(length: Int, location: GridLocation, isVertical: Bool) {
        self.length = length
        self.location = location
        self.isVertical = isVertical
        self.hitTracker = HitTracker()
        self.isWooden = false
    }
    
    init(length: Int, location: GridLocation, isVertical: Bool, isWooden: Bool) {
        self.length = length
        self.location = location
        self.isVertical = isVertical
        self.hitTracker = HitTracker()
        self.isWooden = isWooden
    }
}

// TODO: Change Cell protocol to PenaltyCell and add the desired properties
protocol Cell {
    var location: GridLocation {get}
}

// TODO: Adopt and implement the PenaltyCell protocol
struct Mine: Cell {
    let location: GridLocation

}

// TODO: Adopt and implement the PenaltyCell protocol
struct SeaMonster: Cell {
    let location: GridLocation
}

class ControlCenter {
    
    func placeItemsOnGrid(human: Human) {
        
        let smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: true, isWooden: true)
        human.addShipToGrid(smallShip)
        print(smallShip.cells)
        
        let mediumShip1 = Ship(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false)
        human.addShipToGrid(mediumShip1)
        print(mediumShip1.cells)
        
        let mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false)
        human.addShipToGrid(mediumShip2)
        print(mediumShip2.cells)
        
        let largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true, isWooden: true)
        human.addShipToGrid(largeShip)
        print(largeShip.cells)
        
        let xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true)
        human.addShipToGrid(xLargeShip)
        print(xLargeShip.cells)
        
        let mine1 = Mine(location: GridLocation(x: 6, y: 0))
        human.addMineToGrid(mine1)
        
        let mine2 = Mine(location: GridLocation(x: 3, y: 3))
        human.addMineToGrid(mine2)
        
        let seamonster1 = SeaMonster(location: GridLocation(x: 5, y: 6))
        human.addSeamonsterToGrid(seamonster1)
        
        let seamonster2 = SeaMonster(location: GridLocation(x: 2, y: 2))
        human.addSeamonsterToGrid(seamonster2)
    }
    
    func calculateFinalScore(gameStats: GameStats) -> Int {
        
        var finalScore: Int
        
        let sinkBonus = (5 - gameStats.enemyShipsRemaining) * gameStats.sinkBonus
        let shipBonus = (5 - gameStats.humanShipsSunk) * gameStats.shipBonus
        let guessPenalty = (gameStats.numberOfHitsOnEnemy + gameStats.numberOfMissesByHuman) * gameStats.guessPenalty
        
        finalScore = sinkBonus + shipBonus - guessPenalty
        
        return finalScore
    }
}