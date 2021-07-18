//
//  ViewController.swift
//  VPIT
//
//  Created by Alhanouf Khalid on 05/12/1442 AH.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var usersListButton: UIButton!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    
    //MARK: - Variables
    var urlSession: URLSession? = nil
    var webSocketTask: URLSessionWebSocketTask? = nil
    

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup ui elements
        usersListButton.setupUI()
        statusButton.setupUI()
        textField.setupUI()
        textFieldView.layer.borderWidth = 0.2
        textFieldView.layer.borderColor = UIColor.systemGray.cgColor
        
        // Make the send button disables until connected to the websocket
        self.sendButton.isEnabled = false
        
        /// Handling the movement of view when keybord show in textfield editing
        /// Note: keyboardWillShow + keyboardWillHide functions exist in UIViewController extension
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    //MARK: - Handle pressing on connect and disconnect button
    @IBAction func connectButton(_ sender: Any) {
        // Configurate the url session and websocket task
        self.urlSession = URLSession(configuration: .default)
        self.webSocketTask = urlSession!.webSocketTask(with: URL(string: "wss://echo.websocket.org/")!)
        self.showSpinner()
        // Check if the button preselected to handle the switching between connect and disconnect
        if !connectButton.isSelected {
            // While it's not selected, connect tot the websocket and send a ping to ensure it's successfully connected
            webSocketTask!.resume()
            self.sendPing()
        } else {
            // While it's preselected, change the state to not selected and disconnect websocket
            self.connectButton.isSelected = !self.connectButton.isSelected
            webSocketTask!.cancel(with: .normalClosure, reason: nil)
            // Handle the ui elements to reflect disconnection state
            self.connectButton.setTitle("Connect", for: .normal)
            self.statusLabel.text = ""
            self.sendButton.isEnabled = false
            self.removeSpinner()
        }
    }
    
    //MARK: - Handle pressing on send button
    @IBAction func didPressedSendButton(_ sender: Any) {
        // Create object of text message contains the text inside textfield
        let textMessage = URLSessionWebSocketTask.Message.string("\(self.textField.text ?? "")")
        // Send the message to websocket server
        webSocketTask!.send(textMessage) { error in
            // Handle the issues of network connection
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.connectButton.isEnabled = true
                    self.showAlert(title: "No Interne!", message: "Please check your internet connection.", actionStr: "Ok")
                }
            } else {
                DispatchQueue.main.async {
                    // if it was sent successfully, receive the message from websocket server
                    self.receiveMessage()
                    
                }
            }
        }
    }
    
    //MARK: - Handle touching on view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // When user touch the screen in the appearance the keyboard, stop editing and hide the keyboard
        self.textField.endEditing(true)
    }
    
    //MARK: - Websocket handling
    func receiveMessage(){
        // Call the function of receiving from websocket sserver to receive the message that was sent when the button is pressed
        webSocketTask!.receive { result in
            // Hanle all results of receiving
            switch result {
            case .failure(let error):
                print("Error in receiving message: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received string: \(text)")
                    DispatchQueue.main.async {
                        self.showAlert(title: "Message Received!", message: "\(text)", actionStr: "Dismiss")
                    }
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    fatalError()
                }
            }
        }
    }
    
    func sendPing(){
        // Make button disabled until the connection done
        self.connectButton.isEnabled = false
        // Send Ping to ensure the connection done successfully
        webSocketTask?.sendPing(pongReceiveHandler: {
            (error) in
            if let error = error {
                print("Sending PING failed: \(error)")
                DispatchQueue.main.async {
                    // Handle the connection issues
                    self.removeSpinner()
                    self.connectButton.isEnabled = true
                    self.showAlert(title: "No Interne!", message: "Please check your internet connection.", actionStr: "Ok")
                }
            } else {
                DispatchQueue.main.async {
                    // while the connection done, change the state of the button to be selected
                    self.connectButton.isSelected = !self.connectButton.isSelected
                    // Enable the buttons of disconnect and send
                    self.removeSpinner()
                    self.connectButton.isEnabled = true
                    self.sendButton.isEnabled = true
                    // Reflect the status of successfully connection in ui elements
                    self.statusLabel.text = "Connected to Websocket!"
                    self.connectButton.setTitle("Disconnect", for: .normal)
                }
            }
        })
    }
    
}

