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
    
    @IBOutlet weak var iterationsTextField: UITextField!
    @IBOutlet weak var learningRateTextField: UITextField!
    @IBOutlet weak var momentumTextField: UITextField!
    
    @IBOutlet weak var consoleTextView: UITextView!
    
    var inputLayerString = "4"
    var hiddenLayerString = "2"
    var ouputLayerString = "2"
    
    var importModelFileName  = "weights 11.05.20 20-48-48" + ".txt"
    var testDataFileName     = "ex2-test" + ".txt"
    var trainingDataFileName = "ex2-training" + ".txt"
    
    var iterations = "\(NeuralNetwork.iterations)"
    var learningRate = "\(NeuralNetwork.learningRate)"
    var momentum = "\(NeuralNetwork.momentum)"
    
    var network: NeuralNetwork?
    var trainingData: (data: [[Float]], results: [[Float]])?
    var testData: [[Float]]?
    
    // MARK: - Controller Lyfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let trainingDataString = convertImagesToText()
//        writeToFileString("ex3-test", text: trainingDataString)
//
//        return
        
        inputLayerTextField.text = inputLayerString
        hiddenLayerTextField.text = hiddenLayerString
        outputLayerTextField.text = ouputLayerString
        
        modelTextField.text = importModelFileName
        testDataTextField.text = testDataFileName
        trainingDataTextField.text = trainingDataFileName
        
        iterationsTextField.text = iterations
        learningRateTextField.text = learningRate
        momentumTextField.text = momentum
        
        consoleTextView.delegate = self
        
        inputLayerTextField.delegate = self
        hiddenLayerTextField.delegate = self
        outputLayerTextField.delegate = self
        
        modelTextField.delegate = self
        testDataTextField.delegate = self
        trainingDataTextField.delegate = self
        
        iterationsTextField.delegate = self
        learningRateTextField.delegate = self
        momentumTextField.delegate = self
        
        navigationItem.title = "Perceptron"
        GraphBuilder.configure(chartView: chartView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationReceieved), name: NSNotification.Name(rawValue: "NeuralNetworkNotification"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notifications
    
    @objc func onNotificationReceieved(notification: NSNotification) {
        if let text = notification.object as? String {
            output(text: text)
        }
    }
    
    // MARK: - Image processing
    
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
        guard let inputText = inputLayerTextField.text, let inputLayer = Int(inputText) else {
            output(text: "Incorrect input layer")
            return
        }
        
        guard let hiddenText = hiddenLayerTextField.text, let hiddenLayer = Int(hiddenText) else {
            output(text: "Incorrect hidden layer")
            return
        }
        
        guard let outputText = outputLayerTextField.text, let outputLayer = Int(outputText) else {
            output(text: "Incorrect output layer")
            return
        }
        
        NeuralNetwork.iterations = Int(iterations) ?? 10
        NeuralNetwork.learningRate = Float(learningRate) ?? 0.3
        NeuralNetwork.momentum = Float(momentum) ?? 1
        
        network = NeuralNetwork(inputLayerSize: inputLayer, hiddenLayerSize: hiddenLayer, outputLayerSize: outputLayer)
        output(text: "Successful Neural network initialization")
    }
    
    // MARK: - IB Actions - Data
    
    @IBAction func importTrainingData(_ sender: Any) {
        guard let network = network else {
            output(text: "Neural network is not initialized")
            return
        }
        
        guard let trainingData = network.importTrainingData(name: trainingDataFileName) else {
            output(text: "Training data is empty")
            return
        }
        
        self.trainingData = trainingData
        output(text: "Imported training data: \(trainingDataFileName)")
    }
    
    @IBAction func importTestData(_ sender: Any) {
        guard let network = network else {
            output(text: "Neural network is not initialized")
            return
        }
        
        guard let testData = network.importTestData(name: testDataFileName) else {
            output(text: "Test data is empty")
            return
        }
        
        self.testData = testData
        output(text: "Imported test data: \(testDataFileName)")
    }
    
    @IBAction func importModel(_ sender: Any) {
        guard let network = network else {
            output(text: "Neural network is not initialized")
            return
        }
        
        network.importModel(name: importModelFileName)
        output(text: "Imported model: \(importModelFileName)")
    }
    
    // MARK: - IB Actions - Training
    
    @IBAction func runModel(_ sender: Any) {
        guard let network = network else {
            output(text: "Neural network is not initialized")
            return
        }
        
        guard let trainingData = trainingData else {
            output(text: "Training data is empty")
            return
        }
        
        output(text: "Training...")
        
        DispatchQueue.global().async {
            network.run(input: trainingData.data, targetOutput: trainingData.results)

            DispatchQueue.main.async {
                self.output(text: "Finish")
                
                if network.averageErrors.count > 0 {
                    GraphBuilder.draw(chartView: self.chartView, data: network.averageErrors)
                }
            }
        }
    }
    
    @IBAction func exportModel(_ sender: Any) {
        guard let network = network else {
            output(text: "Neural network is not initialized")
            return
        }
        
        network.exportModel()
    }
    
    // MARK: - IB Actions - Prediction
    
    @IBAction func predict(_ sender: Any) {
        guard let network = network else {
            output(text: "Neural network is not initialized")
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

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case inputLayerTextField: inputLayerString = textField.text ?? ""
        case hiddenLayerTextField: hiddenLayerString = textField.text ?? ""
        case outputLayerTextField: ouputLayerString = textField.text ?? ""
            
        case modelTextField: importModelFileName = textField.text ?? ""
        case testDataTextField: testDataFileName = textField.text ?? ""
        case trainingDataTextField: trainingDataFileName = textField.text ?? ""
            
        case iterationsTextField: iterations = textField.text ?? ""
        case learningRateTextField: learningRate = textField.text ?? ""
        case momentumTextField: momentum = textField.text ?? ""
            
        default: break
        }
    }
}
