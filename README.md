# Starships Demo

### Features
- Display the collection of starships.
- Allow the user to click on a starship to view more details.
- Users can “favourite” starships from both screens by click on the "star" icon.

------------

### UI/UX
- The starships list page displays the collection of starships with brief information. 
- User can scroll up or down the starships list.
- When user clicks on the "star" icon on the list, the related starship will be marked as favourite or unfavourite.
- User can view more details by clicking on the starship.
- On the details page, user can also mark the starship as favourite or unfavourite by clicking on the "star" icon on the top right side.
- User can go back to the starships list from details page by clicking on the "<" button on the top left side
- If user changes the favourite status from details page, the favourite status on starships list page will get updated accordingly.

![UI/UX](https://user-images.githubusercontent.com/16681331/158039852-391eec07-6c94-4113-aafb-bd5bac304352.gif "UI/UX")


------------

### UIKit + MVVM + Combine
#### UIkit
The UIKit user interface is built programmatically. So the Views are easy to control, reuse, and free of conflict. It also speeds up the complie performance on xcode and CI.

##### Example:
- Define the subview as a lazy var, to break the UI logic into small pisces:
```swift
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ZKStarshipCell.self, forCellReuseIdentifier: ZKStarshipCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
```
- Then the setup logic has less code, and easier to read:
```swift
    func setup() {
        // Setup UI
        self.title = "Starships"
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
```
#### MVVM
This demo is built in MVVM design pattern
- Models: hold application data. They’re usually structs or simple classes.
- Views: display visual elements and controls on the screen. 
- View Models: transform model information into values that can be displayed on a view.

![MVVM](https://user-images.githubusercontent.com/16681331/158043996-41dfb31b-a43d-4e91-837b-8222ac514752.png "MVVM")

#### Combine
By using Apple's Official Framwork "Combine", MVVM is built in a reactive way. 

##### Example:
- First of all, imports the Combine framwork from View and View Model.
```swift
import Combine
```
- Secondly, marks the outputs @Published in View Model.
```swift
@Published var errorMessage: String?
```
- Thirdly, defines the subscriptions in View, hence there is no need to cancel the the subscriptions by ourselves, Combine Framwork will handle it automatically.
```swift
private var subscriptions = Set<AnyCancellable>()
```
- Finally, combines the View with ViewModel, by doing so, the views will be notified if there is any changes occur. 
```swift
        viewModel.$errorMessage
	    // The UI updates should be executed on main thread
            .receive(on: DispatchQueue.main)
	    // Every time the errorMessage been updated, the sink closure will be called
            .sink { [unowned self] errorMessage in
                guard let errorMessage = errorMessage, !errorMessage.isEmpty else {
                    return
                }
		// Show up the error message
                self.popupErrorMessage(errorMessage)
	    // Let the Combine framwork to handle the subscription and cancelling
            }.store(in: &self.subscriptions)
```

### Protocol-oriented Programming
This demo is protocol-oriented, so it's easy to maintain, extend and test.

#### Networking Related Protocols

- ZKNetworkingAPIProtocol

A type that can be used to get the API's url string and its related http method

```swift
/// A type that can be used to get the API's url string and its related http method
protocol ZKNetworkingAPIProtocol {
    // The full API url string, e.g. https://swapi.dev/api/starships/2",
    var urlString: String { get }
    
    // The related http method of this API
    var method: ZKHttpMethod { get }
}
```

- ZKRequestProtocol

A type of data can be sent through API call, it has two associated types, ParamsType and ResponseType. 

ParamsType should be Ecodable, so it can be encoded to json data by Networking handler. 

ResponseType should be inherited from ZKResponseProtocol, which is Decodable, so the response data can be decoded to the exact response model type.

```swift
/// A type of data can be sent through API call
protocol ZKRequestProtocol {
    // The encodable request parameter type, used for decoding the parameters to request body data
    associatedtype ParamsType: Encodable
    // The related response type for the request, it is decodable
    associatedtype ResponseType: ZKResponseProtocol

    // The related api for the request
    var api: ZKNetworkingAPI { get }
    // Request timeout interval
    var timeoutInterval: TimeInterval { get }
    // Request header
    var headers: [String: String] { get }
    // Request parameters
    var params: ParamsType? { get }
}
```

- ZKResponseProtocol

A type of data can be decoded to a exact data type, it has a associated type ResponseDataType. 

ResponseDataType should be decoable, so the response data can be decoded to the exact response data type.

```swift
/// A type of data that received from the API call
protocol ZKResponseProtocol: Decodable {
    // A Decodable Response data type
    associatedtype ResponseDataType: Decodable
    // Response data. If request failure, this value = nil
    var data: ResponseDataType? { get }
}

```

- ZKNetworkingProtocol

This type is used to send request and hadle the response data.
By implement the ZKRequestProtocol, ZKResponseProtocol and ZKNetworkingProtocol, we can call the API and get the exact response easily.

```swift
/// A type can handle the request sending logic
protocol ZKNetworkingProtocol {
    /// Send the request using the related RequestType, response data will be converted to the related instance of ResponseType
    /// - Parameters:
    ///   - queue: The DispatchQueue that used to execute the API call
    ///   - request: The request instance that implemented the ZKRequestProtocol
    ///   - completion: A callback closure that handles the response and error
    func send<RequestType>(_ queue: DispatchQueue, request: RequestType, completion: @escaping (RequestType.ResponseType?, ZKNetworkingError?) -> Void) where RequestType : ZKRequestProtocol
}
```
##### Example:
```swift
class ZKNetworking: ZKNetworkingProtocol {
    static let shared = ZKNetworking()
}

/// Implement the ZKNetworkingProtocol
extension ZKNetworking {
    /// Send the request using the related RequestType, response data will be converted to the related instance of ResponseType
    /// - Parameters:
    ///   - queue: The DispatchQueue that used to execute the API call, by default it is global queue
    ///   - request: The request instance that implemented the ZKRequestProtocol
    ///   - completion: A callback closure that handles the response and error
    func send<RequestType>(_ queue: DispatchQueue = DispatchQueue.global(), request: RequestType, completion: @escaping (RequestType.ResponseType?, ZKNetworkingError?) -> Void) where RequestType : ZKRequestProtocol {
        
        // Validate the URL string
        guard var urlComponents = URLComponents(string: request.api.urlString) else {
            // If the URL string is invalid, complete the API call with error
            completion(nil, .invalidURL)
            return
        }
        
        if request.api.method == .get {
            // If the the http method is GET, convert the parameters to query items
            do {
                urlComponents.queryItems = try request.params?.convertToQueryItems()
            } catch let error {
                // If the conversion failed, complete the API call with error
                completion(nil, .custom(message: error.localizedDescription))
                return
            }
        }
        
        guard let url = urlComponents.url else {
            // If the URL is invalid call, complete the API call with error
            completion(nil, .invalidURL)
            return
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: request.timeoutInterval)
        
        if (request.api.method == .post) {
            // If the http method is POST, convert the parameters to http body
            do {
                urlRequest.httpBody = try JSONEncoder().encode(request.params)
            } catch let error {
                // If the conversion failed, complete the API call with error
                completion(nil, .custom(message: error.localizedDescription))
                return
            }
        }
        
        urlRequest.httpMethod = request.api.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        // Create the API call task
        let task = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            if let error = error {
                // If error is not nil, complete the API call with error
                queue.async {
                    completion(nil, .custom(message: error.localizedDescription))
                }
                return
            }
            
            guard let data = data, let urlResponse = urlResponse as? HTTPURLResponse else {
                // Invalid response data, complete the API call with error
                queue.async { completion(nil, .invalidURL) }
                return
            }
            
            if urlResponse.statusCode == 400 {
                // Complete the API call with server error
                queue.async {
                    completion(nil, .serverError)
                }
            } else if 200...299 ~= urlResponse.statusCode {
                do {
                    let response = try JSONDecoder().decode(RequestType.ResponseType.self, from: data)
                    queue.async {
                        // Complete the API call with eligible response data
                        completion(response, nil)
                    }
                } catch let responseError {
                    // Complete the API call with decoding error
                    queue.async {
                        completion(nil, .custom(message: responseError.localizedDescription))
                    }
                }
            } else {
                // Complete the API call with unknown error
                queue.async { completion(nil, .custom(message: "Unknown Error")) }
            }
        }
        
        // Start the API call task
        task.resume()
    }
}

struct ZKGetStarshipsRequest: ZKRequestProtocol {
    typealias ParamsType = ZKGetStarshipsRequestParams
    typealias ResponseType = ZKGetStarshipsResponse
    
    var api: ZKNetworkingAPI {
        return .starships(.list)
    }
    
    // This API can be call without parameters
    var params: ZKGetStarshipsRequestParams? = nil
}

struct ZKGetStarshipsResponseData: Decodable {
    // Count of all starships
    let count: Int
    // Url String for next page
    let next: String?
    // Url String for previous page
    let previous: String?
    // Starships list
    let starships: [ZKStarship]?
    
    enum CodingKeys: String, CodingKey {
        case count, next, previous
        case starships = "results"
    }
}

struct ZKGetStarshipsResponse: ZKResponseProtocol {
    typealias ResponseDataType = ZKGetStarshipsResponseData
    let data: ResponseDataType?
    
    init(from decoder: Decoder) throws {
        self.data = try ResponseDataType.init(from: decoder)
    }
}

// By implemented all the protocols, we can send the API call like below: 
let request = ZKGetStarshipsRequest(params: ZKGetStarshipsRequestParams(page: 1))
ZKNetworking.shared.send(DispatchQueue.global(), request: request) { [unowned self] in
	self.starships = $0?.data?.starships
	self.reloadData = true
    self.errorMessage = $1?.errorDescription 
}
```
##### Related Tests
The protocols are very useful for offline unit testing, as the networking tests do not need to rely on internet access. 

To do the offline testing, implement another Networking handler from ZKNetworkingProtocol, use it to load the response data from local json files

##### Example
```swift
class ZKNetworkingTests: XCTestCase, ZKNetworkingProtocol {
    // Implement the ZKNetworkingProtocol
    func send<RequestType>(_ queue: DispatchQueue = DispatchQueue.global(), request: RequestType, completion: @escaping (RequestType.ResponseType?, ZKNetworkingError?) -> Void) where RequestType : ZKRequestProtocol {
        do {
            // Use mock data from JSON file so the test is not rely on network
            let response = try self.loadResponseFromJSONFile(responseFileName, for: request)
            completion(response, nil)
        } catch let error {
            completion(nil, .custom(message: error.localizedDescription))
        }
    }

    // Load the mock response date from json file
    private func loadResponseFromJSONFile<Request>(_ fileName: String, for request: Request) throws -> Request.ResponseType? where Request: ZKRequestProtocol {
        return try ZKJSONUtil.shared.loadDataFromJSONFile(Request.ResponseType.self, fileName: fileName)
    }
	
    // Execute the asynchronous request call in the processing closure
    private func testSendRequest(_ name: String, processing: (_ expectation: XCTestExpectation) -> ()) {
        let expectation = self.expectation(description: name)
        processing(expectation)
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }
	
    // This get starships list from mock json file
    // This test is not rely on internet
    func testGetStarshipsListSuccess() {
        let request = ZKGetStarshipsRequest()
        
        // Test the request properties
        XCTAssertEqual(request.api.method, ZKNetworkingAPI.starships(.list).method)
        XCTAssertEqual(request.api.urlString, ZKNetworkingAPI.starships(.list).urlString)
        XCTAssertTrue(request.params == nil)
        XCTAssertEqual(request.timeoutInterval, 10)
        XCTAssertEqual(request.headers, ["content-type": "application/json"])

        // Test send request
        self.responseFileName = "GetStarshipsResponse"
        self.testSendRequest("Test Get Starships List Success") { [unowned self] expectation in
            self.send(request: request) { response, error in
                XCTAssertNil(error)
                // Check the response data
                XCTAssertEqual(response?.data?.count, 36)
                XCTAssertEqual(response?.data?.next, "https://swapi.dev/api/starships/?page=2")
                expectation.fulfill()
            }
        }
    }
}

class ZKJSONUtil {
    static let shared = ZKJSONUtil()
    
    /// Load data from JSON file
    /// - Parameters:
    ///   - dataType: A decodable type
    ///   - fileName: The JSON file name
    func loadDataFromJSONFile<DataType>(_ dataType: DataType.Type, fileName: String) throws -> DataType? where DataType: Decodable {
        let path = Bundle(for: type(of:self)).path(forResource: fileName, ofType: "json")
        let url = URL(fileURLWithPath: path ?? "")
        let jsonData = try Data(contentsOf: url)
        let response = try JSONDecoder().decode(DataType.self, from: jsonData)
        return response
    }
}

```
- By create different JSON files, one can also test the failure scenarios:
```swift
    func testGetStarshipsListError() {
        let request = ZKGetStarshipsRequest()
        self.responseFileName = "GetStarshipsError"
        self.testSendRequest("Test Get Starships List Error") { [unowned self] expectation in
            self.send(request: request) { response, error in
                XCTAssertNotNil(error)
                XCTAssertNil(response?.data?.starships)
                expectation.fulfill()
            }
        }
    }
```

#### Persistence Related Protocol
This demo also considers the Persistence structure for future use:

- ZKPersistenceProtocol

This protocol defines all the persistence related methods: save, update, delete and fetch.
It has an associated type, so each of the implementations should only handle one data type.

```swift
/// A type to handle the persistence for specific data type
protocol ZKPersistenceProtocol {
    // The date type 
    associatedtype DataType
    
    /// If the data is not existing then  create a new one from database, otherwise update the existing data
    func saveOrUpdate(_ model: DataType, completion:(() -> Void)?)
    
    /// Save or update a list of data from database
    /// If the data is not existing then create new data from database, otherwise update the existing data
    func batchSaveOrUpdate(_ models: [DataType], completion:(() -> Void)?)
    
    /// Delete data from database
    func delete(_ models: [DataType], completion:(() -> Void)?)
    
    /// Delete data from database by predicate
    func deleteData(_ predicate: NSPredicate, completion:(() -> Void)?)
    
    /// Fetch data from database using predicate
    func fetchData(_ predicate: NSPredicate?) -> [DataType]
}
```

### Future Implementation
ALLLLLLRIGHT!!! This is the last chapter of this READ ME DOCUMENT!! 

And it's very important too!!!

As a developer, we should consider the future requirements and use cases as much as we can, to make our sturcture easier to implement and extend.

In this demo, I've already written some functions to support future use.
#### Paging on the starship list
The paging business logic is very easy to implement in the current structure, the only thing we need to do is to create a request instance using different page number:  

```swift
// Change the `page` to load a different page of data
let request = ZKGetStarshipsRequest(params: ZKGetStarshipsRequestParams(page: 2))
```
#### Sort the starships
To support sorting the starships, we will need a small change on the Request model, now we have one parameter "page", I assume that the API will support another parameter "sort", so the only thing we need to do is to add a new property "sort" into parameters:
```swift 
struct ZKGetStarshipsRequestParams: Encodable {
    // Start from 1
    // If this value equals to nil, means load the first page
    var page: Int? = nil
    var sort: ZKGetStarshipsRequestParams.SortType? = nil
		
    /// Sort type of starships
    enum SortType: Int {
    	case name = 1
	case length
	case speed
	case created
    }
}
```
#### Persistence
Now the demo hasn't been saved the starships on local persistence, and the favourite status will be cleared after the app relaunched.
To support persistence, we need to impletment the ZKPersistenceProtocol
```swift
class ZKStarshipsDBHelper: ZKPersistenceProtocol {
    typealias DataType = ZKStarship
    
    static let shared = ZKStarshipsDBHelper()
    
    /// If the data is not existing then  create a new one from database, otherwise update the existing data
    func saveOrUpdate(_ model: ZKStarship, completion: (() -> Void)? = nil) {
        // Handle it on Coredata or Userdefaults
    }
    
    /// Save or update a list of data from database
    /// If the data is not existing then create new data from database, otherwise update the existing data
    func batchSaveOrUpdate(_ models: [ZKStarship], completion: (() -> Void)? = nil) {
        // Handle it on Coredata or Userdefaults

    }
    
    /// Delete data from database
    func delete(_ models: [DataType], completion:(() -> Void)? = nil) {
        // Handle it on Coredata or Userdefaults

    }
    
    /// Delete data from database by predicate, if predicate == nil, this method will delete all the data
    func deleteData(_ predicate: NSPredicate, completion:(() -> Void)? = nil) {
        // Handle it on Coredata or Userdefaults

    }
    
    /// Fetch data from database using predicate, if predicate == nil, this method will return all the data
    func fetchData(_ predicate: NSPredicate?) -> [DataType] {
        // Handle it on Coredata or Userdefaults

        return []
    }
}
```

Then we can use it on ViewModel:
```swift
    /// Get starships from server
    func getStarships() {
        // Only get the first page at the moment
        // Change the `page` to support paging
        let request = ZKGetStarshipsRequest(params: ZKGetStarshipsRequestParams(page: 1))
        self.networking.send(DispatchQueue.global(), request: request) { [unowned self] in
            self.starships = $0?.data?.starships
            self.reloadData = true
            self.errorMessage = $1?.errorDescription 
            
            if let starships = self.starships {
                // Save the list to DB
                ZKStarshipsDBHelper.shared.batchSaveOrUpdate(starships)
            }
        }
    }
```

------------

# Thank you!
