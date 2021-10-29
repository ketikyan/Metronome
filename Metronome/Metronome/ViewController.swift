//
//  ViewController.swift
//  Metronome
//
//  Created by Tatevik Ketikyan on 25.09.21.
//

import UIKit
import AVFoundation

extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }
}

private extension UIView {
    func rotate(by angle: CGFloat, around point: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
        let translation = CGPoint(x: (point.x - 0.5) * frame.width, y: (point.y - 0.5) * frame.height)
        transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        transform = transform.rotated(by: angle)
        transform = transform.translatedBy(x: -translation.x, y: -translation.y)
    }
}


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var picker: UIPickerView!
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentValueOfPicker = pickerData[row]
    }
    var currentValueOfPicker = "1"

    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var sliderValue: UISlider!
    @IBAction func plusBeat(_ sender: UIButton) {
        beatsPerMinute += 1
        bpmLabel.text = "\(beatsPerMinute + 1)"
        sliderValue.value = Float(beatsPerMinute)
    }
    
    @IBAction func minusBeat(_ sender: UIButton) {
        beatsPerMinute -= 1
        bpmLabel.text = "\(beatsPerMinute - 1)"
        sliderValue.value = Float(beatsPerMinute)
    }

    @IBAction func beatsSlider(_ sender: UISlider, forEvent event: UIEvent) {
            bpmLabel.text = "\(Int(sender.value))"
            beatsPerMinute = Int(sender.value)
            ticking = 60 / Double(beatsPerMinute)
            time?.invalidate()
            time = Timer.scheduledTimer(timeInterval: ticking, target: self, selector: #selector(animateImage), userInfo: nil, repeats: true)

    }


    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func buttonSelected(_ sender: UIButton) {
        
        switch titleLabel.text {
            case "START!":
                time = Timer.scheduledTimer(timeInterval: ticking, target: self, selector: #selector(animateImage), userInfo: nil, repeats: true)
                titleLabel.text = "STOP!"
                
            case "STOP!":
                titleLabel.text = "START!"
                time?.invalidate()
                arrowImage.rotate(by: 0, around: CGPoint(x: 0.5, y: 0.9))
                counter = 0
            default:
                break
            }
    }
    
    var player: AVAudioPlayer!
    var beatsPerMinute = 60
    var ticking : Double = 0.0
    var time : Timer?
    var counter = 0
    var tikQuantity = 1
    var pickerData : [String] = ["1", "2", "3", "4", "5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.2329238951, green: 0.2315456867, blue: 0.2339874804, alpha: 1)
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        sliderValue.value = Float(beatsPerMinute)
        bpmLabel.text = String(beatsPerMinute)
        
        ticking = 60 / Double(beatsPerMinute)
    }
    
    
    
    @objc func animateImage() {
        self.counter += 1
        if self.counter % 2 == 0 {
            self.arrowImage.setAnchorPoint(CGPoint(x: 0.5, y: 0.72))
            UIView.animate(withDuration: ticking) {
                self.arrowImage.transform = CGAffineTransform(rotationAngle: .pi / 6)
            } completion: { _  in
                self.playSound()
            }
        } else {
            self.arrowImage.setAnchorPoint(CGPoint(x: 0.5, y: 0.72))
            UIView.animate(withDuration: ticking) {
                self.arrowImage.transform = CGAffineTransform(rotationAngle: -.pi / 6)
            } completion: { _  in
                self.playSound()
            }
        }
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "C", withExtension: "wav")
        let url2 = Bundle.main.url(forResource: "D", withExtension: "wav")
        tikQuantity = Int(currentValueOfPicker)!
        if currentValueOfPicker == "1" || counter % tikQuantity == 1 {
            player = try! AVAudioPlayer(contentsOf: url!)
        } else {
            player = try! AVAudioPlayer(contentsOf: url2!)
        }
        player.play()
    }
}

