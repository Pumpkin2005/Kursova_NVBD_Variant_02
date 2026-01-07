USE master; 
GO 
IF EXISTS (SELECT * FROM sys.databases WHERE name = 
'RentalDW') 
BEGIN 
ALTER DATABASE RentalDW SET SINGLE_USER WITH 
ROLLBACK IMMEDIATE; 
DROP DATABASE RentalDW; 
25 
END 
GO 
CREATE DATABASE RentalDW; 
GO 
USE RentalDW; 
GO 
CREATE TABLE DimDate ( 
DateKey INT PRIMARY KEY,               
FullDate DATE NOT NULL, 
Year INT NOT NULL, 
Month INT NOT NULL, 
MonthName NVARCHAR(20) NOT NULL, 
Quarter TINYINT NOT NULL, 
DayOfWeekName NVARCHAR(20) NOT NULL 
); 
GO 
CREATE TABLE DimBuildings ( 
BuildingKey INT IDENTITY(1,1) PRIMARY KEY    
OriginalBuildingID INT NOT NULL,            
City NVARCHAR(100), 
Address NVARCHAR(255), 
District NVARCHAR(100) 
); 
GO 
CREATE TABLE DimTenants ( 
TenantKey INT IDENTITY(1,1) PRIMARY KEY, 
OriginalTenantID INT NOT NULL, 
TenantName NVARCHAR(200), 
ContactInfo NVARCHAR(255) 
); 
GO 
CREATE TABLE DimContracts ( 
ContractKey INT IDENTITY(1,1) PRIMARY KEY, 
OriginalContractID INT NOT NULL, 
StartDate DATE, 
EndDate DATE, 
PaymentDay INT, 
IsActive BIT -- 1 або 0 
26 
); 
GO 
CREATE TABLE DimPremises ( 
PremiseKey INT IDENTITY(1,1) PRIMARY KEY, 
OriginalPremiseID INT NOT NULL, 
PremiseNumber NVARCHAR(50), 
Area DECIMAL(10, 2)  
); 
GO 
CREATE TABLE FactInvoices ( 
InvoiceKey INT IDENTITY(1,1) PRIMARY KEY, 
InvoiceAltKey INT NOT NULL,     -- Зовнішні ключі до вимірів 
ContractKey INT NOT NULL, 
TenantKey INT NOT NULL, 
PremiseKey INT NOT NULL, 
DateKey INT NOT NULL,           
Amount DECIMAL(18, 2), 
IsPaid BIT, 
CONSTRAINT FK_FactInvoices_DimContracts FOREIGN KEY 
(ContractKey) REFERENCES DimContracts(ContractKey), 
CONSTRAINT FK_FactInvoices_DimTenants FOREIGN KEY 
(TenantKey) REFERENCES DimTenants(TenantKey), 
CONSTRAINT FK_FactInvoices_DimPremises FOREIGN KEY 
(PremiseKey) REFERENCES DimPremises(PremiseKey), 
CONSTRAINT FK_FactInvoices_DimDate FOREIGN KEY (DateKey) 
REFERENCES DimDate(DateKey) 
); 
GO 
CREATE TABLE FactPayments ( 
PaymentKey INT IDENTITY(1,1) PRIMARY KEY, 
PaymentAltKey INT NOT NULL, 
ContractKey INT NOT NULL, 
TenantKey INT NOT NULL, 
BuildingKey INT NOT NULL,       
DateKey INT NOT NULL,           
27 
AmountPaid DECIMAL(18, 2), 
PaymentDate DATETIME, 
CONSTRAINT FK_FactPayments_DimContracts FOREIGN KEY 
(ContractKey) REFERENCES DimContracts(ContractKey), 
CONSTRAINT FK_FactPayments_DimTenants FOREIGN KEY 
(TenantKey) REFERENCES DimTenants(TenantKey), 
CONSTRAINT FK_FactPayments_DimBuildings FOREIGN KEY 
(BuildingKey) REFERENCES DimBuildings(BuildingKey), 
CONSTRAINT FK_FactPayments_DimDate FOREIGN KEY (DateKey) 
REFERENCES DimDate(DateKey) 
); 
GO