//
//  ViewController.swift
//  RompeCabezas
//
//  Created by osvaldo lopez on 3/25/18.
//  Copyright © 2018 osvaldo lopez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Board: UIView!
    var tileWidth: CGFloat = 0.0

    var tileCenterx: CGFloat = 0.0
    var tileCentery: CGFloat = 0.0
    
    var tileArray: NSMutableArray = []
    var tilecenter: NSMutableArray = []
    var emptyTileCenter: CGPoint = CGPoint(x: 0, y: 0)
    var imageSlices: [UIImage] = []
    
    @IBAction func resetBtn(_ sender: Any) {
        self.ramdonTile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "imageTest.jpg")
        let slices = self.slice(image: image!, into: 16)
        self.imageSlices = slices
        print(slices.count)
        self.setBoardAndTile()
        self.ramdonTile()
    }
    
    private func setBoardAndTile() {
        self.tileArray = []
        self.tilecenter = []
        
        let boardWidth = self.Board.frame.size.width
        self.tileWidth = boardWidth / 4
        self.tileCenterx = self.tileWidth / 2
        self.tileCentery = self.tileWidth / 2
        var tileNumber = 0
        for _ in 0..<4{
            for _ in 0..<4 {
                //CGRect = Core Gaphics
                
                let tileFrame = CGRect(x: 0, y: 0, width: self.tileWidth - 2, height: self.tileWidth - 2)
                let tile =  customLabel(frame: tileFrame)
                let currentCenter = CGPoint(x: self.tileCenterx, y: self.tileCentery)
                self.Board.addSubview(tile)
                tileNumber = tileNumber + 1
                tile.center = currentCenter
                tile.originCenter = currentCenter
                tile.textAlignment = .center
                if tileNumber <= 16 {
                    tile.text = "\(tileNumber)"
                    tile.backgroundColor = UIColor(patternImage: self.imageSlices[tileNumber])
                } else {
                    tile.backgroundColor = .gray
                }
                tile.isUserInteractionEnabled = true
                
                self.tileArray.add(tile)
                self.tilecenter.add(currentCenter)
                self.tileCenterx = self.tileCenterx + self.tileWidth
                
            }
            self.tileCenterx = self.tileWidth / 2
            self.tileCentery = self.tileCentery + self.tileWidth
            
        }
        let lastTile: customLabel = self.tileArray.lastObject as! customLabel //Ger last object and remove it from view
        lastTile.removeFromSuperview()
        self.tileArray.removeObject(at: 15)
    }
    
    private func ramdonTile() {
        let tempTileCenterArray = self.tilecenter.mutableCopy() as! NSMutableArray
        for anyTile in self.tileArray {
            let ramdomIndex: Int = Int(arc4random()) % tempTileCenterArray.count
            let ramdomCenter: CGPoint = tempTileCenterArray[ramdomIndex] as! CGPoint
            (anyTile as! customLabel).center = ramdomCenter
            tempTileCenterArray.removeObject(at: ramdomIndex)
            
        }
        self.emptyTileCenter = tempTileCenterArray[0] as! CGPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let currentTouch: UITouch = touches.first!
        if (self.tileArray.contains(currentTouch.view as Any)) {
            //currentTouch.view?.alpha = 0
            let touchLabel: customLabel = currentTouch.view as! customLabel
            
            let xdif: CGFloat = touchLabel.center.x - self.emptyTileCenter.x
            let ydif: CGFloat = touchLabel.center.y - self.emptyTileCenter.y
            
            let distance: CGFloat = sqrt(pow(xdif, 2) + pow(ydif, 2))
            if distance == self.tileWidth {
                UIView.animate(withDuration: 0.3, animations: {
                    let tempCenter: CGPoint = touchLabel.center
                    touchLabel.center = self.emptyTileCenter
                    self.emptyTileCenter = tempCenter
                })
                
            }
        }
    }
    
    func slice(image: UIImage, into howMany: Int) -> [UIImage] {
        let width: CGFloat
        let height: CGFloat
        
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            width = image.size.height
            height = image.size.width
        default:
            width = image.size.width
            height = image.size.height
        }
        
        let tileWidth = Int(width / CGFloat(howMany))
        let tileHeight = Int(height / CGFloat(howMany))
        
        let scale = Int(image.scale)
        var images = [UIImage]()
        
        let cgImage = image.cgImage!
        
        var adjustedHeight = tileHeight
        
        var y = 0
        for row in 0 ..< howMany {
            if row == (howMany - 1) {
                adjustedHeight = Int(height) - y
            }
            var adjustedWidth = tileWidth
            var x = 0
            for column in 0 ..< howMany {
                if column == (howMany - 1) {
                    adjustedWidth = Int(width) - x
                }
                let origin = CGPoint(x: x * scale, y: y * scale)
                let size = CGSize(width: adjustedWidth * scale, height: adjustedHeight * scale)
                let tileCgImage = cgImage.cropping(to: CGRect(origin: origin, size: size))!
                images.append(UIImage(cgImage: tileCgImage, scale: image.scale, orientation: image.imageOrientation))
                x += tileWidth
            }
            y += tileHeight
        }
        return images
    }
    
}
extension CGFloat {
    static var random: CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var randomColor: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}

class customLabel: UILabel {
    var originCenter: CGPoint = CGPoint(x: 0, y: 0)
    
}
