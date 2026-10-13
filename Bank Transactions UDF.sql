-- To do
-- Model bank transaction trigger with the following DB
/*
                 Bank Transaction
                        ↓
              What type of transaction?
                 /              \
          Withdrawal            Deposit
              ↓                    ↓
       Check balance          Add money
          /      \
       Enough?   Not enough?
         ↓          ↓
      Deduct       SIGNAL
       money       ERROR
*/

USE IntermediateSQL;

CREATE TABLE BankAccounts (
    AccountID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100),
    AccountNumber VARCHAR(20),
    Balance DECIMAL(12,2)
);

CREATE TABLE BankTransactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    AccountID INT,
    Amount DECIMAL(12,2),
    TransactionType VARCHAR(20),
    TransactionDate DATETIME DEFAULT NOW()
);

INSERT INTO BankAccounts
(CustomerName, AccountNumber, Balance)
VALUES
('Rhoda', '100001', 100000.00),
('Abiola', '100002', 50000.00),
('Halima', '100003', 10000.00);

DELIMITER //

CREATE TRIGGER CheckBankTransaction
BEFORE INSERT ON BankTransactions
FOR EACH ROW
BEGIN
	DECLARE account_balance DECIMAL(12, 2);
    
    -- Get the current account balance
    SELECT Balance
    INTO account_balance
    FROM BankAccounts
    WHERE AccountID = NEW.AccountID;
    
    -- Check Transaction Type
    IF NEW.TransactionType = 'Withdrawal' THEN
    
		-- Check if there is enough money
        IF account_balance < NEW.Amount THEN
        
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient account balance!';
            
		ELSE
			-- Deduct withdrawal amount
            UPDATE BankAccounts
            SET Balance = Balance - NEW.Amount
            WHERE AccountID = NEW.AccountID;
            
		END IF;
        
	ELSEIF NEW.TransactionType = 'Deposit' THEN
		-- Add deposit amount
		UPDATE BankAccounts
        SET Balance = Balance + NEW.Amount
        WHERE AccountID = NEW.AccountID;
        
	END IF;
    
END //

DELIMITER ;
            
INSERT INTO BankTransactions
(AccountID, Amount, TransactionType)
VALUES (3, 50000, 'Deposit');

SELECT * FROM BankAccounts;

INSERT INTO BankTransactions
(AccountID, Amount, TransactionTYpe)
VALUES (3, 100000, 'Withdrawal');

INSERT INTO BankTransactions
(AccountID, Amount, TransactionTYpe)
VALUES (3, 1000, 'Withdrawal');

INSERT INTO BankTransactions
(AccountID, Amount, TransactionType)
VALUES (3, 50000000, 'Deposit');