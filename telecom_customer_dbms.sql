CREATE DATABASE Telecom_Team_8

GO

USE Telecom_Team_8

GO
CREATE PROCEDURE createAllTables AS
BEGIN
    CREATE TABLE Customer_profile(
        nationalID INT,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        email VARCHAR(50),
        address VARCHAR(50) NOT NULL,
        date_of_birth DATE
        CONSTRAINT PK_Customer_profile PRIMARY KEY(nationalID)
    );

    CREATE TABLE Customer_Account(
        mobileNo CHAR(11),
        pass VARCHAR(50),
        balance DECIMAL(10,1),
        account_type VARCHAR(50) CHECK(account_type IN('Post Paid','Prepaid','Pay_as_you_go')),
        start_date DATE NOT NULL,
        status VARCHAR(50) CHECK(status IN('active','onhold')),
        points INT DEFAULT 0,
        nationalID INT,
        CONSTRAINT PK_Customer_Account PRIMARY KEY(mobileNo),
        CONSTRAINT FK_nationalID_Customer_Account FOREIGN KEY(nationalID) REFERENCES Customer_profile(nationalID)
    );

    CREATE TABLE Service_Plan(
        planID INT IDENTITY(1,1),
        SMS_offered INT NOT NULL,
        minutes_offered INT NOT NULL,
        data_offered INT NOT NULL,
        name VARCHAR(50) NOT NULL,
        price INT NOT NULL,
        description VARCHAR(50),
        CONSTRAINT PK_Service_Plan PRIMARY KEY(planID)
    );

    CREATE TABLE Subscription(
        mobileNo CHAR(11),
        planID INT,
        subscription_date DATE,
        status VARCHAR(50) CHECK(status IN('active','onhold'))
        CONSTRAINT PK_Subscription PRIMARY KEY(mobileNo, planID),
        CONSTRAINT FK_mobileNo_Subscription FOREIGN KEY(mobileNo) REFERENCES Customer_Account(mobileNo),
        CONSTRAINT FK_planID_Subscription FOREIGN KEY(planID) REFERENCES Service_Plan(planID)
    );

    CREATE TABLE Plan_Usage(
        usageID INT IDENTITY(1,1),
        start_date DATE NOT NULL,
        end_date DATE NOT NULL,
        data_consumption INT,
        minutes_used INT,
        SMS_sent INT,
        mobileNo CHAR(11),
        planID INT,
        CONSTRAINT PK_Plan_Usage PRIMARY KEY(usageID),
        CONSTRAINT FK_mobileNo_Plan_Usage FOREIGN KEY(mobileNo) REFERENCES Customer_Account(mobileNo),
        CONSTRAINT FK_planID_Plan_Usage FOREIGN KEY(planID) REFERENCES Service_Plan(planID)
    );

    CREATE TABLE Payment(
        paymentID INT IDENTITY(1,1),
        amount DECIMAL(10,1) NOT NULL,
        date_of_payment DATE NOT NULL,
        payment_method VARCHAR(50) CHECK(payment_method IN('cash','credit')) ,
        status VARCHAR(50) CHECK(status IN('successful','pending','rejected')),
        mobileNo CHAR(11),
        CONSTRAINT PK_Payment PRIMARY KEY(paymentID),
        CONSTRAINT FK_mobileNo_Payment FOREIGN KEY(mobileNo) REFERENCES Customer_Account(mobileNo)
    );

    CREATE TABLE Process_Payment(
        paymentID INT,
        planID INT,
        remaining_balance AS (dbo.Remaining_amount(paymentID , planID)),
        extra_amount AS (dbo.Extra_amount(paymentID , planID))     
        CONSTRAINT PK_Process_Payment PRIMARY KEY(paymentID),
        CONSTRAINT FK_paymentID_Process_Payment FOREIGN KEY (paymentID) REFERENCES Payment(paymentID),
        CONSTRAINT FK_planID_Process_Payment FOREIGN KEY (planID) REFERENCES Service_Plan(planID)
    );

    CREATE TABLE Wallet(
        walletID INT IDENTITY(1,1),
        current_balance DECIMAL(10,2) default 0,
        currency VARCHAR(50) default 'egp',
        last_modified_date DATE,
        nationalID INT,
        mobileNo CHAR(11)
        CONSTRAINT PK_Wallet PRIMARY KEY(walletID),
        CONSTRAINT FK_nationalID_Wallet FOREIGN KEY (nationalID) REFERENCES Customer_profile(nationalID)
    );

    CREATE TABLE Transfer_money(
        walletID1 INT,
        walletID2 INT,
        transfer_id INT IDENTITY(1,1),
        amount DECIMAL(10,2),
        transfer_date DATE,
        CONSTRAINT PK_Transfer_money PRIMARY KEY (walletID1,walletID2,transfer_id),
        CONSTRAINT FK_walletID1_Transfer_money FOREIGN KEY (walletID1) REFERENCES Wallet(walletID),
        CONSTRAINT FK_walletID2_Transfer_money FOREIGN KEY (walletID2) REFERENCES Wallet(walletID)
    );

    CREATE TABLE Benefits(
        benefitID INT IDENTITY(1,1),
        description VARCHAR(50),
        validity_date DATE,
        status VARCHAR(50) CHECK(status IN('active','expired')),
        mobileNo CHAR(11),
        CONSTRAINT PK_Benefits PRIMARY KEY (benefitID),
        CONSTRAINT FK_mobileNo_Benefits FOREIGN KEY (mobileNo) REFERENCES Customer_account(mobileNo)
    );

    CREATE TABLE Points_Group(
        pointID INT IDENTITY(1,1),
        benefitID INT,
        pointsAmount INT,
        PaymentID INT,
        CONSTRAINT PK_Points_Group PRIMARY KEY (pointID,benefitID),
        CONSTRAINT FK_benefitID_Points_Group FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID),
        CONSTRAINT FK_PaymentID_Points_Group FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)
    );

    CREATE TABLE Exclusive_Offer(
        offerID INT IDENTITY(1,1),
        benefitID INT,
        internet_offered INT,
        SMS_offered INT,
        minutes_offered INT,
        CONSTRAINT PK_Exclusive_Offer PRIMARY KEY (offerID,benefitID),
        CONSTRAINT FK_benefitID_Exclusive_Offer FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID)
    );

    CREATE TABLE Cashback( -- Cashback is calculated as 10% of the payment amount.
        CashbackID INT IDENTITY(1,1),
        benefitID INT,
        walletID INT,
        amount INT,
        credit_date DATE,
        CONSTRAINT PK_Cashback PRIMARY KEY (CashbackID,benefitID),
        CONSTRAINT FK_benefitID_Cashback FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID),
        CONSTRAINT FK_walletID_Cashback FOREIGN KEY (walletID) REFERENCES Wallet(walletID)
    );

    CREATE TABLE Plan_Provides_Benefits(
        benefitID INT,
        planID INT,
        CONSTRAINT PK_Plan_Provides_Benefits PRIMARY KEY (planID,benefitID),
        CONSTRAINT FK_benefitID_Plan_Provides_Benefits FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID),
        CONSTRAINT FK_planID_Plan_Provides_Benefits FOREIGN KEY (planID) REFERENCES Service_Plan(planID)
    );

    CREATE TABLE Shop(
        shopID INT IDENTITY(1,1),
        name VARCHAR(50),
        category VARCHAR(50),
        CONSTRAINT PK_Shop PRIMARY KEY (shopID)
    );

    CREATE TABLE Physical_Shop(
        shopID INT,
        address VARCHAR(50),
        working_hours VARCHAR(50),
        CONSTRAINT PK_Physical_Shop PRIMARY KEY (shopID),
        CONSTRAINT FK_shopID_Physical_Shop FOREIGN KEY (shopID) REFERENCES Shop(shopID)
    );

    CREATE TABLE E_SHOP(
        shopID INT,
        URL VARCHAR(50) NOT NULL,
        rating INT,
        CONSTRAINT PK_E_SHOP PRIMARY KEY (shopID),
        CONSTRAINT FK_shopID_E_SHOP FOREIGN KEY (shopID) REFERENCES Shop(shopID)
    );

    CREATE TABLE Voucher(
        voucherID INT IDENTITY(1,1),
        value INT,
        expiry_date DATE,
        points INT,
        mobileNo CHAR(11),
        shopID INT,
        redeem_date DATE,
        CONSTRAINT PK_Voucher PRIMARY KEY (voucherID),
        CONSTRAINT FK_shopID_Voucher FOREIGN KEY (shopID) REFERENCES Shop(shopID),
        CONSTRAINT FK_mobileNo_Voucher FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo)
    );

    CREATE TABLE Technical_Support_Ticket(
        ticketID INT IDENTITY(1,1),
        mobileNo CHAR(11),
        Issue_description VARCHAR(50),
        priority_level INT,
        status VARCHAR(50) CHECK(status IN('Open','In Progress','Resolved')),
        CONSTRAINT PK_Technical_Support_Ticket PRIMARY KEY (ticketID , mobileNo),
        CONSTRAINT FK_mobileNo_Technical_Support_Ticket FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo)
    );
END;

GO 
CREATE PROCEDURE dropAllTables AS -- Order must be reversed because sql will not allow you to drop a table that is refrenced by another one
BEGIN
DROP TABLE  Points_Group;
DROP TABLE  Exclusive_Offer;
DROP TABLE  Cashback;
DROP TABLE Plan_Provides_Benefits;
DROP TABLE  Voucher;
DROP TABLE  Technical_Support_Ticket;
DROP TABLE  Transfer_money;
DROP TABLE  Process_Payment;
DROP TABLE  Plan_Usage;
DROP TABLE  Benefits;
DROP TABLE  Subscription;
DROP TABLE  Payment;
DROP TABLE  Wallet;
DROP TABLE Service_Plan;
DROP TABLE  Customer_Account;
DROP TABLE  E_shop;
DROP TABLE  Physical_Shop;
DROP TABLE  Shop;
DROP TABLE  Customer_profile;
END;

GO
CREATE PROCEDURE dropAllProceduresFunctionsViews AS
BEGIN 
    DROP VIEW IF EXISTS allCustomerAccounts;
    DROP VIEW IF EXISTS allServicePlans;
    DROP VIEW IF EXISTS allBenefits;
    DROP VIEW IF EXISTS AccountPayments;
    DROP VIEW IF EXISTS allShops;
    DROP VIEW IF EXISTS allResolvedTickets;
    DROP VIEW IF EXISTS CustomerWallet;
    DROP VIEW IF EXISTS E_shopVouchers;
    DROP VIEW IF EXISTS PhysicalStoreVouchers;
    DROP VIEW IF EXISTS Num_of_cashback;
    DROP PROCEDURE IF EXISTS createAllTables;
    DROP PROCEDURE IF EXISTS dropAllTables;
    DROP PROCEDURE IF EXISTS Account_Plan;
    DROP PROCEDURE IF EXISTS Total_Points_Account;
    DROP PROCEDURE IF EXISTS Unsubscribed_Plans;
    DROP PROCEDURE IF EXISTS Ticket_Account_Customer;
    DROP PROCEDURE IF EXISTS Account_Highest_Voucher;
    DROP PROCEDURE IF EXISTS Top_Successful_Payments;
    DROP PROCEDURE IF EXISTS Initiate_plan_payment;
    DROP PROCEDURE IF EXISTS Payment_wallet_cashback;
    DROP PROCEDURE IF EXISTS Initiate_balance_payment;
    DROP PROCEDURE IF EXISTS Redeem_voucher_points;
    DROP PROCEDURE IF EXISTS Benefits_Account;
    DROP PROCEDURE IF EXISTS Account_Payment_Points;
    DROP FUNCTION IF EXISTS Account_Plan_date;
    DROP FUNCTION IF EXISTS Account_Usage_Plan;
    DROP FUNCTION IF EXISTS Account_SMS_Offers;
    DROP FUNCTION IF EXISTS Wallet_Cashback_Amount;
    DROP FUNCTION IF EXISTS Wallet_Transfer_Amount;
    DROP FUNCTION IF EXISTS Wallet_MobileNo;
    DROP FUNCTION IF EXISTS AccountLoginValidation;
    DROP FUNCTION IF EXISTS Consumption;
    DROP FUNCTION IF EXISTS Usage_Plan_CurrentMonth;
    DROP FUNCTION IF EXISTS Cashback_Wallet_Customer;
    DROP FUNCTION IF EXISTS Remaining_plan_amount;
    DROP FUNCTION IF EXISTS Extra_plan_amount;
    DROP FUNCTION IF EXISTS Subscribed_plans_5_Months;
END;



GO 
CREATE PROCEDURE clearAllTables AS
BEGIN
    EXEC dropAllTables;
    EXEC createAllTables;
END;


GO
CREATE FUNCTION Remaining_amount(@paymentID INT, @planID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Remaining INT
    DECLARE @Price INT
    DECLARE @Amount INT

    SELECT @Amount = p.amount
    FROM Payment p
    WHERE p.paymentID = @paymentID

    SELECT @Price = s.price
    FROM Service_Plan s
    WHERE s.planID = @planID

    IF @Amount < @Price
        SET @Remaining = @Price - @Amount
    ELSE
        SET @Remaining = 0

    RETURN @Remaining
END;


GO
CREATE FUNCTION Extra_amount(@paymentID INT, @planID INT)
RETURNS INT
AS
BEGIN
DECLARE @Extra INT
DECLARE @Price INT
DECLARE @Amount INT

    SELECT TOP 1 @Amount = p.amount
    FROM Payment p
    WHERE p.paymentID = @paymentID

    SELECT Top 1 @Price = s.price
    FROM Service_Plan s
    WHERE s.planID = @planID

    IF @Amount > @Price
        SET @Extra = @Amount - @Price 
    ELSE
        SET @Extra = 0

    RETURN @Extra
END;


GO
Exec createAllTables;


GO
CREATE VIEW allCustomerAccounts AS 
SELECT 
    p.*,
    a.mobileNo,
    a.account_type,
    a.status,
    a.start_date,
    a.balance,
    a.points
FROM Customer_profile p
INNER JOIN Customer_Account a 
ON p.nationalID = a.nationalID
WHERE a.status = 'active';
GO


GO
CREATE VIEW allServicePlans AS 
SELECT *
FROM Service_Plan;
GO


GO
CREATE VIEW allBenefits AS 
SELECT *
FROM Benefits 
WHERE status = 'active';




-------------- Yellow part ------------------


Go
---Fetch details for all payments along with their corresponding Accounts.
CREATE VIEW AccountPayments AS
SELECT *
FROM Payment;



Go 
--Fetch details for all shops.
CREATE VIEW allShops As
Select *
From Shop;

Go
--Fetch details for all resolved tickets.
CREATE VIEW allResolvedTickets As
Select *
From  Technical_Support_Ticket
where status = 'Resolved';

Go
--Fetch details of all wallets along with their customer names.
CREATE VIEW CustomerWallet As
Select W.*, C.first_name , C.last_name 
From  Wallet W,Customer_profile C 
where W.nationalID = C.nationalID;

Go
-- Fetch the list of all E-shops along with their redeemed vouchers's ids and values.
CREATE VIEW E_shopVouchers As
Select E.* ,V.voucherID, V.value
From  E_SHOP E 
Inner join Voucher V 
ON E.shopID = V.shopID;

Go
--Fetch the list of all physical stores along with their redeemed vouchers's ids and values.
CREATE VIEW PhysicalStoreVouchers As
Select P.* ,V.voucherID, V.value
From Physical_Shop P 
Inner join Voucher V 
ON P.shopID = V.shopID;

Go
--Fetch number of cashback transactions per each wallet.
CREATE VIEW Num_of_cashback As
Select walletID , count(*) AS 'count of transactions'
From Cashback
Group by walletID;


Go 
--List all accounts along with the service plans they are subscribed to
CREATE PROCEDURE Account_Plan AS
Select C.* , Sp.*
From Customer_Account C 
Inner join Subscription S 
ON C.mobileNo = S.mobileNo 
Inner join Service_Plan Sp 
ON S.planID = Sp.planID;



-------------- Green part ------------------



Go
--Retrieve the list of accounts subscribed to the input plan on a certain date
CREATE FUNCTION Account_Plan_date(@sub_date date,@plan_id int)
RETURNS TABLE
AS
RETURN(
    Select S.mobileNo AS Account_Mobile_Number, SP.planID AS Service_Plan_ID, SP.name AS Service_Plan_Name
    From Subscription S 
    inner join Service_Plan SP 
    ON S.planID = SP.planID
    Where S.subscription_date = @sub_date AND S.planID = @Plan_id
);


Go
--Retrieve the total usage of the input account on each subscribed plan from a given input date.
CREATE FUNCTION Account_Usage_Plan(@mobile_num char(11), @start_date date)
RETURNS TABLE
AS
    RETURN( 
        Select U.planID, SUM(U.data_consumption) AS 'total data', SUM(U.minutes_used) AS 'total mins', SUM(U.SMS_sent) AS 'total SMS'
        From Plan_Usage U 
        Where U.mobileNo = @mobile_num AND U.start_date >= @start_date
        Group By U.planID
    );


Go
--Delete all benefits offered to the input account for a certain plan
CREATE PROCEDURE Benefits_Account
    @mobile_num char(11),
    @plan_id int
AS
BEGIN
    BEGIN TRANSACTION;

    UPDATE Benefits
    SET mobileNo = NULL
    FROM Benefits B INNER JOIN plan_provides_benefits pb
    ON B.benefitID = pb.benefitid 
    WHERE B.mobileNo = @mobile_num AND pb.planID = @plan_id

    COMMIT TRANSACTION;
END;

GO
--Display all benefits offered to the input account for a certain plan
CREATE PROCEDURE Benefits_Account_Plan
@mobile_num char(11), @plan_id int

AS
    select B.*
    FROM Benefits B INNER JOIN plan_provides_benefits pb
    ON B.benefitID = pb.benefitid 
    WHERE B.mobileNo = @mobile_num AND pb.planID = @plan_id


GO
--Retrieve the list of gained offers of type �SMS� for the input account
CREATE FUNCTION Account_SMS_Offers(@mobile_num char(11))
RETURNS TABLE
AS
    RETURN( Select O.*
            From Exclusive_Offer O 
            Inner join Benefits B 
            ON B.benefitID = O.benefitID
            Where B.mobileNo = @mobile_num AND O.SMS_offered > 0 
          );


Go
--Retrieve the number of accepted payment transactions initiated by the input account during 
--the last year along with the total amount of earned points.
CREATE PROCEDURE Account_Payment_Points
@mobile_num char(11)
AS
    Select Count(P.paymentID), SUM(PG.pointsAmount)
    From Payment P 
    inner join Points_Group PG 
    ON P.paymentID = PG.PaymentID
    Where P.mobileNo = @mobile_num AND P.status = 'successful' 
    AND DATEDIFF(YEAR, P.date_of_payment, CURRENT_TIMESTAMP) <= 1;


Go
--Retrieve the amount of cashback returned on the input wallet based on a certain plan.
CREATE FUNCTION Wallet_Cashback_Amount
(@walletID int, @planID int)
returns INT
As
BEGIN
    Declare @Amount_of_cashback INT

    Select @Amount_of_cashback = SUM(C.amount)
    From Cashback C 
    inner join Plan_Provides_Benefits PPB 
    ON C.benefitID = PPB.benefitID
    Where C.walletID = @walletID AND PPB.planID = @planID

Return @Amount_of_cashback
END


Go
--Retrieve the average of the sent transaction amounts from the input wallet within a certain duration
CREATE FUNCTION Wallet_Transfer_Amount(@walletID int,@start_date date, @end_date date)
returns Float
AS
BEGIN

    -- should we consider payments & Wallet --> Wallets Only
    Declare @Transaction_amount_average Float

    Select @Transaction_amount_average = AVG(t.amount) from transfer_money t
    where t.walletID1 = @walletID 
    AND t.transfer_date BETWEEN @start_date AND @end_date

    Return @Transaction_amount_average
END;


GO
--Take mobileNo as an input, return true if this number is linked to a wallet, otherwise return false.
CREATE FUNCTION Wallet_MobileNo
(@mobile_num char(11))
returns BIT
AS
BEGIN

    Declare @result BIT

    if Exists(  Select * 
                From Wallet W 
                Where W.mobileNo = @mobile_num
             )
        set @result = '1'
    else
        set @result = '0'

return @result
END;

-------------- blue part ------------------


Go
--Update the total number of points that the input account should have.
CREATE PROCEDURE Total_Points_Account
@mobile_num CHAR(11)
AS

    DECLARE @total_points int

    Select @total_points =  SUM(pg.pointsAmount) 
    From Points_group pg
    Inner join Payment p
    ON pg.paymentId = p.paymentID
    WHERE p.mobileNo = @mobile_num

    IF(@total_points is null)
        SET @total_points = 0;

    UPDATE Customer_Account  
    SET points += @total_points
    WHERE mobileNo = @mobile_num;

    DELETE FROM Points_group
    WHERE pointId in  (
                        Select pg.pointId 
                        From Points_group pg
                        Inner join Payment p 
                        ON pg.paymentId = p.paymentID
                        WHERE p.mobileNo = @mobile_num
                      )


GO
--As a customer I should be able to login using my mobileNo and password.
CREATE FUNCTION AccountLoginValidation(@mobile_num CHAR(11), @pass VARCHAR(50))
RETURNS BIT 
AS
BEGIN
DECLARE @Out int

    IF EXISTS(  SELECT 1
                FROM Customer_Account A
                WHERE A.mobileNo = @mobile_num AND A.pass = @pass)
        Set @Out = 1
    ELSE
        Set @Out = 0 

    RETURN @Out
END;


GO
--retrieve the total SMS, Mins and Internet consumption for an input plan within a certain duration.
CREATE FUNCTION Consumption(
    @Plan_name VARCHAR(50),
    @start_date DATE,
    @end_date DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT PU.data_consumption, PU.minutes_used, PU.SMS_sent
    FROM Plan_Usage PU
    INNER JOIN Service_Plan SP ON PU.planID = SP.planID
    WHERE SP.name = @Plan_name AND 
          PU.start_date >= @start_date AND 
          PU.end_date <= @end_date
);


GO
--Retrieve all offered plans that the input customer is not subscribed to.
CREATE PROCEDURE Unsubscribed_Plans
@mobile_num CHAR(11)
AS
    SELECT * 
    FROM Service_Plan  
    EXCEPT (    SELECT s1.* 
                FROM Service_Plan s1
                INNER JOIN Subscription s2       
                on s1.planId = s2.planID AND s2.mobileNo = @mobile_num
           );


GO
-- Retrieve the usage of all active plans for the input account in the current month.
CREATE FUNCTION Usage_Plan_CurrentMonth(@mobile_num CHAR(11))
RETURNS TABLE 
AS
RETURN(
    SELECT P.data_consumption, P.minutes_used, P.SMS_sent
    FROM Subscription S      
    INNER JOIN Plan_Usage P 
    ON S.mobileNo = P.mobileNo AND S.planID = P.planID
    WHERE YEAR(P.start_date) = YEAR(CURRENT_TIMESTAMP) OR YEAR(P.end_date) = YEAR(CURRENT_TIMESTAMP)
          AND MONTH(P.start_date) = MONTH(CURRENT_TIMESTAMP) OR MONTH(P.end_date) = MONTH(CURRENT_TIMESTAMP)
          AND S.mobileNo = @mobile_num 
          AND S.status = 'active'
);


GO
--Retrieve all cashback transactions related to the wallet of the input customer.
CREATE FUNCTION Cashback_Wallet_Customer(@NID int)
RETURNS TABLE 
AS 
RETURN (
    SELECT C.* 
    FROM Cashback C
    INNER JOIN Wallet W
    ON C.walletID = W.walletID 
    WHERE W.nationalID = @NID
);



GO
--Retrieve the number of technical support tickets that are NOT �Resolved� 
--for each account of the input customer.
CREATE PROCEDURE Ticket_Account_Customer
@NID int
AS
SELECT COUNT(t.ticketID) as UnresolvedTickets 
FROM Customer_Account c                        
Inner JOIN Technical_Support_Ticket t
ON t.mobileNo = c.mobileNo
where c.nationalID = @NID AND t.status <> 'Resolved'
Group by c.mobileNo;


GO
--Return the voucher with the highest value for the input account.
CREATE PROCEDURE Account_Highest_Voucher
@mobile_num char(11)
AS
SELECT v.voucherID
FROM Voucher v
where v.value = (
                    SELECT MAX(v1.value)
                    from Voucher v1 
                    where v1.mobileNo = @mobile_num
                )


-------------- purple part ------------------


GO
--Get the remaining amount for a certain plan based on the payment initiated by the input account.
CREATE FUNCTION Remaining_plan_amount(@mobile_num char(11), @plan_name varchar(50))
RETURNS INT
AS
BEGIN
    DECLARE @Remaining INT
    DECLARE @plan_id INT
    DECLARE @payment_id INT

    SELECT TOP 1 @plan_id = s.planID, @payment_id = p.paymentID 
    FROM Payment p
    Inner Join Process_Payment process
    ON process.paymentID = p.paymentID
    Inner Join Service_Plan s
    ON process.planID = s.planID
    WHERE p.mobileNo = @mobile_num AND s.name = @plan_name
    ORDER BY p.date_of_payment DESC; -- Ensure we are working with the latest payment


    SET @Remaining = dbo.Remaining_amount(@payment_id,@plan_id)
    RETURN @Remaining
END;


GO
--Get the extra amount from a payment initiated by the input account for a certain plan.
CREATE FUNCTION Extra_plan_amount(@mobile_num char(11), @plan_name varchar(50))
RETURNS INT
AS
BEGIN
    DECLARE @Extra INT
    DECLARE @plan_id INT
    DECLARE @payment_id INT

    SELECT TOP 1 @plan_id = s.planID, @payment_id = p.paymentID 
    FROM Payment p
    Inner Join Process_Payment process
    on process.paymentID = p.paymentID
    Inner Join Service_Plan s
    on  process.planID = s.planID
    WHERE p.mobileNo = @mobile_num AND s.name = @plan_name
    ORDER BY p.date_of_payment DESC; -- Ensure we are working with the latest payment

    SET @Extra = dbo.Extra_amount(@payment_id,@plan_id)
    RETURN @Extra
END;


GO
--Retrieve the top 10 successful payments with highest value for the input account.
CREATE PROCEDURE Top_Successful_Payments
@mobile_num char(11)
AS
    SELECT TOP 10 *
    FROM Payment 
    WHERE mobileNo = @mobile_num AND status = 'successful'
    ORDER BY amount DESC;


GO
--Retrieve all service plans the input account subscribed to in the past 5 months
CREATE FUNCTION Subscribed_plans_5_Months(@mobile_num char(11))
RETURNS TABLE 
AS 
RETURN (
        SELECT * 
        FROM Service_Plan
        WHERE EXISTS (
                        SELECT s.planID
                        FROM Subscription s 
                        WHERE s.mobileNo = @mobile_num 
                        AND DATEDIFF(MONTH, s.subscription_date, CURRENT_TIMESTAMP) <= 5 
                        AND Service_Plan.planID = s.planID
                    )
       );



GO
-- Initiate an accepted payment for the input account for plan renewal and 
-- update the status of the subscription accordingly.
CREATE PROCEDURE Initiate_plan_payment
@mobile_num char(11) ,
@amount decimal(10,1),
@payment_method varchar(50),
@plan_id int
AS

BEGIN TRANSACTION;

BEGIN TRY

    -- Check if there is such Subscription exists
    IF NOT EXISTS(  SELECT * 
                    FROM Subscription 
                    WHERE mobileNo = @mobile_num AND planID = @plan_id
                 )
    BEGIN
        RAISERROR ('No matching subscription found for the given MobileNo and Plan_ID.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    DECLARE @payment_id INT

    INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo)
    VALUES (@Amount, CURRENT_TIMESTAMP, @payment_method, 'successful', @mobile_num);

    SELECT @payment_id = p.paymentID from Payment p    
    where p.mobileNo = @mobile_num AND p.amount = @amount AND p.date_of_payment = CAST(CURRENT_TIMESTAMP AS DATE)
    AND p.payment_method = @payment_method AND p.status = 'successful'

    INSERT INTO process_payment(paymentID, planID) 
    VALUES(@payment_id, @plan_id)

    IF(SELECT remaining_balance FROM process_payment WHERE planID = @plan_id AND paymentID = @payment_id) = 0 
    BEGIN
        UPDATE Subscription
        SET status = 'active', subscription_date = CURRENT_TIMESTAMP
        WHERE mobileNo = @mobile_num AND planID = @plan_id
    END

    ELSE
    BEGIN
        UPDATE Subscription
        SET status = 'onhold', subscription_date = CURRENT_TIMESTAMP
        WHERE mobileNo = @mobile_num AND planID = @plan_id
    END
-- Commit the transaction if all steps succeed
    COMMIT TRANSACTION;

END TRY

BEGIN CATCH
    -- Handle errors and rollback the transaction
    ROLLBACK TRANSACTION;
    THROW;
END CATCH




GO
-- Calculate the amount of cashback that will be returned on the wallet of the customer of the input account
-- from a certain payment for the specified benefit and update the wallet�s balance accordingly.
CREATE PROCEDURE Payment_wallet_cashback
    @mobile_num CHAR(11),
    @payment_id INT,
    @benefit_id INT
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @WalletID INT;
        DECLARE @PaymentAmount DECIMAL(10, 1);
        DECLARE @Cashback DECIMAL(10, 1);
        DECLARE @ValidityDate DATE;
        DECLARE @BenefitStatus Varchar(50);

        -- Validate benefit validity
        SELECT @ValidityDate = validity_date
        FROM Benefits
        WHERE benefitID = @benefit_id;

        SELECT @BenefitStatus = status 
        FROM Benefits 
        where benefitID = @benefit_id

        IF @ValidityDate < CURRENT_TIMESTAMP OR @BenefitStatus = 'expired'
        BEGIN
            RAISERROR ('Benefit has expired.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Retrieve Wallet ID
        SELECT @WalletID = walletID
        FROM Wallet
        WHERE nationalID = (
            SELECT nationalID
            FROM Customer_Account
            WHERE mobileNo = @mobile_num
        );

        -- Retrieve Payment Amount
        SELECT @PaymentAmount = amount
        FROM Payment
        WHERE paymentID = @payment_id;

        -- Calculate Cashback
        SET @Cashback = 0.1 * @PaymentAmount;

        -- Update Wallet Balance
        UPDATE Wallet
        SET current_balance = current_balance + @Cashback,
            last_modified_date = CURRENT_TIMESTAMP
        WHERE walletID = @WalletID;

        -- Log Cashback
        INSERT INTO Cashback (benefitID, walletID, amount, credit_date)
        VALUES (@benefit_id, @WalletID, @Cashback, CURRENT_TIMESTAMP);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;




GO
--Initiate an accepted payment for the input account for balance recharge.
CREATE PROCEDURE Initiate_balance_payment
@mobile_num char(11),
@amount decimal(10,1),
@payment_method varchar(50)
AS
BEGIN;
    BEGIN TRANSACTION;

    BEGIN TRY
        INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo)
        VALUES (@Amount, CURRENT_TIMESTAMP, @Payment_Method, 'successful', @mobile_num);

        UPDATE Customer_Account
        SET balance = balance + @amount
        WHERE mobileNo = @mobile_num

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;




GO
--Redeem a voucher for the input account and update the total points of the account accordingly.
CREATE PROCEDURE Redeem_voucher_points
@mobile_num char(11),
@voucher_id int
AS
BEGIN;
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @RequiredPoints INT;
        DECLARE @CurrentPoints INT;
        DECLARE @voucherExpiryDate DATE;
        DECLARE @RedeemDateIfExists DATE;

        -- Get all info about the voucher
        SELECT @RequiredPoints = points, 
               @voucherExpiryDate = expiry_date,
               @RedeemDateIfExists = redeem_date
        FROM Voucher
        WHERE voucherID = @voucher_id;


        -- Get the current points of the account
        SELECT @CurrentPoints = points
        FROM Customer_Account
        WHERE mobileNo = @mobile_num;

        IF @CurrentPoints < @RequiredPoints
        BEGIN
            RAISERROR ('Insufficient points to redeem this voucher.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF @voucherExpiryDate < CURRENT_TIMESTAMP OR @RedeemDateIfExists IS NOT NULL
        BEGIN
            -- Voucher is expired or already redeemed
            RAISERROR('Voucher is either expired or already redeemed.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
    
        
        -- Deduct the points from the account
        UPDATE Customer_Account
        SET points = points - @RequiredPoints
        WHERE mobileNo = @mobile_num;

        -- Mark Voucher as redeemed
        UPDATE Voucher
        SET mobileNo = @mobile_num, redeem_date = CURRENT_TIMESTAMP
        WHERE voucherID = @voucher_id;
        

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

INSERT INTO Customer_profile (nationalID, first_name, last_name, email, address, date_of_birth)
VALUES
(101, 'John', 'Doe', 'john.doe@example.com', '123 Elm St', '1990-01-01'),
(102, 'Jane', 'Smith', 'jane.smith@example.com', '456 Oak St', '1985-06-15'),
(103, 'Alice', 'Brown', 'alice.brown@example.com', '789 Pine St', '2000-02-20'),
(104, 'Bob', 'White', 'bob.white@example.com', '101 Maple St', '1992-08-10'),
(105, 'Charlie', 'Johnson', 'charlie.johnson@example.com', '202 Birch St', '1995-04-15'),
(106, 'Eve', 'Davis', 'eve.davis@example.com', '303 Cedar St', '1988-03-30'),
(107, 'Frank', 'Wilson', 'frank.wilson@example.com', '404 Oak St', '1991-07-22'),
(108, 'Grace', 'Moore', 'grace.moore@example.com', '505 Willow St', '1989-05-17'),
(109, 'Hank', 'Taylor', 'hank.taylor@example.com', '606 Pine St', '1994-12-25'),
(110, 'Ivy', 'Anderson', 'ivy.anderson@example.com', '707 Elm St', '1992-11-11'),
(111, 'Jack', 'Thomas', 'jack.thomas@example.com', '808 Maple St', '1987-09-05'),
(112, 'Kathy', 'Martinez', 'kathy.martinez@example.com', '909 Oak St', '1993-01-23'),
(113, 'Liam', 'Hernandez', 'liam.hernandez@example.com', '1010 Birch St', '1990-10-30'),
(114, 'Mona', 'King', 'mona.king@example.com', '1111 Cedar St', '1986-06-18'),
(115, 'Nina', 'Scott', 'nina.scott@example.com', '1212 Willow St', '1994-02-12'),
(116, 'Oscar', 'García', 'oscar.garcia@example.com', '1313 Pine St', '1989-12-28'),
(117, 'Paul', 'Lopez', 'paul.lopez@example.com', '1414 Elm St', '1991-11-01'),
(118, 'Quincy', 'Young', 'quincy.young@example.com', '1515 Maple St', '1992-02-17');

INSERT INTO Customer_Account (mobileNo, pass, balance, account_type, start_date, status, points, nationalID)
VALUES
('01010101010', 'pass123', 150.0, 'Post Paid', '2023-01-01', 'active', 10, 101),
('01020202020', 'securepass', 75.5, 'Prepaid', '2023-06-01', 'active', 5, 102),
('01030303030', 'mypassword', 0.0, 'Pay_as_you_go', '2023-07-15', 'onhold', 0, 103),
('01040404040', 'bobpass', 250.0, 'Post Paid', '2023-08-01', 'active', 20, 104),
('01050505050', 'charliepass', 100.5, 'Prepaid', '2023-09-01', 'active', 15, 105),
('01060606060', 'evepass', 500.0, 'Post Paid', '2023-10-01', 'onhold', 30, 106),
('01070707070', 'frankpass', 200.0, 'Prepaid', '2023-11-01', 'active', 25, 107),
('01080808080', 'gracepass', 50.0, 'Pay_as_you_go', '2023-12-01', 'active', 8, 108),
('01090909090', 'hankpass', 150.0, 'Post Paid', '2023-01-15', 'active', 12, 109),
('01101010101', 'ivypass', 400.0, 'Prepaid', '2023-02-01', 'active', 18, 110),
('01111111111', 'jackpass', 300.0, 'Post Paid', '2023-03-01', 'active', 22, 111),
('01121212121', 'kathy123', 150.0, 'Pay_as_you_go', '2023-04-01', 'active', 9, 112),
('01131313131', 'liampass', 200.0, 'Post Paid', '2023-05-01', 'onhold', 10, 113),
('01141414141', 'monapass', 100.0, 'Prepaid', '2023-06-01', 'active', 5, 114),
('01151515151', 'ninapass', 0.0, 'Pay_as_you_go', '2023-07-01', 'onhold', 0, 115),
('01161616161', 'oscarpass', 600.0, 'Post Paid', '2023-08-01', 'active', 40, 116),
('01171717171', 'paulpass', 350.0, 'Prepaid', '2023-09-01', 'active', 35, 117),
('01181818181', 'quincy123', 120.0, 'Post Paid', '2023-10-01', 'active', 18, 118);

INSERT INTO Service_Plan (SMS_offered, minutes_offered, data_offered, name, price, description)
VALUES
(100, 200, 1024, 'Basic Plan', 50, 'Basic monthly plan'),
(300, 500, 2048, 'Premium Plan', 100, 'Premium plan with more data'),
(500, 1000, 4096, 'Unlimited Plan', 200, 'Unlimited everything'),
(200, 400, 2048, 'Family Plan', 120, 'Plan for families with shared minutes'),
(250, 500, 3072, 'Student Plan', 75, 'Affordable plan for students'),
(150, 300, 512, 'Starter Plan', 30, 'Entry-level plan'),
(400, 800, 2048, 'Business Plan', 150, 'For small businesses with high usage'),
(350, 700, 1024, 'Travel Plan', 90, 'Designed for international travelers'),
(600, 1200, 8192, 'High Data Plan', 250, 'High data for heavy users'),
(300, 600, 4096, 'Basic Data Plan', 85, 'Standard plan with a balanced offering'),
(150, 300, 5120, 'Junior Plan', 45, 'Plan for kids with low data usage'),
(100, 250, 1024, 'Light Plan', 40, 'Light plan for casual users'),
(200, 500, 2048, 'Media Plan', 110, 'Plan with media streaming benefits'),
(500, 1000, 4096, 'Global Plan', 200, 'Plan with global coverage'),
(250, 500, 2048, 'Entertainment Plan', 95, 'Plan with free streaming services'),
(300, 600, 1024, 'Call & Data Plan', 80, 'Plan with unlimited calls and moderate data'),
(350, 700, 3072, 'Unlimited Calls Plan', 120, 'Unlimited calls with moderate data'),
(150, 350, 1024, 'Basic + Plan', 65, 'Basic plan with extra data'),
(200, 400, 2048, 'Plus Plan', 110, 'Plan with extra minutes and data');

INSERT INTO Subscription (mobileNo, planID, subscription_date, status)
VALUES
('01010101010', 1, '2023-02-01', 'active'),
('01020202020', 2, '2023-07-01', 'onhold'),
('01030303030', 3, '2023-08-01', 'active'),
('01040404040', 4, '2023-09-01', 'active'),
('01050505050', 5, '2023-10-01', 'onhold'),
('01060606060', 6, '2023-11-01', 'active'),
('01070707070', 7, '2023-12-01', 'active'),
('01080808080', 8, '2023-01-01', 'onhold'),
('01090909090', 9, '2023-03-01', 'active'),
('01101010101', 10, '2023-04-01', 'active'),
('01111111111', 1, '2023-05-01', 'active'),
('01121212121', 2, '2023-06-01', 'onhold'),
('01131313131', 3, '2023-07-01', 'active'),
('01141414141', 4, '2023-08-01', 'active'),
('01151515151', 5, '2023-09-01', 'onhold');


INSERT INTO Plan_Usage (start_date, end_date, data_consumption, minutes_used, SMS_sent, mobileNo, planID)
VALUES
('2023-02-01', '2023-02-28', 1024, 300, 50, '01010101010', 1),
('2023-03-01', '2023-03-31', 2048, 500, 150, '01020202020', 2),
('2023-04-01', '2023-04-30', 4096, 600, 200, '01030303030', 3),
('2023-05-01', '2023-05-31', 1024, 400, 100, '01040404040', 4),
('2023-06-01', '2023-06-30', 2048, 550, 120, '01050505050', 5),
('2023-07-01', '2023-07-31', 3072, 700, 250, '01060606060', 6),
('2023-08-01', '2023-08-31', 5120, 800, 300, '01070707070', 7),
('2023-09-01', '2023-09-30', 1024, 350, 75, '01080808080', 8),
('2023-10-01', '2023-10-31', 2048, 500, 100, '01090909090', 9),
('2023-11-01', '2023-11-30', 4096, 750, 180, '01101010101', 10),
('2023-12-01', '2023-12-31', 3072, 600, 150, '01111111111', 1),
('2024-01-01', '2024-01-31', 1024, 250, 50, '01121212121', 2),
('2024-02-01', '2024-02-29', 2048, 400, 100, '01131313131', 3),
('2024-03-01', '2024-03-31', 3072, 500, 120, '01141414141', 4),
('2024-04-01', '2024-04-30', 5120, 650, 200, '01151515151', 5);

INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo)
VALUES
(100.0, '2023-02-10', 'cash', 'successful', '01010101010'),
(150.5, '2023-03-15', 'credit', 'pending', '01020202020'),
(200.0, '2023-04-20', 'cash', 'successful', '01030303030'),
(50.0, '2023-05-25', 'credit', 'rejected', '01040404040'),
(75.0, '2023-06-30', 'cash', 'successful', '01050505050'),
(120.0, '2023-07-10', 'credit', 'successful', '01060606060'),
(300.0, '2023-08-05', 'cash', 'successful', '01070707070'),
(85.0, '2023-09-12', 'credit', 'pending', '01080808080'),
(100.0, '2023-10-18', 'cash', 'successful', '01090909090'),
(250.0, '2023-11-23', 'credit', 'successful', '01101010101'),
(120.0, '2023-12-30', 'cash', 'rejected', '01111111111'),
(180.0, '2024-01-05', 'credit', 'successful', '01121212121'),
(250.0, '2024-02-01', 'cash', 'successful', '01131313131'),
(130.0, '2024-03-08', 'credit', 'pending', '01141414141'),
(90.0, '2024-04-15', 'cash', 'successful', '01151515151');


INSERT INTO Process_Payment (paymentID, planID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 1),
(12, 2),
(13, 3),
(14, 4),
(15, 5);


INSERT INTO Wallet (current_balance, currency, last_modified_date, nationalID, mobileNo)
VALUES
(500.00, 'egp', '2023-02-01', 101, '01010101010'),
(150.50, 'usd', '2023-03-01', 102, '01020202020'),
(300.00, 'egp', '2023-04-01', 103, '01030303030'),
(450.75, 'egp', '2023-05-01', 104, '01040404040'),
(120.00, 'usd', '2023-06-01', 105, '01050505050'),
(500.50, 'egp', '2023-07-01', 106, '01060606060'),
(350.25, 'usd', '2023-08-01', 107, '01070707070'),
(200.00, 'egp', '2023-09-01', 108, '01080808080'),
(600.00, 'usd', '2023-10-01', 109, '01090909090'),
(150.00, 'egp', '2023-11-01', 110, '01101010101'),
(450.25, 'usd', '2023-12-01', 111, '01111111111'),
(200.00, 'egp', '2024-01-01', 112, '01121212121'),
(550.00, 'usd', '2024-02-01', 113, '01131313131'),
(320.00, 'egp', '2024-03-01', 114, '01141414141'),
(280.00, 'usd', '2024-04-01', 115, '01151515151');


INSERT INTO Transfer_money (walletID1, walletID2, amount, transfer_date)
VALUES
(1, 2, 100.00, '2023-02-10'),
(2, 3, 150.50, '2023-03-15'),
(3, 4, 200.00, '2023-04-20'),
(4, 5, 50.00, '2023-05-25'),
(5, 6, 75.00, '2023-06-30'),
(6, 7, 120.00, '2023-07-10'),
(7, 8, 300.00, '2023-08-05'),
(8, 9, 85.00, '2023-09-12'),
(9, 10, 100.00, '2023-10-18'),
(10, 11, 250.00, '2023-11-23'),
(11, 12, 120.00, '2023-12-30'),
(12, 13, 180.00, '2024-01-05'),
(13, 14, 250.00, '2024-02-01'),
(14, 15, 130.00, '2024-03-08');

INSERT INTO Benefits (description, validity_date, status, mobileNo)
VALUES
('Free 1GB data', '2023-06-30', 'active', '01010101010'),
('50% off next recharge', '2023-07-15', 'active', '01020202020'),
('5% cashback', '2023-08-01', 'active', '01030303030'),
('Bonus 500 SMS', '2023-09-30', 'expired', '01040404040'),
('Free movie ticket', '2023-10-10', 'active', '01050505050'),
('Free 1000 SMS', '2023-11-25', 'active', '01060606060'),
('Free data rollover', '2023-12-15', 'expired', '01070707070'),
('Access to premium support', '2024-01-10', 'active', '01080808080'),
('Exclusive partner discounts', '2024-02-20', 'expired', '01090909090'),
('Free concert tickets', '2024-03-01', 'active', '01101010101'),
('Exclusive mobile offers', '2024-04-05', 'active', '01111111111'),
('Bonus 200 minutes', '2024-05-15', 'active', '01121212121'),
('Double points on purchases', '2024-06-01', 'expired', '01131313131'),
('Free subscription to premium plan', '2024-07-01', 'active', '01141414141'),
('Exclusive holiday package discount', '2024-08-01', 'active', '01151515151');

INSERT INTO Points_Group (benefitID, pointsAmount, PaymentID)
VALUES
(1, 100, 1),
(2, 50, 2),
(3, 200, 3),
(4, 75, 4),
(5, 150, 5),
(6, 100, 6),
(7, 250, 7),
(8, 200, 8),
(9, 300, 9),
(10, 50, 10),
(11, 400, 11),
(12, 100, 12),
(13, 150, 13),
(14, 200, 14),
(15, 500, 15);
  
INSERT INTO Exclusive_Offer (benefitID, internet_offered, SMS_offered, minutes_offered)
VALUES
(1, 1024, 100, 200),
(2, 2048, 150, 300),
(3, 4096, 200, 400),
(4, 5120, 250, 500),
(5, 1024, 100, 200),
(6, 2048, 150, 300),
(7, 3072, 200, 400),
(8, 5120, 250, 500),
(9, 1024, 100, 200),
(10, 2048, 150, 300),
(11, 4096, 200, 400),
(12, 5120, 250, 500),
(13, 1024, 100, 200),
(14, 2048, 150, 300),
(15, 3072, 200, 400);

INSERT INTO Cashback (benefitID, walletID, amount, credit_date)
VALUES
(1, 1, 10.0, '2023-02-15'),
(2, 2, 15.5, '2023-03-20'),
(3, 3, 20.0, '2023-04-25'),
(4, 4, 5.0, '2023-05-30'),
(5, 5, 7.5, '2023-06-05'),
(6, 6, 12.0, '2023-07-12'),
(7, 7, 30.0, '2023-08-18'),
(8, 8, 8.5, '2023-09-22'),
(9, 9, 10.0, '2023-10-30'),
(10, 10, 25.0, '2023-11-10'),
(11, 11, 12.0, '2023-12-05'),
(12, 12, 18.0, '2024-01-10'),
(13, 13, 25.0, '2024-02-15'),
(14, 14, 13.0, '2024-03-20'),
(15, 15, 9.0, '2024-04-25');


INSERT INTO Plan_Provides_Benefits (benefitID, planID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 1),
(12, 2),
(13, 3),
(14, 4),
(15, 5);


INSERT INTO Shop (name, category)
VALUES
('Shop 1', 'Electronics'),
('Shop 2', 'Clothing'),
('Shop 3', 'Groceries'),
('Shop 4', 'Furniture'),
('Shop 5', 'Books'),
('Shop 6', 'Sports'),
('Shop 7', 'Toys'),
('Shop 8', 'Automotive'),
('Shop 9', 'Jewelry'),
('Shop 10', 'Beauty'),
('Shop 11', 'Home Appliances'),
('Shop 12', 'Furniture'),
('Shop 13', 'Electronics'),
('Shop 14', 'Clothing'),
('Shop 15', 'Groceries');


INSERT INTO Physical_Shop (shopID, address, working_hours)
VALUES
(1, '123 Main St', '9 AM - 9 PM'),
(2, '456 Oak St', '10 AM - 6 PM'),
(3, '789 Pine St', '8 AM - 10 PM'),
(4, '101 Maple St', '9 AM - 9 PM'),
(5, '202 Birch St', '9 AM - 5 PM'),
(6, '303 Cedar St', '10 AM - 8 PM'),
(7, '404 Elm St', '11 AM - 7 PM'),
(8, '505 Redwood St', '10 AM - 6 PM'),
(9, '606 Willow St', '9 AM - 9 PM'),
(10, '707 Ash St', '8 AM - 8 PM'),
(11, '808 Oak St', '9 AM - 9 PM'),
(12, '909 Pine St', '10 AM - 7 PM'),
(13, '1010 Maple St', '8 AM - 6 PM'),
(14, '1111 Birch St', '9 AM - 9 PM'),
(15, '1212 Cedar St', '10 AM - 8 PM');


INSERT INTO E_SHOP (shopID, URL, rating)
VALUES
(1, 'https://www.amazon.com', 4),
(2, 'https://www.ebay.com', 3),
(3, 'https://www.etsy.com', 5),
(4, 'https://www.walmart.com', 4),
(5, 'https://www.bestbuy.com', 3),
(6, 'https://www.target.com', 5),
(7, 'https://www.aliexpress.com', 2),
(8, 'https://www.newegg.com', 4),
(9, 'https://www.zalando.com', 4),
(10, 'https://www.shopify.com', 5),
(11, 'https://www.overstock.com', 3),
(12, 'https://www.costco.com', 2),
(13, 'https://www.homedepot.com', 5),
(14, 'https://www.samsclub.com', 3),
(15, 'https://www.kohls.com', 4);



INSERT INTO Voucher (value, expiry_date, points, mobileNo, shopID, redeem_date)
VALUES
(50, '2023-05-01', 100, '01010101010', 1, '2023-03-01'),
(100, '2023-06-01', 200, '01020202020', 2, '2023-04-01'),
(150, '2023-07-01', 300, '01030303030', 3, '2023-05-01'),
(200, '2023-08-01', 400, '01040404040', 4, '2023-06-01'),
(250, '2023-09-01', 500, '01050505050', 5, '2023-07-01'),
(300, '2023-10-01', 600, '01060606060', 6, '2023-08-01'),
(350, '2023-11-01', 700, '01070707070', 7, '2023-09-01'),
(400, '2023-12-01', 800, '01080808080', 8, '2023-10-01'),
(450, '2024-01-01', 900, '01090909090', 9, '2023-11-01'),
(500, '2024-02-01', 1000, '01101010101', 10, '2023-12-01'),
(550, '2024-03-01', 1100, '01111111111', 11, '2024-01-01'),
(600, '2024-04-01', 1200, '01121212121', 12, '2024-02-01'),
(650, '2024-05-01', 1300, '01131313131', 13, '2024-03-01'),
(700, '2024-06-01', 1400, '01141414141', 14, '2024-04-01'),
(750, '2024-07-01', 1500, '01151515151', 15, '2024-05-01');

INSERT INTO Technical_Support_Ticket (mobileNo, Issue_description, priority_level, status)
VALUES
('01010101010', 'Network connectivity issue', 3, 'Resolved'),
('01020202020', 'Account billing discrepancy', 2, 'Resolved'),
('01030303030', 'Unable to make outgoing calls', 1, 'Resolved'),
('01040404040', 'Data not working', 2, 'Resolved'),
('01050505050', 'Overcharged for last month', 2, 'In Progress'),
('01060606060', 'SIM card not activated', 1, 'Resolved'),
('01070707070', 'Unable to top-up account', 3, 'Resolved'),
('01080808080', 'Account suspended error', 2, 'Resolved'),
('01090909090', 'Payment not reflected in balance', 3, 'Resolved'),
('01101010101', 'Unable to use data services', 1, 'Resolved'),
('01111111111', 'No signal in the area', 2, 'Resolved'),
('01121212121', 'Balance not updating after recharge', 3, 'In Progress'),
('01131313131', 'System outage', 1, 'Resolved'),
('01141414141', 'Wrong plan applied', 2, 'Resolved'),
('01151515151', 'Service interruption', 3, 'Resolved'),
('01161616161', 'Account frozen due to suspicious activity', 1, 'In Progress'),
('01171717171', 'Mobile number transfer issue', 2, 'Resolved'),
('01181818181', 'No internet access', 1, 'Resolved');


SELECT * FROM Customer_profile;
SELECT * FROM Customer_Account;
SELECT * FROM Service_Plan;
SELECT * FROM Subscription;
SELECT * FROM Plan_Usage;
SELECT * FROM Payment;
SELECT * FROM Process_Payment;
SELECT * FROM Wallet;
SELECT * FROM Transfer_money;
SELECT * FROM Benefits;
SELECT * FROM Points_Group;
SELECT * FROM Exclusive_Offer;
SELECT * FROM Cashback;
SELECT * FROM Plan_Provides_Benefits;
SELECT * FROM Shop;
SELECT * FROM Physical_Shop;
SELECT * FROM E_SHOP;
SELECT * FROM Voucher;
SELECT * FROM Technical_Support_Ticket;
