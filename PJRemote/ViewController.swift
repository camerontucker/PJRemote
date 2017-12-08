import UIKit

class ViewController: UIViewController {
    @IBOutlet var loggingTextView: UITextView!
    
    var client: Client?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let config = Bundle.main.path(forResource: "Config", ofType: "plist"),
            let keys = NSDictionary(contentsOfFile: config),
            let projectorIp = keys.value(forKey: "projectorIp") as? String else { return }
        
        client = Client(address: projectorIp, port: 4352)
    }

    @IBAction func status(_ sender: UIButton) {
        guard let client = client else { return }
        
        switch client.connect(timeout: 10) {
        case .success:
            appendToTextField(string: "Connected to host \(client.address)")
            appendToTextField(string: client.read(until: "\r")!)
            if let response = sendRequest(string: "%1INF1 ?\r", using: client) {
                appendToTextField(string: "Response: \(response)")
            }
        case .failure(let error):
            appendToTextField(string: String(describing: error))
        }
    }
    
    @IBAction func computerButton(_ sender: UIButton) {
        guard let client = client else { return }
        
        switch client.connect(timeout: 10) {
        case .success:
            appendToTextField(string: "Connected to host \(client.address)")
            appendToTextField(string: client.read(until: "\r")!)
            if let response = sendRequest(string: "%1INPT 31\r", using: client) {
                appendToTextField(string: "Response: \(response)")
            }
        case .failure(let error):
            appendToTextField(string: String(describing: error))
        }
    }
    
    @IBAction func appleTVButton(_ sender: UIButton) {
        guard let client = client else { return }
        
        switch client.connect(timeout: 10) {
        case .success:
            appendToTextField(string: "Connected to host \(client.address)")
            appendToTextField(string: client.read(until: "\r")!)
            if let response = sendRequest(string: "%1INPT 33\r", using: client) {
                appendToTextField(string: "Response: \(response)")
            }
        case .failure(let error):
            appendToTextField(string: String(describing: error))
        }
    }
    
    private func sendRequest(string: String, using client: Client) -> String? {
        appendToTextField(string: "Sending data ... ")
        
        switch client.send(string: string) {
        case .success:
            return readResponse(from: client)
        case .failure(let error):
            appendToTextField(string: String(describing: error))
            return nil
        }
    }

    private func readResponse(from client: Client) -> String? {
        guard let response = client.read(until: "\r") else { return nil }
        
        return response
    }
    
    private func appendToTextField(string: String) {
        print(string)
        loggingTextView.text = loggingTextView.text.appending("\n\(string)")
    }
}

