CREATE TABLE Customers (
    clientId INT NOT NULL,
    balance DECIMAL(20, 5) NOT NULL,
    creditLimit INT NOT NULL,
    discount DECIMAL(2,2) NOT NULL,
    PRIMARY KEY (clientId)
);

CREATE TABLE ShippingAddresses (
    shipAddrId INT NOT NULL,
    clientId INT NOT NULL,
    house INT NOT NULL,
    street VARCHAR(255) NOT NULL,
    district VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,

    PRIMARY KEY(shipAddrId),
    FOREIGN KEY (clientId) REFERENCES Customers(clientId) 
);

CREATE TABLE Orders (
    orderId INT NOT NULL,
    clientId INT  NOT NULL,
    orderDate DATETIME NOT NULL,
    shipAddrId INT NOT NULL,

    PRIMARY KEY(orderId),
    FOREIGN KEY(clientId) REFERENCES Customers(clientId),
    FOREIGN KEY(shipAddrId) REFERENCES ShippingAddresses(shipAddrId)
);

CREATE TABLE Items (
    itemId INT NOT NULL,
    itemDescription VARCHAR(255) NOT NULL,
    PRIMARY KEY(itemId)
);

CREATE TABLE Manufacturers (
    manufacturerId INT NOT NULL,
    phonenumber VARCHAR(30) NOT NULL,
    PRIMARY KEY(manufacturerId)
);



CREATE TABLE ManufacturerProduceItems (
    manufacturerId INT NOT NULL,
    itemId INT NOT NULL,
    PRIMARY KEY(itemId, manufacturerId),
    FOREIGN KEY(manufacturerId) REFERENCES Manufacturers(manufacturerId),
    FOREIGN KEY(itemId) REFERENCES Items(itemId)
);

CREATE TABLE OrderIncludeItem (
    itemId INT NOT NULL,
    orderId INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (itemId) REFERENCES Items(itemId),
    FOREIGN KEY (orderId) REFERENCES Orders(orderId)
);
