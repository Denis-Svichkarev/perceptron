//
//  ViewController.swift
//  Perceptron
//
//  Created by Denis Svichkarev on 6/14/19.
//  Copyright © 2019 Denis Svichkarev. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    @IBOutlet var chartView: LineChartView!
    @IBOutlet weak var testImageView: UIImageView!
    
    @IBOutlet weak var inputLayerTextField: UITextField!
    @IBOutlet weak var hiddenLayerTextField: UITextField!
    @IBOutlet weak var outputLayerTextField: UITextField!
    
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var testDataTextField: UITextField!
    @IBOutlet weak var trainingDataTextField: UITextField!
    
    @IBOutlet weak var consoleTextView: UITextView!
    
    let trainingDataFileName = "ex3-training" + ".txt"
    let testDataFileName     = "ex3-test" + ".txt"
    
    let importModelFileName  = "weights 11.05.20 20-01-05" + ".txt"
    let networkStucture      = [400, 2, 2]
    
    var network: NeuralNetwork?
    var trainingData: (data: [[Float]], results: [[Float]])?
    var testData: [[Float]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let trainingDataString = convertImagesToText()
//        writeToFileString("ex3-test", text: trainingDataString)
//
//        return
        
        consoleTextView.delegate = self
        
        navigationItem.title = "Perceptron"
        GraphBuilder.configure(chartView: chartView)
    }
    
    func convertImagesToText() -> String {
        var trainingString = ""
        
        if let imageURLArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: "") {
            for imageURL in imageURLArray {
                if let image = UIImage(contentsOfFile: imageURL.path) {
                    if imageURL.path.contains("A-letter") && imageURL.path.contains("test") {
                        trainingString.append("1;0:")
                    } else if imageURL.path.contains("C-letter") && imageURL.path.contains("test") {
                        trainingString.append("0;1:")
                    }
                    if imageURL.path.contains("test") {
                        //let grayImage = convertImageToBW(image: image) // CoreImageService.convert(toGreyscale: image)
                        
                        if let pixelData = image.pixelData() {
                            testImageView.image = getUIImageFromPixelData(data: pixelData)
                        }
                        
                        trainingString.append(getImagePixelDataString(image: image))
                    }
                }
            }
        }
        
        return trainingString
    }
    
    func getImagePixelDataString(image: UIImage) -> String {
        if let pixelData = image.pixelData() {
            var resultString = ""
            for value in pixelData {
                resultString.append("\(value);")
                
            }
            resultString.append("\n")
            return resultString
            
        } else {
            return ""
        }
    }
    
    func getUIImageFromPixelData(data: [UInt8]) -> UIImage? {
        var pixelData = [PixelData]()
        
        var i = 0
        while true {
            if i + 3 >= data.count {
                break
            }
            
            pixelData.append(PixelData(a: 255, r: data[i + 1], g: data[i + 2], b: data[i + 3]))
            //print("\(pixelData.last!.a):\(pixelData.last!.r):\(pixelData.last!.g):\(pixelData.last!.b)")
            i += 4
        }
        
        let image = UIImage.imageFromARGB32Bitmap(pixels: pixelData, width: Int(pow(Double(pixelData.count), 0.5)), height: Int(pow(Double(pixelData.count), 0.5)))
        return image
    }
    
    // MARK: - IB Actions - Settings
    
    @IBAction func applySettings(_ sender: Any) {
        network = NeuralNetwork(inputLayerSize: networkStucture[0], hiddenLayerSize: networkStucture[1], outputLayerSize: networkStucture[2])
    }
    
    // MARK: - IB Actions - Data
    
    @IBAction func importTrainingData(_ sender: Any) {
        guard let network = network else {
            output(text: "Model is empty")
            return
        }
        
        guard let trainingData = network.importTrainingData(name: trainingDataFileName) else {
            output(text: "Training data is empty")
            return
        }
        
        self.trainingData = trainingData
    }
    
    @IBAction func importTestData(_ sender: Any) {
        guard let network = network else {
            output(text: "Model is empty")
            return
        }
        
        guard let testData = network.importTestData(name: testDataFileName) else {
            output(text: "Test data is empty")
            return
        }
        
        self.testData = testData
    }
    
    @IBAction func importModel(_ sender: Any) {
        guard let network = network else {
            output(text: "Model is empty")
            return
        }
        
        network.importModel(name: importModelFileName)
    }
    
    // MARK: - IB Actions - Training
    
    @IBAction func runModel(_ sender: Any) {
        guard let network = network else {
            output(text: "Model is empty")
            return
        }
        
        guard let trainingData = trainingData else {
            output(text: "Training data is empty")
            return
        }
        
        network.run(input: trainingData.data, targetOutput: trainingData.results)
        
        if network.averageErrors.count > 0 {
            GraphBuilder.draw(chartView: chartView, data: network.averageErrors)
        }
    }
    
    @IBAction func exportModel(_ sender: Any) {
        guard let network = network else {
            output(text: "Model is empty")
            return
        }
        
        network.exportModel()
    }
    
    // MARK: - IB Actions - Prediction
    
    @IBAction func predict(_ sender: Any) {
        guard let network = network else {
            output(text: "Model is empty")
            return
        }
        
        guard let testData = network.importTestData(name: testDataFileName) else {
            output(text: "Test data is empty")
            return
        }
        
        let predictionsString = Log.getPredictionsString(network: network, data: testData)
        output(text: predictionsString)
    }
    
    // MARK: - Helpers
    
    func output(text: String) {
        consoleTextView.text += text + "\n"
        let bottom = consoleTextView.contentSize.height - consoleTextView.bounds.size.height
        if bottom > 0 {
            consoleTextView.setContentOffset(CGPoint(x: 0, y: bottom), animated: true)
        }
        print(text)
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.contains("- clear") {
            textView.text = ""
        }
    }
}
