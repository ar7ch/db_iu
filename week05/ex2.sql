CREATE TABLE Groups(
    groupId INT NOT NULL,
    PRIMARY KEY(groupId)
);

CREATE TABLE Companies (
    companyId INT NOT NULL,
    PRIMARY KEY(companyId),
    substructureCompanyId INT NOT NULL,
    FOREIGN KEY (substructureCompanyId) REFERENCES Companies(companyId),
    groupId INT NOT NULL,
    FOREIGN KEY (groupId) REFERENCES Groups(groupId)
);

CREATE TABLE Plants (
    plantId INT NOT NULL,
    PRIMARY KEY(plantId),
    companyId INT NOT NULL,
    FOREIGN KEY (companyId) REFERENCES Companies(companyId)
);

CREATE TABLE Items (
    itemId INT NOT NULL,
    PRIMARY KEY(itemId),
    plantProducerId INT NOT NULL,
    FOREIGN KEY (plantProducerId) REFERENCES Plants(plantId)
);
