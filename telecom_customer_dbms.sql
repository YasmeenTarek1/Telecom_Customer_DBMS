CREATE DATABASE Telecom_Team_8

GO

USE Telecom_Team_8

GO
CREATE PROCEDURE createAllTables AS
BEGIN


    ------------ Customer Management --------------------------------



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
        account_type VARCHAR(50) CHECK(account_type IN('Post Paid','Prepaid','Pay as you go')),
        start_date DATE NOT NULL,
        status VARCHAR(50) CHECK(status IN('active','onhold')),
        points INT DEFAULT 0,
        nationalID INT,
        CONSTRAINT PK_Customer_Account PRIMARY KEY(mobileNo),
        CONSTRAINT FK_nationalID_Customer_Account FOREIGN KEY(nationalID) REFERENCES Customer_profile(nationalID)
    );


    --------------- Wallet and Money Transfers ------------------------



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




    ------------ Service Plans and Subscriptions -----------------------




    CREATE TABLE Service_Plan(      -- general table (contains the available plans generally) 
        planID INT IDENTITY(1,1),
        SMS_offered INT NOT NULL,
        minutes_offered INT NOT NULL,
        data_offered INT NOT NULL,
        name VARCHAR(50) NOT NULL,
        price INT NOT NULL,
        description VARCHAR(50),
        expiryIntervalDays INT,     -- Expiry interval in days
        CONSTRAINT PK_Service_Plan PRIMARY KEY(planID)
    );

    CREATE TABLE Payment(          -- Plan Subcribtions / Plan Renewals / Balance Recharging
        paymentID INT IDENTITY(1,1),
        amount DECIMAL(10,1) NOT NULL,
        date_of_payment DATE NOT NULL,
        payment_method VARCHAR(50) CHECK(payment_method IN('cash','credit')) ,
        status VARCHAR(50) CHECK(status IN('successful','pending','rejected')),
        mobileNo CHAR(11),
        CONSTRAINT PK_Payment PRIMARY KEY(paymentID),
        CONSTRAINT FK_mobileNo_Payment FOREIGN KEY(mobileNo) REFERENCES Customer_Account(mobileNo)
    );

    CREATE TABLE Process_Payment(   -- Plan Subcribtions / Plan Renewals
        paymentID INT,
        planID INT,
        remaining_balance AS (dbo.Remaining_amount(paymentID , planID)),
        extra_amount AS (dbo.Extra_amount(paymentID , planID))     
        CONSTRAINT PK_Process_Payment PRIMARY KEY(paymentID),
        CONSTRAINT FK_paymentID_Process_Payment FOREIGN KEY (paymentID) REFERENCES Payment(paymentID),
        CONSTRAINT FK_planID_Process_Payment FOREIGN KEY (planID) REFERENCES Service_Plan(planID)
    );

    CREATE TABLE Subscription(      -- each account along with its subscribed plans
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
        expiry_date DATE NOT NULL,
        data_consumption INT,
        minutes_used INT,
        SMS_sent INT,
        mobileNo CHAR(11),
        planID INT,
        CONSTRAINT PK_Plan_Usage PRIMARY KEY(usageID),
        CONSTRAINT FK_mobileNo_Plan_Usage FOREIGN KEY(mobileNo) REFERENCES Customer_Account(mobileNo),
        CONSTRAINT FK_planID_Plan_Usage FOREIGN KEY(planID) REFERENCES Service_Plan(planID)
    );




    ----------------- Benefits -------------------------------------



    -- General Tables
    CREATE TABLE Benefits (
        benefitID INT IDENTITY(1,1),
        description VARCHAR(50),
        expiryIntervalDays INT, -- Expiry interval in days
        CONSTRAINT PK_Benefits PRIMARY KEY (benefitID)
    );

    CREATE TABLE Points_Group(            -- General Table
        pointID INT IDENTITY(1,1),
        benefitID INT,
        amount INT,
        CONSTRAINT PK_Points_Group PRIMARY KEY (pointID,benefitID),
        CONSTRAINT FK_benefitID_Points_Group FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID)
    );

    CREATE TABLE Exclusive_Offer(         -- General Table
        offerID INT IDENTITY(1,1),
        benefitID INT,
        internet_offered INT,
        SMS_offered INT,
        minutes_offered INT,
        CONSTRAINT PK_Exclusive_Offer PRIMARY KEY (offerID,benefitID),
        CONSTRAINT FK_benefitID_Exclusive_Offer FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID)
    );

    CREATE TABLE Cashback(                -- General Table  -- Cashback is calculated as given percentage of the payment amount.
        CashbackID INT IDENTITY(1,1),
        benefitID INT,
        percentage INT,
        CONSTRAINT PK_Cashback PRIMARY KEY (CashbackID,benefitID),
        CONSTRAINT FK_benefitID_Cashback FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID)
    );

    -- Customer-Specific Tracking Tables
    CREATE TABLE Customer_Benefits (
        benefitID INT IDENTITY(1,1),
        mobileNo CHAR(11),
        PaymentID INT,          -- Payment ID in which this benefit was offered
        walletID INT,
        start_date DATE NOT NULL,
        expiry_date DATE NOT NULL,
        status AS (             -- status column value is not stored in the database. It is computed on-the-fly whenever it is accessed.
            CASE 
                WHEN expiry_date >= CAST(GETDATE() AS DATE) THEN 'active'
                ELSE 'expired'
            END
        ),
        CONSTRAINT PK_Customer_Benefits PRIMARY KEY (benefitID),
        CONSTRAINT FK_mobileNo_Customer_Benefits FOREIGN KEY (mobileNo) REFERENCES Customer_Account(mobileNo),
        CONSTRAINT FK_PaymentID_Customer_Benefits FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID),
        CONSTRAINT FK_walletID_Customer_Benefits FOREIGN KEY (walletID) REFERENCES Wallet(walletID)
    );
    
    CREATE TABLE Customer_Points (
        pointID INT IDENTITY(1,1),
        benefitID INT,
        points_offered INT,
        CONSTRAINT PK_Customer_Points PRIMARY KEY (pointID, benefitID),
        CONSTRAINT FK_benefit_ID_Customer_Points FOREIGN KEY (benefitID) REFERENCES Customer_Benefits(benefitID),
    );

    CREATE TABLE Customer_Cashback (
        CashbackID INT IDENTITY(1,1),      
        benefitID INT,       
        amount_earned DECIMAL(10,2),
        CONSTRAINT PK_Customer_Cashback PRIMARY KEY (CashbackID, benefitID),
        CONSTRAINT FK_benefit_ID_Customer_Cashback FOREIGN KEY (benefitID) REFERENCES Customer_Benefits(benefitID),
    );

    CREATE TABLE Customer_Exclusive_Offers (
        offerID INT IDENTITY(1,1),        
        benefitID INT,     
        data_offered INT,
        minutes_offered INT,
        SMS_offered INT,
        CONSTRAINT PK_Customer_Exclusive_Offers PRIMARY KEY(offerID, benefitID),
        CONSTRAINT FK_benefit_ID_Customer_Exclusive_Offers FOREIGN KEY (benefitID) REFERENCES Customer_Benefits(benefitID),
    );

    -- Tracking Points Group & Offers Consumption Table
    CREATE TABLE Benefit_Usage(           
        benefitID INT,
        points_used INT,
        data_used INT,
        minutes_used INT,
        SMS_used INT,
        usage_date DATE, -- Date when the benefit was 
        CONSTRAINT PK_Benefit_Usage PRIMARY KEY(benefitID),
        CONSTRAINT FK_benefitID_Benefit_Usage FOREIGN KEY(benefitID) REFERENCES Customer_Benefits(benefitID)
    );


    -------------- Benefits for each Plan -------------------------



    CREATE TABLE Plan_Provides_Benefits(
        benefitID INT,
        planID INT,
        CONSTRAINT PK_Plan_Provides_Benefits PRIMARY KEY (planID,benefitID),
        CONSTRAINT FK_benefitID_Plan_Provides_Benefits FOREIGN KEY (benefitID) REFERENCES Benefits(benefitID),
        CONSTRAINT FK_planID_Plan_Provides_Benefits FOREIGN KEY (planID) REFERENCES Service_Plan(planID)
    );



    ------------- Shops and Vouchers ----------------------------



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



    ------------- Technical Support ----------------------------



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
DROP TABLE  Customer_Cashback;
DROP TABLE  Customer_Points;
DROP TABLE  Customer_Exclusive_Offers;
DROP TABLE  Benefit_Usage;
DROP TABLE  Customer_Benefits;
DROP TABLE  Points_Group;
DROP TABLE  Exclusive_Offer;
DROP TABLE  Cashback;
DROP TABLE  Plan_Provides_Benefits;
DROP TABLE  Voucher;
DROP TABLE  Technical_Support_Ticket;
DROP TABLE  Transfer_money;
DROP TABLE  Process_Payment;
DROP TABLE  Plan_Usage;
DROP TABLE  Benefits;
DROP TABLE  Subscription;
DROP TABLE  Payment;
DROP TABLE  Wallet;
DROP TABLE  Service_Plan;
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
    DROP PROCEDURE IF EXISTS Get_AllCustomerAccounts;
    DROP PROCEDURE IF EXISTS GetSubscribersForPlan;
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
CREATE VIEW allServicePlans AS  -- General Info
SELECT *
FROM Service_Plan;

Go 
--Fetch details for all shops.
CREATE VIEW allShops As
Select *
From Shop;


GO
CREATE PROCEDURE Handle_Expired_Points
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @benefitID INT;
        DECLARE @mobileNo CHAR(11);
        DECLARE @pointsEarned INT;
        DECLARE @pointsUsed INT;
        DECLARE @unusedPoints INT;

        -- Cursor to iterate through expired benefits
        DECLARE benefit_cursor CURSOR FOR
        SELECT CB.benefitID, CB.mobileNo, CP.points_offered, ISNULL(BU.points_used, 0)
        FROM Customer_Benefits CB
        INNER JOIN Customer_Points CP ON CB.benefitID = CP.benefitID
        LEFT JOIN Benefit_Usage BU ON CB.benefitID = BU.benefitID
        WHERE CB.status = 'expired';

        OPEN benefit_cursor;
        FETCH NEXT FROM benefit_cursor INTO @benefitID, @mobileNo, @pointsEarned, @pointsUsed;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @unusedPoints = @pointsEarned - @pointsUsed;

            UPDATE Customer_Account
            SET points = points - @unusedPoints
            WHERE mobileNo = @mobileNo;

            DELETE FROM Customer_Points 
            Where benefitID = @benefitID

            FETCH NEXT FROM benefit_cursor INTO @benefitID, @mobileNo, @pointsEarned, @pointsUsed;
        END

        CLOSE benefit_cursor;
        DEALLOCATE benefit_cursor;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

GO
CREATE PROCEDURE allCustomerAccounts
AS
BEGIN
    EXEC Handle_Expired_Points;
    SELECT 
        p.nationalID,
        p.first_name,
        p.last_name,
        p.email,
        p.address,
        CAST(p.date_of_birth AS CHAR(10)) AS date_of_birth,
        a.mobileNo,
        a.account_type,
        a.status AS 'Account_Status',
        CAST(a.start_date AS CHAR(10)) AS start_date,
        a.balance,
        a.points,
        dbo.Wallet_MobileNo(a.mobileNo) AS 'Has Wallet'
    FROM Customer_profile p
    INNER JOIN Customer_Account a 
    ON p.nationalID = a.nationalID
    ORDER BY Account_Status;
END;



-------------- Yellow part ------------------


Go
---Fetch details for all payments along with their corresponding Accounts.
CREATE VIEW AccountPayments AS
SELECT paymentID, mobileNo, amount, payment_method, date_of_payment, status AS 'Payment_Status'
FROM Payment;

Go
--Fetch details for all tickets.
CREATE VIEW allTickets As
Select ticketID, mobileNo, Issue_description, priority_level, status AS 'Ticket_Status' 
From Technical_Support_Ticket;

Go
--Fetch details of all wallets along with their customer names.
CREATE VIEW CustomerWallet As
Select W.walletID, C.first_name, C.last_name, W.mobileNo, W.current_balance, W.currency, W.last_modified_date
From  Wallet W,Customer_profile C 
where W.nationalID = C.nationalID;

Go
-- Fetch the list of all E-shops along with their redeemed vouchers's ids and values.
CREATE VIEW E_shopVouchers As
Select E.shopID, S.name, E.URL, E.rating ,V.voucherID AS 'Redeemed Voucher ID', V.value AS 'Redeemed Voucher Value'
From  E_SHOP E 
Inner join Voucher V 
ON E.shopID = V.shopID
Inner Join Shop S
ON S.shopID = E.shopID;

Go
--Fetch the list of all physical stores along with their redeemed vouchers's ids and values.
CREATE VIEW PhysicalStoreVouchers As
Select P.shopID, S.name, P.address, P.working_hours, V.voucherID AS 'Redeemed Voucher ID', V.value AS 'Redeemed Voucher Value'
From Physical_Shop P 
Inner join Voucher V 
ON P.shopID = V.shopID
Inner Join Shop S
ON S.shopID = P.shopID;

Go
--Fetch number of cashback transactions per each wallet.
CREATE VIEW Num_of_cashback As
Select CB.walletID, CP.first_name, CP.last_name, count(*) AS 'count of transactions', SUM(CH.amount_earned) AS 'Amount of cashback'
From Customer_Cashback CH
INNER JOIN Customer_Benefits CB
ON CH.benefitID = CB.benefitID
INNER JOIN Customer_Account CA
ON CA.mobileNo = CB.mobileNo
INNER JOIN Customer_profile CP
ON CP.nationalID = CA.nationalID
Group by CB.walletID, CP.first_name, CP.last_name;

Go 
--List all accounts along with the service plans they are subscribed to
CREATE PROCEDURE Account_Plan AS
Select S.mobileNo, S.planID, Sp.name AS 'Plan Name', Sp.description, Sp.SMS_offered, Sp.data_offered, Sp.minutes_offered, S.subscription_date, S.status AS 'Subscription Status'
From Customer_Account C 
Inner join Subscription S 
ON C.mobileNo = S.mobileNo 
Inner join Service_Plan Sp 
ON S.planID = Sp.planID
ORDER BY S.subscription_date DESC;



-------------- Green part ------------------


Go
--Retrieve the list of accounts subscribed to the input plan starting from a certain date
CREATE FUNCTION Account_Plan_date(@sub_date date,@plan_id int)
RETURNS TABLE
AS
    RETURN(
        Select S.mobileNo AS Account_Mobile_Number, SP.planID AS Service_Plan_ID, SP.name AS Service_Plan_Name
        From Subscription S 
        inner join Service_Plan SP 
        ON S.planID = SP.planID
        Where S.subscription_date >= @sub_date AND S.planID = @Plan_id
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

    DELETE CP
    From Customer_Points CP
    Inner Join Customer_Benefits CB
    ON CB.benefitID = CP.benefitID
    Inner Join Payment P
    On P.paymentID = CB.PaymentID
    Inner Join Process_Payment PP
    ON PP.paymentID = P.paymentID
    Where PP.planID = @plan_id AND CB.mobileNo = @mobile_num

    DELETE CH
    From Customer_Cashback CH
    Inner Join Customer_Benefits CB
    ON CB.benefitID = CH.benefitID
    Inner Join Payment P
    On P.paymentID = CB.PaymentID
    Inner Join Process_Payment PP
    ON PP.paymentID = P.paymentID
    Where PP.planID = @plan_id AND CB.mobileNo = @mobile_num

    DELETE CE
    From Customer_Exclusive_Offers CE
    Inner Join Customer_Benefits CB
    ON CB.benefitID = CE.benefitID
    Inner Join Payment P
    On P.paymentID = CB.PaymentID
    Inner Join Process_Payment PP
    ON PP.paymentID = P.paymentID
    Where PP.planID = @plan_id AND CB.mobileNo = @mobile_num

    DELETE CB
    From Customer_Benefits CB
    Inner Join Payment P
    On P.paymentID = CB.PaymentID
    Inner Join Process_Payment PP
    ON PP.paymentID = P.paymentID
    Where PP.planID = @plan_id AND CB.mobileNo = @mobile_num

    COMMIT TRANSACTION;
END;

GO
--Display all benefits offered to the input account for a certain plan
CREATE PROCEDURE Benefits_Account_Plan
    @mobile_num CHAR(11),
    @plan_id INT,
    @points_earned INT OUTPUT,
    @cashback_earned DECIMAL(10, 2) OUTPUT,
    @data_offered INT OUTPUT,
    @minutes_offered INT OUTPUT,
    @SMS_offered INT OUTPUT
AS
BEGIN
    SELECT 
        @points_earned = ISNULL(CP.points_offered, 0),
        @cashback_earned = ISNULL(CH.amount_earned, 0),
        @data_offered = ISNULL(CE.data_offered, 0),
        @minutes_offered = ISNULL(CE.minutes_offered, 0),
        @SMS_offered = ISNULL(CE.SMS_offered, 0)
    FROM Customer_Benefits CB
    INNER JOIN Payment P ON P.paymentID = CB.PaymentID
    INNER JOIN Process_Payment PP ON PP.paymentID = P.paymentID
    INNER JOIN Customer_Points CP ON CB.benefitID = CP.benefitID
    INNER JOIN Customer_Cashback CH ON CB.benefitID = CH.benefitID
    INNER JOIN Customer_Exclusive_Offers CE ON CB.benefitID = CE.benefitID
    WHERE PP.planID = @plan_id AND CB.mobileNo = @mobile_num;
END;


GO
--Retrieve the list of gained offers of type SMS for the input account
CREATE FUNCTION Account_SMS_Offers(@mobile_num char(11))
RETURNS TABLE
AS
    RETURN( Select CE.*
            From Customer_Exclusive_Offers CE
            Inner Join Customer_Benefits CB
            On CB.benefitID = CE.benefitID
            Where CB.mobileNo = @mobile_num AND CE.SMS_offered > 0 
          );


Go
--Retrieve the number of accepted payments initiated by the input account during 
--the last year along with the total amount of earned points.
CREATE PROCEDURE Account_Payment_Points
@mobile_num char(11)
AS
    Select Count(P.paymentID) AS 'Total Number of Accepted Payments' , ISNULL(SUM(CP.points_offered), 0) AS 'Total Amount of Points'
    From Payment P 
    inner join Customer_Benefits CB
    ON P.paymentID = CB.PaymentID
    Inner Join Customer_Points CP
    On CB.benefitID = CP.benefitID
    Where P.mobileNo = @mobile_num AND P.status = 'successful' 
    AND DATEDIFF(YEAR, P.date_of_payment, CURRENT_TIMESTAMP) <= 1;


Go
--Retrieve the amount of cashback returned on the input wallet based on a certain plan. (all subscriptions not the latest one)
CREATE FUNCTION Wallet_Cashback_Amount
(@walletID int, @planID int)
returns INT
As
BEGIN
    Declare @Amount_of_cashback INT

    Select @Amount_of_cashback = ISNULL(SUM(CH.amount_earned), 0)
    From Customer_Cashback CH
    Inner Join Customer_Benefits CB
    ON CB.benefitID = CH.benefitID
    Inner Join Payment P
    On P.paymentID = CB.PaymentID
    Inner Join Process_Payment PP
    ON PP.paymentID = P.paymentID
    Where PP.planID = @planID AND CB.walletID = @walletID

Return @Amount_of_cashback
END

GO
CREATE VIEW TransactionsHistory AS
    Select t.transfer_id AS 'Transfer ID', t.walletID1 , t.walletID2, t.amount, t.transfer_date
    FROM Transfer_money t

Go
--Retrieve the average of the sent wallet transaction amounts from the input wallet within a certain duration
CREATE FUNCTION Wallet_Average_Sent(@walletID int,@start_date date, @end_date date)
returns Float
AS
BEGIN

    Declare @Transaction_amount_average Float

    Select @Transaction_amount_average = ISNULL(COALESCE(AVG(t.amount),0),0) from transfer_money t
    where t.walletID1 = @walletID 
    AND t.transfer_date BETWEEN @start_date AND @end_date

    Return @Transaction_amount_average
END;

Go
--Retrieve the average of the received wallet transaction amounts by the input wallet within a certain duration
CREATE FUNCTION Wallet_Average_Received(@walletID int,@start_date date, @end_date date)
returns Float
AS
BEGIN

    Declare @Transaction_amount_average Float

    Select @Transaction_amount_average = ISNULL(COALESCE(AVG(t.amount), 0), 0) from transfer_money t
    where t.walletID2 = @walletID 
    AND t.transfer_date BETWEEN @start_date AND @end_date

    Return @Transaction_amount_average
END;

Go
CREATE PROCEDURE Wallet_Transaction_History
@walletID int
AS
    Select *
    From Transfer_money
    Where walletID1 = @walletID OR walletID2 = @walletID
    Order by transfer_date DESC;


GO
--Take mobileNo as an input, return true if this number is linked to a wallet, otherwise return false.
CREATE FUNCTION Wallet_MobileNo
(@mobile_num char(11))
returns VARCHAR(3)
AS
BEGIN

    Declare @result VARCHAR(3)

    if Exists(  Select * 
                From Wallet W 
                Where W.mobileNo = @mobile_num
             )
        set @result = 'Yes'
    else
        set @result = 'No'

return @result
END;


-------------- blue part ------------------


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
          PU.expiry_date <= @end_date
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
RETURN
(
    SELECT P.data_consumption, P.minutes_used, P.SMS_sent
    FROM Subscription S      
    INNER JOIN Plan_Usage P 
    ON S.mobileNo = P.mobileNo AND S.planID = P.planID
    WHERE YEAR(P.start_date) = YEAR(CURRENT_TIMESTAMP) OR YEAR(P.expiry_date) = YEAR(CURRENT_TIMESTAMP)
          AND MONTH(P.start_date) = MONTH(CURRENT_TIMESTAMP) OR MONTH(P.expiry_date) = MONTH(CURRENT_TIMESTAMP)
          AND S.mobileNo = @mobile_num 
          AND S.status = 'active'
);


GO
--Retrieve all cashback transactions related to the wallet of the input customer.
CREATE FUNCTION Cashback_Wallet_Customer(@NID int)
RETURNS TABLE 
AS 
RETURN (
    SELECT CH.* 
    FROM Customer_Cashback CH
    Inner Join Customer_Benefits CB
    ON CB.benefitID = CH.benefitID
    INNER JOIN Wallet W
    ON CB.walletID = W.walletID 
    WHERE W.nationalID = @NID
);



GO
--Retrieve the number of technical support tickets that are NOT Resolved for each account of the input customer.
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
--check whether the customer will subscribe for the first time or renew a certain plan
CREATE FUNCTION subscribe_or_renew_plan(@mobile_num char(11), @plan_id INT)
RETURNS VARCHAR(12) 
AS 
BEGIN
    IF EXISTS(  SELECT * 
                FROM Subscription 
                WHERE mobileNo = @mobile_num AND planID = @plan_id)
        RETURN 'Renew';
    RETURN 'Subscribe';
END;    


GO
--Retrieve the benefits given by this plan
CREATE PROCEDURE Benefits_Plan
    @plan_id INT,
    @points_earned INT OUTPUT,
    @cashback_percentage INT OUTPUT,
    @data_offered INT OUTPUT,
    @minutes_offered INT OUTPUT,
    @SMS_offered INT OUTPUT
AS
BEGIN
    SELECT @points_earned = COALESCE(SUM(PG.amount), 0)
    FROM Plan_Provides_Benefits pp
    INNER JOIN Points_Group PG ON PG.benefitID = pp.benefitID
    WHERE pp.planID = @plan_id;

    SELECT @cashback_percentage = COALESCE(SUM(C.percentage), 0)
    FROM Plan_Provides_Benefits pp
    INNER JOIN Cashback C ON C.benefitID = pp.benefitID
    WHERE pp.planID = @plan_id;

    SELECT 
        @data_offered = COALESCE(SUM(EO.internet_offered), 0),
        @minutes_offered = COALESCE(SUM(EO.minutes_offered), 0),
        @SMS_offered = COALESCE(SUM(EO.SMS_offered), 0)
    FROM Plan_Provides_Benefits pp
    INNER JOIN Exclusive_Offer EO ON EO.benefitID = pp.benefitID
    WHERE pp.planID = @plan_id;
END;



GO
-- Procedure to handle plan renewal or subscription for a customer
CREATE PROCEDURE renew_or_subscribe_plan
    @mobile_num CHAR(11),  -- Input: Customer's mobile number
    @plan_id INT,          -- Input: Plan ID to subscribe/renew
    @message NVARCHAR(100) OUTPUT  -- Output: Message indicating result
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @payment_id INT;      
        DECLARE @price INT;           
        DECLARE @balance INT;         
        DECLARE @amount INT;          
        DECLARE @remaining_balance INT;

        -- Retrieve the price of the selected plan
        SELECT @price = price 
        FROM Service_Plan 
        WHERE planID = @plan_id; 

        -- Retrieve the customer's current balance
        SELECT @balance = balance
        FROM Customer_Account
        WHERE mobileNo = @mobile_num;

        -- Determine the amount to deduct
        IF @balance < @price
            SET @amount = @balance;  
        ELSE
            SET @amount = @price;    

        -- Insert a new payment record
        INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo)
        VALUES (@amount, CURRENT_TIMESTAMP, NULL, 'successful', @mobile_num);

        SET @payment_id = SCOPE_IDENTITY();

        -- Deduct the payment amount from the balance
        UPDATE Customer_Account
        SET balance = balance - @amount
        WHERE mobileNo = @mobile_num;

        -- Link the payment to the plan
        INSERT INTO process_payment (paymentID, planID) 
        VALUES (@payment_id, @plan_id);

        -- Calculate remaining balance for the plan
        SET @remaining_balance = @price - @amount;

        -- Check subscription/renewal action
        DECLARE @action NVARCHAR(10) = dbo.subscribe_or_renew_plan(@mobile_num, @plan_id);

        IF @remaining_balance = 0 
        BEGIN
            IF @action = 'Renew'
                UPDATE Subscription
                SET status = 'active', subscription_date = CURRENT_TIMESTAMP
                WHERE mobileNo = @mobile_num AND planID = @plan_id;
            ELSE
                INSERT INTO Subscription (mobileNo, planID, subscription_date, status)
                VALUES (@mobile_num, @plan_id, CURRENT_TIMESTAMP, 'active');
            
            SET @message = 'Plan ' + @action + ' successful!';
        END
        ELSE
        BEGIN
            IF @action = 'Renew'
                UPDATE Subscription
                SET status = 'onhold', subscription_date = CURRENT_TIMESTAMP
                WHERE mobileNo = @mobile_num AND planID = @plan_id;
            ELSE
                INSERT INTO Subscription (mobileNo, planID, subscription_date, status)
                VALUES (@mobile_num, @plan_id, CURRENT_TIMESTAMP, 'onhold');
            
            SET @message = 'Plan ' + @action + ' successful but on hold due to insufficient balance.';
        END;

        -- Calculate expiry date
        DECLARE @expiry_date DATE;
        DECLARE @expiryIntervalDays INT;

        SELECT @expiryIntervalDays = expiryIntervalDays 
        FROM Service_Plan 
        WHERE planID = @plan_id;

        SET @expiry_date = DATEADD(DAY, @expiryIntervalDays, CURRENT_TIMESTAMP);

        -- Insert Plan_Usage record
        INSERT INTO Plan_Usage (start_date, expiry_date, data_consumption, minutes_used, SMS_sent, mobileNo, planID)
        VALUES (CURRENT_TIMESTAMP, @expiry_date, 0, 0, 0, @mobile_num, @plan_id);

        -- Retrieve wallet ID
        DECLARE @walletID INT;
        SELECT @walletID = walletID
        FROM Wallet 
        WHERE mobileNo = @mobile_num;

        -- Insert Customer_Benefits record
        INSERT INTO Customer_Benefits (mobileNo, PaymentID, walletID, start_date, expiry_date)
        VALUES (@mobile_num, @payment_id, @walletID, CURRENT_TIMESTAMP, @expiry_date);

        DECLARE @benefitID INT = SCOPE_IDENTITY();

        -- Retrieve benefit details
        DECLARE @points_earned INT, @cashback_percentage INT, @data_offered INT, @minutes_offered INT, @SMS_offered INT;

        EXEC Benefits_Plan 
            @plan_id = @plan_id,
            @points_earned = @points_earned OUTPUT,
            @cashback_percentage = @cashback_percentage OUTPUT,
            @data_offered = @data_offered OUTPUT,
            @minutes_offered = @minutes_offered OUTPUT,
            @SMS_offered = @SMS_offered OUTPUT;

        DECLARE @cashback_amount DECIMAL(10,2) = (@cashback_percentage / 100.0) * @amount;

        IF @points_earned > 0
            INSERT INTO Customer_Points (benefitID, points_offered) 
            VALUES (@benefitID, @points_earned);

        IF @cashback_percentage > 0 AND @balance >= @price
            INSERT INTO Customer_Cashback (benefitID, amount_earned) 
            VALUES (@benefitID, @cashback_amount);

        IF @data_offered > 0 OR @minutes_offered > 0 OR @SMS_offered > 0
            INSERT INTO Customer_Exclusive_Offers (benefitID, data_offered, minutes_offered, SMS_offered) 
            VALUES (@benefitID, @data_offered, @minutes_offered, @SMS_offered);

        UPDATE Wallet
        SET current_balance = current_balance + @cashback_amount, last_modified_date = CURRENT_TIMESTAMP
        WHERE walletID = @walletID;

        EXEC Handle_Expired_Points;

        UPDATE Customer_Account
        SET points = points + @points_earned
        WHERE mobileNo = @mobile_num;

        INSERT INTO Benefit_Usage (benefitID, points_used, data_used, minutes_used, SMS_used, usage_date) 
        VALUES (@benefitID, 0, 0, 0, 0, NULL);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @message = ERROR_MESSAGE();
        THROW;
    END CATCH
END;

GO
--Execute a transfer from wallet to wallet
CREATE PROCEDURE Wallet_transfer
@mobile_num1 char(11),
@mobile_num2 char(11),
@amount Decimal(10,2)
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @walletID1 INT;
        DECLARE @walletID2 INT;

        Select @walletID1 = walletID
        From Wallet
        Where mobileNo = @mobile_num1

        Select @walletID2 = walletID
        From Wallet
        Where mobileNo = @mobile_num2

        INSERT INTO Transfer_money (walletID1, walletID2, amount, transfer_date)
        VALUES(@walletID1, @walletID2, @amount, CURRENT_TIMESTAMP);

        UPDATE Wallet
        Set current_balance = current_balance - @amount
        Where walletID = @walletID1;

        UPDATE Wallet
        Set current_balance = current_balance + @amount
        Where walletID = @walletID2;

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
CREATE PROCEDURE Redeem_voucher_points
    @mobile_num CHAR(11),
    @voucher_id INT
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @RequiredPoints INT;
        DECLARE @CurrentPoints INT;
        DECLARE @voucherExpiryDate DATE;
        DECLARE @RedeemDateIfExists DATE;
        DECLARE @PointsBenefitID INT;
        DECLARE @PointsEarned INT;
        DECLARE @PointsUsed INT;
        DECLARE @RemainingPoints INT;
        DECLARE @PointsToDeduct INT;

        EXEC Handle_Expired_Points;

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

        -- Check if the customer has enough points
        IF @CurrentPoints < @RequiredPoints
        BEGIN
            RAISERROR ('Insufficient points to redeem this voucher.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Check if the voucher is expired or already redeemed
        IF @voucherExpiryDate < CURRENT_TIMESTAMP OR @RedeemDateIfExists IS NOT NULL
        BEGIN
            RAISERROR('Voucher is either expired or already redeemed.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Remaining points to deduct
        SET @RemainingPoints = @RequiredPoints;

        -- Retrieve all active points benefits for the customer, ordered by expiry_date (earliest first)
        DECLARE benefit_cursor CURSOR FOR
        SELECT CB.benefitID, CP.points_offered, ISNULL(BU.points_used, 0)
        FROM Customer_Benefits CB
        INNER JOIN Customer_Points CP ON CB.benefitID = CP.benefitID
        LEFT JOIN Benefit_Usage BU ON CB.benefitID = BU.benefitID
        WHERE CB.mobileNo = @mobile_num AND CB.expiry_date >= CURRENT_TIMESTAMP -- Ensure the benefit is active
        ORDER BY CB.expiry_date;

        OPEN benefit_cursor;
        FETCH NEXT FROM benefit_cursor INTO @PointsBenefitID, @PointsEarned, @PointsUsed;

            -- Loop through the benefits and deduct points
            WHILE @@FETCH_STATUS = 0 AND @RemainingPoints > 0
            BEGIN
                -- Calculate the available points in this benefit
                SET @PointsToDeduct = @PointsEarned - @PointsUsed;

                -- If the available points are more than the remaining points, deduct only the remaining points
                IF @PointsToDeduct > @RemainingPoints
                    SET @PointsToDeduct = @RemainingPoints;

                UPDATE Benefit_Usage
                SET points_used = points_used + @PointsToDeduct
                WHERE benefitID = @PointsBenefitID;

                -- Deduct the points from the remaining points
                SET @RemainingPoints = @RemainingPoints - @PointsToDeduct;

                -- Move to the next benefit
                FETCH NEXT FROM benefit_cursor INTO @PointsBenefitID, @PointsEarned, @PointsUsed;
            END

        CLOSE benefit_cursor;
        DEALLOCATE benefit_cursor;

        -- Deduce the points from the account
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

GO
CREATE PROCEDURE Consume_Resources_With_Exclusive_Offers_And_Plans
    @mobile_num CHAR(11),
    @data_consumed INT = 0,  -- Amount of data consumed (in GB)
    @minutes_used INT = 0,   -- Amount of minutes used
    @SMS_sent INT = 0        -- Number of SMS sent
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @ExclusiveOfferID INT;
        DECLARE @DataOffered INT;
        DECLARE @MinutesOffered INT;
        DECLARE @SMSOffered INT;
        DECLARE @RemainingData INT = @data_consumed;
        DECLARE @RemainingMinutes INT = @minutes_used;
        DECLARE @RemainingSMS INT = @SMS_sent;


        -- Retrieve all active exclusive offers for the customer, ordered by expiry_date (earliest first)
        DECLARE exclusive_offer_cursor CURSOR FOR
        SELECT EO.offerID, EO.data_offered, EO.minutes_offered, EO.SMS_offered
        FROM Customer_Exclusive_Offers EO
        INNER JOIN Customer_Benefits CB ON EO.benefitID = CB.benefitID
        WHERE CB.mobileNo = @mobile_num AND CB.expiry_date >= CURRENT_TIMESTAMP -- Ensure the benefit is active
        ORDER BY CB.expiry_date;

        OPEN exclusive_offer_cursor;
        FETCH NEXT FROM exclusive_offer_cursor INTO @ExclusiveOfferID, @DataOffered, @MinutesOffered, @SMSOffered;

            -- Loop through the exclusive offers and consume resources
            WHILE @@FETCH_STATUS = 0 AND (@RemainingData > 0 OR @RemainingMinutes > 0 OR @RemainingSMS > 0)
            BEGIN
                -- Consume data from the exclusive offer
                IF @RemainingData > 0 AND @DataOffered > 0
                BEGIN
                    DECLARE @DataToConsume INT = CASE 
                                                    WHEN @DataOffered >= @RemainingData THEN @RemainingData
                                                    ELSE @DataOffered
                                                 END;

                    SET @RemainingData = @RemainingData - @DataToConsume;
                    SET @DataOffered = @DataOffered - @DataToConsume;

                    UPDATE Benefit_Usage
                    SET data_used = data_used + @DataToConsume, usage_date = CURRENT_TIMESTAMP
                    WHERE benefitID = @ExclusiveOfferID;
                END

                -- Consume minutes from the exclusive offer
                IF @RemainingMinutes > 0 AND @MinutesOffered > 0
                BEGIN
                    DECLARE @MinutesToConsume INT = CASE 
                                                    WHEN @MinutesOffered >= @RemainingMinutes THEN @RemainingMinutes
                                                    ELSE @MinutesOffered
                                                 END;

                    SET @RemainingMinutes = @RemainingMinutes - @MinutesToConsume;
                    SET @MinutesOffered = @MinutesOffered - @MinutesToConsume;

                    UPDATE Benefit_Usage
                    SET minutes_used = minutes_used + @MinutesToConsume
                    WHERE benefitID = @ExclusiveOfferID;
                END

                -- Consume SMS from the exclusive offer
                IF @RemainingSMS > 0 AND @SMSOffered > 0
                BEGIN
                    DECLARE @SMSToConsume INT = CASE 
                                                    WHEN @SMSOffered >= @RemainingSMS THEN @RemainingSMS
                                                    ELSE @SMSOffered
                                                 END;

                    SET @RemainingSMS = @RemainingSMS - @SMSToConsume;
                    SET @SMSOffered = @SMSOffered - @SMSToConsume;

                    UPDATE Benefit_Usage
                    SET SMS_used = SMS_used + @SMSToConsume
                    WHERE benefitID = @ExclusiveOfferID;
                END

                -- Move to the next exclusive offer
                FETCH NEXT FROM exclusive_offer_cursor INTO @ExclusiveOfferID, @DataOffered, @MinutesOffered, @SMSOffered;
            END

        CLOSE exclusive_offer_cursor;
        DEALLOCATE exclusive_offer_cursor;

        -- If there are still remaining resources, consume them from the service plans
        IF @RemainingData > 0 OR @RemainingMinutes > 0 OR @RemainingSMS > 0
        BEGIN
            DECLARE @PlanID INT;
            DECLARE @DataAvailable INT;
            DECLARE @MinutesAvailable INT;
            DECLARE @SMSAvailable INT;

            -- Retrieve all active service plans for the customer, ordered by subscription_date (earliest first)
            DECLARE service_plan_cursor CURSOR FOR

            SELECT S.planID, SP.data_offered, SP.minutes_offered, SP.SMS_offered
            FROM Subscription S
            INNER JOIN Service_Plan SP ON S.planID = SP.planID
            WHERE S.mobileNo = @mobile_num AND S.status = 'active' -- Ensure the plan is active
            ORDER BY S.subscription_date;

            OPEN service_plan_cursor;
            FETCH NEXT FROM service_plan_cursor INTO @PlanID, @DataAvailable, @MinutesAvailable, @SMSAvailable;

                -- Loop through the service plans and consume resources
                WHILE @@FETCH_STATUS = 0 AND (@RemainingData > 0 OR @RemainingMinutes > 0 OR @RemainingSMS > 0)
                BEGIN
                    -- Consume data from the service plan
                    IF @RemainingData > 0 AND @DataAvailable > 0
                    BEGIN
                        DECLARE @PlanDataToConsume INT = CASE 
                                                            WHEN @DataAvailable >= @RemainingData THEN @RemainingData
                                                            ELSE @DataAvailable
                                                         END;

                        SET @RemainingData = @RemainingData - @PlanDataToConsume;
                        SET @DataAvailable = @DataAvailable - @PlanDataToConsume;

                        UPDATE Plan_Usage
                        SET data_consumption = data_consumption + @PlanDataToConsume
                        WHERE planID = @PlanID AND mobileNo = @mobile_num;
                    END

                    -- Consume minutes from the service plan
                    IF @RemainingMinutes > 0 AND @MinutesAvailable > 0
                    BEGIN
                        DECLARE @PlanMinutesToConsume INT = CASE 
                                                            WHEN @MinutesAvailable >= @RemainingMinutes THEN @RemainingMinutes
                                                            ELSE @MinutesAvailable
                                                         END;

                        SET @RemainingMinutes = @RemainingMinutes - @PlanMinutesToConsume;
                        SET @MinutesAvailable = @MinutesAvailable - @PlanMinutesToConsume;

                        UPDATE Plan_Usage
                        SET minutes_used = minutes_used + @PlanMinutesToConsume
                        WHERE planID = @PlanID AND mobileNo = @mobile_num;
                    END

                    -- Consume SMS from the service plan
                    IF @RemainingSMS > 0 AND @SMSAvailable > 0
                    BEGIN
                        DECLARE @PlanSMSToConsume INT = CASE 
                                                            WHEN @SMSAvailable >= @RemainingSMS THEN @RemainingSMS
                                                            ELSE @SMSAvailable
                                                         END;

                        SET @RemainingSMS = @RemainingSMS - @PlanSMSToConsume;
                        SET @SMSAvailable = @SMSAvailable - @PlanSMSToConsume;

                        UPDATE Plan_Usage
                        SET SMS_sent = SMS_sent + @PlanSMSToConsume
                        WHERE planID = @PlanID AND mobileNo = @mobile_num;
                    END

                    -- Move to the next service plan
                    FETCH NEXT FROM service_plan_cursor INTO @PlanID, @DataAvailable, @MinutesAvailable, @SMSAvailable;
                END

            CLOSE service_plan_cursor;
            DEALLOCATE service_plan_cursor;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

Go
CREATE PROCEDURE GetSubscribersForPlan
    @PlanID INT
AS
BEGIN
    SELECT 
        c.nationalID, 
        c.first_name,
        c.last_name, 
        s.mobileNo,
        ca.account_type,
        s.subscription_date,
        s.status AS 'Subscription Status'
    FROM 
        Subscription s
    INNER JOIN 
        Customer_Account ca ON s.mobileNo = ca.mobileNo
    INNER JOIN 
        Customer_profile c ON ca.nationalID = c.nationalID
    WHERE 
        s.planID = @PlanID
    ORDER BY 
        s.subscription_date DESC;
END

GO
CREATE PROCEDURE calculateActiveExpiredBenefitsPercentage
AS
BEGIN
    SELECT status, CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5, 2)) AS Percentage
    FROM Customer_Benefits
    GROUP BY status;
END;

Go
CREATE PROCEDURE calculateBenefitsTypePercentages
AS
BEGIN
    SELECT 
        b.benefitID,
        CAST(COUNT(s.mobileNo) * 100.0 / SUM(COUNT(s.mobileNo)) OVER () AS DECIMAL(5, 2)) AS Percentage
    FROM Subscription s
    INNER JOIN Plan_Provides_Benefits ppb ON s.planID = ppb.planID
    INNER JOIN Benefits b ON ppb.benefitID = b.benefitID
    GROUP BY b.benefitID;
END;

GO
CREATE PROCEDURE GetBenefitsExpiringSoon
AS
BEGIN
    SELECT cb.benefitID, P.first_name, P.last_name, cb.mobileNo, 
        SUM(COALESCE(cpnt.points_offered, 0)) - SUM(COALESCE(bu.points_used, 0)) AS remaining_points,
        SUM(COALESCE(ceo.SMS_offered, 0)) - SUM(COALESCE(bu.SMS_used, 0)) AS remaining_SMS,
        SUM(COALESCE(ceo.data_offered, 0)) - SUM(COALESCE(bu.data_used, 0)) AS remaining_data,
        SUM(COALESCE(ceo.minutes_offered, 0)) - SUM(COALESCE(bu.minutes_used, 0)) AS remaining_minutes, cb.expiry_date
    FROM Customer_Benefits cb
    INNER JOIN Customer_Account A
    ON A.mobileNo = cb.mobileNo
    INNER JOIN Customer_profile P
    ON P.nationalID = A.nationalID
    INNER JOIN Customer_Points cpnt 
    ON cb.benefitID = cpnt.benefitID
    INNER JOIN Customer_Exclusive_Offers ceo 
    ON cb.benefitID = ceo.benefitID
    INNER JOIN Benefit_Usage bu 
    ON cb.benefitID = bu.benefitID
    WHERE cb.status = 'active'
    AND cb.expiry_date BETWEEN GETDATE() AND DATEADD(DAY, 7, GETDATE())
    GROUP BY cb.benefitID, P.first_name, P.last_name, cb.mobileNo, cb.expiry_date;
END;

GO
CREATE PROCEDURE GetCustomersWithNoActiveBenefits
AS
BEGIN
    SELECT A.nationalID, P.first_name, P.last_name, A.mobileNo, A.account_type, A.status
    FROM Customer_Account A
    INNER JOIN Customer_profile P
    ON P.nationalID = A.nationalID
    WHERE NOT EXISTS(
                        SELECT 1
                        FROM Customer_Benefits B
                        WHERE B.status = 'active' AND A.mobileNo = B.mobileNo
                    )
END;

GO
CREATE PROCEDURE GetCustomersWithBenefits
AS
BEGIN
SELECT 
    cp.nationalID,
    cp.first_name,
    cp.last_name,
    ca.mobileNo,
    cb.PaymentID ,
    sp.name AS 'Plan' , 
    SUM(COALESCE(cc.amount_earned, 0)) AS awarded_cashback,
    SUM(COALESCE(cpnt.points_offered, 0)) - SUM(COALESCE(bu.points_used, 0)) AS remaining_points,
    SUM(COALESCE(ceo.SMS_offered, 0)) - SUM(COALESCE(bu.SMS_used, 0)) AS remaining_SMS,
    SUM(COALESCE(ceo.data_offered, 0)) - SUM(COALESCE(bu.data_used, 0)) AS remaining_data,
    SUM(COALESCE(ceo.minutes_offered, 0)) - SUM(COALESCE(bu.minutes_used, 0)) AS remaining_minutes
FROM 
    Customer_profile cp
    INNER JOIN Customer_Account ca 
    ON cp.nationalID = ca.nationalID
    INNER JOIN Customer_Benefits cb 
    ON ca.mobileNo = cb.mobileNo
    INNER JOIN Customer_Cashback cc 
    ON cb.benefitID = cc.benefitID
    INNER JOIN Customer_Points cpnt 
    ON cb.benefitID = cpnt.benefitID
    INNER JOIN Customer_Exclusive_Offers ceo 
    ON cb.benefitID = ceo.benefitID
    INNER JOIN Benefit_Usage bu 
    ON cb.benefitID = bu.benefitID
    INNER JOIN Process_Payment pp
    ON pp.paymentID = cb.PaymentID
    INNER JOIN Service_Plan sp
    ON pp.planID = sp.planID
    WHERE cb.status = 'active'
    GROUP BY cp.nationalID, cp.first_name, cp.last_name, ca.mobileNo, cb.PaymentID, sp.name;
END;

GO
CREATE PROCEDURE GetSubscriptionStatistics
AS
BEGIN
    SELECT 
        SP.name AS PlanName, 
        COUNT(S.planID) AS SubscriptionCount
    FROM 
        Service_Plan SP
    LEFT JOIN 
        Subscription S ON SP.planID = S.planID
    GROUP BY 
        SP.name;
END

GO
CREATE PROCEDURE GetSubscriptions(
    @FilterDate DATE,
    @SubscriptionStatus VARCHAR(50),
    @SelectedPlan INT
)
AS
BEGIN
   IF @SubscriptionStatus = 'All'
    BEGIN
        SELECT 
            C.nationalID,
            C.first_name,
            C.last_name,
            C.email,
            C.address,
            C.date_of_birth,
            CA.mobileNo,
            CA.account_type,
            CA.start_date,
            CA.status,
            CA.balance,
            SP.planID,
            SP.name AS PlanName,
            S.subscription_date,
            S.status AS SubscriptionStatus
        FROM Customer_Profile C
        INNER JOIN Customer_Account CA ON C.nationalID = CA.nationalID
        INNER JOIN Subscription S ON CA.mobileNo = S.mobileNo
        INNER JOIN Service_Plan SP ON S.planID = SP.planID
        WHERE S.subscription_date >= @FilterDate
          AND (SP.planID = @SelectedPlan);
    END
    ELSE
    BEGIN
        SELECT 
            C.nationalID,
            C.first_name,
            C.last_name,
            C.email,
            C.address,
            C.date_of_birth,
            CA.mobileNo,
            CA.account_type,
            CA.start_date,
            CA.status,
            CA.balance,
            SP.planID,
            SP.name AS PlanName,
            S.subscription_date,
            S.status AS SubscriptionStatus
        FROM Customer_Profile C
        INNER JOIN Customer_Account CA ON C.nationalID = CA.nationalID
        INNER JOIN Subscription S ON CA.mobileNo = S.mobileNo
        INNER JOIN Service_Plan SP ON S.planID = SP.planID
        WHERE S.subscription_date >= @FilterDate
          AND S.status = @SubscriptionStatus
          AND (SP.planID = @SelectedPlan);
    END
END;


GO
CREATE VIEW TotalCashback As
    SELECT SUM(CH.amount_earned) AS TotalCashbackDistributed
    FROM Customer_Cashback CH
    INNER JOIN Customer_Benefits CB 
    ON CH.benefitID = CB.benefitID;

GO 
CREATE VIEW TotalPayments As
    SELECT
    SUM(p.amount) AS TotalPayments
    FROM Payment p;

GO
CREATE PROCEDURE CashbackHistory
AS
BEGIN
    SELECT CH.CashbackID, CP.first_name, CP.last_name, CB.mobileNo, CB.start_date AS 'Cashback Received Date',  CH.amount_earned
    FROM Customer_Cashback CH
    INNER JOIN Customer_Benefits CB ON CH.benefitID = CB.benefitID
    INNER JOIN Customer_Account CA ON CA.mobileNo = CB.mobileNo
    INNER JOIN Customer_profile CP ON CA.nationalID = CP.nationalID
    ORDER BY CB.start_date DESC; 
END;

GO
CREATE PROCEDURE TopCustomersByCashback
AS
BEGIN
    SELECT TOP 5 CP.first_name, CP.last_name, SUM(CH.amount_earned) AS 'Total Cashback Earned'
    FROM Customer_Cashback CH
    INNER JOIN Customer_Benefits CB ON CH.benefitID = CB.benefitID
    INNER JOIN Customer_Account CA ON CA.mobileNo = CB.mobileNo
    INNER JOIN Customer_profile CP ON CA.nationalID = CP.nationalID
    GROUP BY CP.first_name, CP.last_name, CB.mobileNo
    ORDER BY SUM(CH.amount_earned) DESC;
END;

GO
CREATE PROCEDURE calculatePlanCashbackPercentage
AS
BEGIN
    SELECT sp.name AS PlanName, CAST(SUM(CH.amount_earned) * 100.0 / SUM(SUM(CH.amount_earned)) OVER () AS DECIMAL(5, 2)) AS Percentage
    FROM Customer_Cashback CH
    INNER JOIN Customer_Benefits CB ON CH.benefitID = CB.benefitID
    INNER JOIN Process_Payment pp ON CB.PaymentID = pp.paymentID
    INNER JOIN Service_Plan sp ON sp.planID = pp.planID
    GROUP BY sp.name;
END;



GO 
CREATE VIEW TotalPoints As
    SELECT SUM(COALESCE(pg.amount, 0)) AS 'Total Points'
    FROM Customer_Benefits cb
    INNER JOIN Process_Payment pp
    ON pp.paymentID = cb.PaymentID
    INNER JOIN Plan_Provides_Benefits pb
    ON pp.planID = pb.planID
    INNER JOIN Benefits b
    ON b.benefitID = pb.benefitID
    INNER JOIN Points_Group pg
    ON pg.benefitID = b.benefitID;
    
GO
CREATE PROCEDURE ActivePoints
AS
BEGIN
    EXEC Handle_Expired_Points;

    SELECT SUM(COALESCE(points, 0)) AS 'Active Points'
    FROM Customer_Account;
END;

GO 
CREATE VIEW UsedPoints As   
    SELECT SUM(COALESCE(points_used, 0)) AS 'Used Points'
    FROM Benefit_Usage;

GO
CREATE VIEW ExpiredPoints AS
SELECT 
    (TP.[Total Points] - (UP.[Used Points] + AP.[Active Points])) AS 'Expired Points'
FROM 
    TotalPoints TP,
    UsedPoints UP,
    (SELECT SUM(COALESCE(points, 0)) AS 'Active Points' FROM Customer_Account) AP;

GO
CREATE PROCEDURE PointsHistory
AS
BEGIN
    SELECT P.pointID, CP.first_name, CP.last_name, CB.mobileNo, CB.start_date AS 'Credit Date',  P.points_offered
    FROM Customer_Points P
    INNER JOIN Customer_Benefits CB ON P.benefitID = CB.benefitID
    INNER JOIN Customer_Account CA ON CA.mobileNo = CB.mobileNo
    INNER JOIN Customer_profile CP ON CA.nationalID = CP.nationalID
    ORDER BY CB.start_date DESC; 
END;

GO
CREATE PROCEDURE calculatePlanPointsPercentage
AS
BEGIN
    SELECT sp.name AS PlanName, CAST(SUM(CP.points_offered) * 100.0 / SUM(SUM(CP.points_offered)) OVER () AS DECIMAL(5, 2)) AS Percentage
    FROM Customer_Points CP
    INNER JOIN Customer_Benefits CB ON CP.benefitID = CB.benefitID
    INNER JOIN Process_Payment pp ON CB.PaymentID = pp.paymentID
    INNER JOIN Service_Plan sp ON sp.planID = pp.planID
    GROUP BY sp.name;
END;

GO
CREATE PROCEDURE TopCustomersByUsedPoints
AS
BEGIN
    SELECT TOP 5 CP.first_name, CP.last_name, SUM(P.points_offered) AS 'Total Points Earned'
    FROM Customer_Points P
    INNER JOIN Customer_Benefits CB ON P.benefitID = CB.benefitID
    INNER JOIN Customer_Account CA ON CA.mobileNo = CB.mobileNo
    INNER JOIN Customer_profile CP ON CA.nationalID = CP.nationalID
    GROUP BY CP.first_name, CP.last_name, CB.mobileNo
    ORDER BY SUM(P.points_offered) DESC;
END;




GO 
CREATE VIEW TotalExclusiveOffers As
    SELECT COUNT(*) AS 'Total Offers'
    FROM Customer_Exclusive_Offers CE;

GO 
CREATE VIEW ActiveExclusiveOffers As
    SELECT COUNT(*) AS 'Active Offers'
    FROM Customer_Exclusive_Offers CE
    INNER JOIN Customer_Benefits CB
    ON CB.benefitID = CE.benefitID
    WHERE CB.status = 'active';

GO 
CREATE VIEW ExpiredExclusiveOffers As
    SELECT COUNT(*) AS 'Expired Offers'
    FROM Customer_Exclusive_Offers CE
    INNER JOIN Customer_Benefits CB
    ON CB.benefitID = CE.benefitID
    WHERE CB.status = 'expired';

GO
CREATE PROCEDURE ExclusiveOffersHistory
AS
BEGIN
    SELECT CE.offerID, CP.first_name, CP.last_name, CB.mobileNo, CB.start_date AS 'Start Date', CE.SMS_offered, CE.minutes_offered, CE.data_offered, CB.status
    FROM Customer_Exclusive_Offers CE
    INNER JOIN Customer_Benefits CB ON CE.benefitID = CB.benefitID
    INNER JOIN Customer_Account CA ON CA.mobileNo = CB.mobileNo
    INNER JOIN Customer_profile CP ON CA.nationalID = CP.nationalID
    ORDER BY CB.start_date DESC; 
END;

GO
CREATE PROCEDURE CustomersOfferNotUsed
AS
BEGIN
    SELECT CE.offerID, CP.first_name, CP.last_name, CB.mobileNo, CB.start_date AS 'Start Date',  CE.SMS_offered, CE.minutes_offered, CE.data_offered, CB.status
    FROM Customer_Exclusive_Offers CE
    INNER JOIN Customer_Benefits CB ON CE.benefitID = CB.benefitID
    INNER JOIN Customer_Account CA ON CA.mobileNo = CB.mobileNo
    INNER JOIN Customer_profile CP ON CA.nationalID = CP.nationalID
    INNER JOIN Benefit_Usage bu ON bu.benefitID = CE.benefitID
    WHERE bu.SMS_used = 0 and bu.minutes_used = 0 and bu.data_used = 0
    ORDER BY CB.start_date DESC; 
END;

GO
CREATE PROCEDURE calculatePlanOffersPercentage
AS
BEGIN
    SELECT sp.name AS PlanName, CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5, 2)) AS Percentage
    FROM Customer_Exclusive_Offers CE
    INNER JOIN Customer_Benefits CB ON CE.benefitID = CB.benefitID
    INNER JOIN Process_Payment pp ON CB.PaymentID = pp.paymentID
    INNER JOIN Service_Plan sp ON sp.planID = pp.planID
    GROUP BY sp.name;
END;

GO
CREATE PROCEDURE TopCustomersByOfferedSMS
AS
BEGIN
    SELECT TOP 5 CP.first_name, CP.last_name, SUM(CE.SMS_offered) AS 'Total SMS Earned'
    FROM Customer_Exclusive_Offers CE
    INNER JOIN Customer_Benefits CB ON CE.benefitID = CB.benefitID
    INNER JOIN Customer_Account CA ON CA.mobileNo = CB.mobileNo
    INNER JOIN Customer_profile CP ON CA.nationalID = CP.nationalID
    GROUP BY CP.first_name, CP.last_name, CB.mobileNo
    ORDER BY SUM(CE.SMS_offered) DESC;
END;

GO
CREATE PROCEDURE TopCustomersByOfferedMinutes
AS
BEGIN
    SELECT TOP 5 CP.first_name, CP.last_name, SUM(CE.minutes_offered) AS 'Total Minutes Earned'
    FROM Customer_Exclusive_Offers CE
    INNER JOIN Customer_Benefits CB ON CE.benefitID = CB.benefitID
    INNER JOIN Customer_Account CA ON CA.mobileNo = CB.mobileNo
    INNER JOIN Customer_profile CP ON CA.nationalID = CP.nationalID
    GROUP BY CP.first_name, CP.last_name, CB.mobileNo
    ORDER BY SUM(CE.minutes_offered) DESC;
END;

GO
CREATE PROCEDURE TopCustomersByOfferedInternet
AS
BEGIN
    SELECT TOP 5 CP.first_name, CP.last_name, SUM(CE.data_offered) AS 'Total Internet Earned'
    FROM Customer_Exclusive_Offers CE
    INNER JOIN Customer_Benefits CB ON CE.benefitID = CB.benefitID
    INNER JOIN Customer_Account CA ON CA.mobileNo = CB.mobileNo
    INNER JOIN Customer_profile CP ON CA.nationalID = CP.nationalID
    GROUP BY CP.first_name, CP.last_name, CB.mobileNo
    ORDER BY SUM(CE.data_offered) DESC;
END;

GO
CREATE PROCEDURE LoadSubscribedPlans
@mobileNo CHAR(11)
AS
BEGIN
SELECT sp.planID, sp.name, sp.SMS_offered, sp.minutes_offered, sp.data_offered, pu.SMS_sent, pu.minutes_used, pu.data_consumption
                    FROM Subscription s
                    JOIN Service_Plan sp ON s.planID = sp.planID
                    LEFT JOIN Plan_Usage pu ON s.planID = pu.planID AND s.mobileNo = pu.mobileNo
                    WHERE s.mobileNo = @mobileNo AND s.status <> 'expired';
END;


GO
CREATE PROCEDURE LoadPlanBenefits
@planID INT,
@mobile_num CHAR(11)
AS
BEGIN
SELECT ce.SMS_offered, ce.data_offered, ce.minutes_offered,cp.points_offered, bu.SMS_used, bu.data_used, bu.minutes_used, bu.points_used
                    FROM Customer_Benefits cb
                    INNER JOIN Customer_Points cp ON cp.benefitID = cb.benefitID
                    INNER JOIN Customer_Exclusive_Offers ce ON ce.benefitID = cb.benefitID
                    INNER JOIN Benefit_Usage bu ON bu.benefitID = cb.benefitID
                    INNER JOIN Process_Payment p ON p.paymentID = cb.PaymentID
                    WHERE cb.mobileNo = @mobile_num AND p.planID = @planID;
END;


GO
CREATE PROCEDURE InitializeSystem
AS
BEGIN
    INSERT INTO Service_Plan (SMS_offered, minutes_offered, data_offered, name, price, description, expiryIntervalDays)
    VALUES
    (100, 200, 1024, 'Basic Plan', 50, 'Affordable plan for light users', 30),
    (500, 1000, 5120, 'Standard Plan', 100, 'Ideal for moderate users', 30),
    (1000, 2000, 10240, 'Premium Plan', 200, 'Best for heavy users', 30),
    (9999, 9999, 99999, 'Unlimited Plan', 300, 'Unlimited calls, SMS, and data', 30);

    INSERT INTO Benefits (description, expiryIntervalDays)
    VALUES
    ('Extra 1GB data per month', 30),
    ('Free 100 SMS per month', 30),
    ('Extra 100 minutes per month', 30),
    ('10% cashback on plan renewal', 30),
    ('20% cashback on plan renewal', 30),
    ('Earn 50 loyalty points per month', 30);

    INSERT INTO Points_Group (benefitID, amount)
    VALUES
    (6, 50); -- Loyalty 50 Points

    INSERT INTO Exclusive_Offer (benefitID, internet_offered, SMS_offered, minutes_offered)
    VALUES
    (1, 1024, 0, 0), -- 1GB internet
    (2, 0, 100, 0), -- 100 SMS
    (3, 0, 0, 100); -- 100 minutes

    INSERT INTO Cashback (benefitID, percentage)
    VALUES
    (4, 10), -- 10% cashback
    (5, 20); -- 20% cashback

    INSERT INTO Plan_Provides_Benefits (planID, benefitID)
    VALUES
    (1, 2), -- Free 100 SMS Bundle
    (1, 6), -- Loyalty 50 Points
    (1, 4), -- 5% Cashback on Plan Renewal

    (2, 1), -- Extra 1GB internet
    (2, 3), -- Bonus 100 Minutes
    (2, 6), -- Loyalty 50 Points
    (2, 4), -- 10% Cashback on Plan Renewal

    (3, 1), -- Extra 1GB internet
    (3, 3), -- Bonus 100 Minutes
    (3, 6), -- Loyalty 50 Points
    (3, 5), -- 20% Cashback on Plan Renewal

    (4, 1), -- Extra 1GB internet
    (4, 2), -- Free 100 SMS Bundle
    (4, 3), -- Bonus 100 Minutes
    (4, 5), -- 20% Cashback on Plan Renewal
    (4, 6); -- Loyalty 50 Points

    INSERT INTO Shop (name, category)
    VALUES
    ('Amazon', 'Electronics'),
    ('Zara', 'Clothing'),
    ('Whole Foods', 'Groceries'),
    ('IKEA', 'Furniture'),
    ('Barnes & Noble', 'Books'),
    ('Decathlon', 'Sports'),
    ('Toys R Us', 'Toys'),
    ('AutoZone', 'Automotive'),
    ('Pandora', 'Jewelry'),
    ('Sephora', 'Beauty'),
    ('Best Buy', 'Home Appliances'),
    ('Ashley Furniture', 'Furniture'),
    ('Apple Store', 'Electronics'),
    ('H&M', 'Clothing'),
    ('Kroger', 'Groceries');

    INSERT INTO Physical_Shop (shopID, address, working_hours)
    VALUES
    (2, '123 Main St', '9 AM - 9 PM'),
    (3, '456 Oak St', '8 AM - 10 PM'),  
    (4, '789 Pine St', '10 AM - 6 PM'),
    (5, '101 Maple St', '9 AM - 9 PM'), 
    (6, '202 Birch St', '9 AM - 5 PM'), 
    (7, '303 Cedar St', '10 AM - 8 PM'), 
    (8, '404 Elm St', '11 AM - 7 PM'),  
    (9, '505 Redwood St', '9 AM - 9 PM'), 
    (12, '606 Willow St', '10 AM - 7 PM'), 
    (13, '707 Ash St', '8 AM - 6 PM');  

    INSERT INTO E_SHOP (shopID, URL, rating)
    VALUES
    (1, 'https://www.amazon.com', 5),
    (3, 'https://www.wholefoods.com', 4), 
    (4, 'https://www.ikea.com', 5),
    (5, 'https://www.barnesandnoble.com', 4), 
    (10, 'https://www.sephora.com', 4),
    (11, 'https://www.bestbuy.com', 5), 
    (13, 'https://www.apple.com', 5), 
    (14, 'https://www.hm.com', 4), 
    (15, 'https://www.kroger.com', 4);
END;

GO
EXEC InitializeSystem

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
('01030303030', 'mypassword', 0.0, 'Pay as you go', '2023-07-15', 'onhold', 0, 103),
('01040404040', 'bobpass', 250.0, 'Post Paid', '2023-08-01', 'active', 20, 104),
('01050505050', 'charliepass', 100.5, 'Prepaid', '2023-09-01', 'active', 15, 105),
('01060606060', 'evepass', 500.0, 'Post Paid', '2023-10-01', 'onhold', 30, 106),
('01070707070', 'frankpass', 200.0, 'Prepaid', '2023-11-01', 'active', 25, 107),
('01080808080', 'gracepass', 50.0, 'Pay as you go', '2023-12-01', 'active', 8, 108),
('01090909090', 'hankpass', 150.0, 'Post Paid', '2023-01-15', 'active', 12, 109),
('01101010101', 'ivypass', 400.0, 'Prepaid', '2023-02-01', 'active', 18, 110),
('01111111111', 'jackpass', 300.0, 'Post Paid', '2023-03-01', 'active', 22, 111),
('01121212121', 'kathy123', 150.0, 'Pay as you go', '2023-04-01', 'active', 9, 112),
('01131313131', 'liampass', 200.0, 'Post Paid', '2023-05-01', 'onhold', 10, 113),
('01141414141', 'monapass', 100.0, 'Prepaid', '2023-06-01', 'active', 5, 114),
('01151515151', 'ninapass', 0.0, 'Pay as you go', '2023-07-01', 'onhold', 0, 115),
('01161616161', 'oscarpass', 600.0, 'Post Paid', '2023-08-01', 'active', 40, 116),
('01171717171', 'paulpass', 350.0, 'Prepaid', '2023-09-01', 'active', 35, 117),
('01181818181', 'quincy123', 120.0, 'Post Paid', '2023-10-01', 'active', 18, 118);

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

INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo)
VALUES
-- Customer 1 (Basic Plan)
(50.0, '2023-10-01', 'credit', 'successful', '01010101010'),
-- Customer 2 (Standard Plan)
(100.0, '2023-10-01', 'credit', 'successful', '01020202020'),
-- Customer 3 (Premium Plan)
(200.0, '2023-10-01', 'credit', 'successful', '01030303030'),
-- Customer 4 (Unlimited Plan)
(300.0, '2023-10-01', 'credit', 'successful', '01040404040');

INSERT INTO Process_Payment (paymentID, planID)
VALUES
-- Customer 1 (Basic Plan)
(1, 1),
-- Customer 2 (Standard Plan)
(2, 2),
-- Customer 3 (Premium Plan)
(3, 3),
-- Customer 4 (Unlimited Plan)
(4, 4);

INSERT INTO Subscription (mobileNo, planID, subscription_date, status)
VALUES
-- Customer 1 (Basic Plan)
('01010101010', 1, '2023-10-01', 'active'),
-- Customer 2 (Standard Plan)
('01020202020', 2, '2023-10-01', 'active'),
-- Customer 3 (Premium Plan)
('01030303030', 3, '2023-10-01', 'active'),
-- Customer 4 (Unlimited Plan)
('01040404040', 4, '2023-10-01', 'active');

INSERT INTO Plan_Usage (start_date, expiry_date, data_consumption, minutes_used, SMS_sent, mobileNo, planID)
VALUES
-- Customer 1 (Basic Plan)
('2023-10-01', '2023-11-01', 500, 100, 50, '01010101010', 1),
-- Customer 2 (Standard Plan)
('2023-10-01', '2023-11-01', 2000, 500, 200, '01020202020', 2),
-- Customer 3 (Premium Plan)
('2023-10-01', '2023-11-01', 5000, 1000, 500, '01030303030', 3),
-- Customer 4 (Unlimited Plan)
('2023-10-01', '2023-11-01', 10000, 2000, 1000, '01040404040', 4);

INSERT INTO Customer_Benefits (mobileNo, PaymentID, walletID, start_date, expiry_date)
VALUES
-- Customer 1 (Basic Plan)
('01010101010', 1, 1, '2025-01-01', '2025-04-01'),
-- Customer 2 (Standard Plan)
('01020202020', 2, 2, '2025-01-01', '2025-04-01'),
-- Customer 3 (Premium Plan)
('01030303030', 3, 3, '2025-01-01', '2025-04-01'),
-- Customer 4 (Unlimited Plan)
('01040404040', 4, 4, '2025-01-01', '2025-04-01');

INSERT INTO Customer_Points (benefitID, points_offered)
VALUES
-- Customer 1 (Basic Plan)
(1, 50), 
-- Customer 2 (Standard Plan)
(2, 50), 
-- Customer 3 (Premium Plan)
(3, 50), 
-- Customer 4 (Unlimited Plan)
(4, 50);

INSERT INTO Customer_Cashback (benefitID, amount_earned)
VALUES
-- Customer 1 (Basic Plan)
(1, 5.0),
-- Customer 2 (Standard Plan)
(2, 10.0),
-- Customer 3 (Premium Plan)
(3, 40.0),
-- Customer 4 (Unlimited Plan)
(4, 60.0);

INSERT INTO Customer_Exclusive_Offers (benefitID, data_offered, minutes_offered, SMS_offered)
VALUES
-- Customer 1 (Basic Plan)
(1, 0, 0, 100), -- Free 100 SMS Bundle
-- Customer 2 (Standard Plan)
(2, 1024, 100, 0), -- Bonus 100 Minutes + Extra 1GB internet
-- Customer 3 (Premium Plan)
(3, 1024, 100, 0), -- Bonus 100 Minutes + Extra 1GB internet
-- Customer 4 (Unlimited Plan)
(4, 1024, 100, 0); -- Free 100 SMS Bundle + Bonus 100 Minutes + Extra 1GB internet

INSERT INTO Benefit_Usage (benefitID, points_used, data_used, minutes_used, SMS_used, usage_date)
VALUES
-- Customer 1 (Basic Plan)
(1, 10, 0, 0, 20, '2023-10-15'), 
-- Customer 2 (Standard Plan)
(2, 25, 420, 30, 0, '2023-10-15'), 
-- Customer 3 (Premium Plan)
(3, 30, 310, 15, 0, '2023-10-15'),
-- Customer 4 (Unlimited Plan)
(4, 60, 250, 25, 30, '2023-10-15');


INSERT INTO Voucher (value, expiry_date, points, mobileNo, shopID, redeem_date)
VALUES
(50, '2025-05-02', 100, '01010101010', 1, NULL),
(100, '2023-06-01', 200, '01010101010', 2, NULL),
(150, '2025-07-03', 300, '01010101010', 3, NULL),
(200, '2023-08-01', 400, '01040404040', 4, NULL),
(250, '2023-09-01', 500, '01050505050', 5, NULL),
(300, '2023-10-01', 600, '01060606060', 6, NULL),
(350, '2023-11-01', 700, '01070707070', 7, NULL),
(400, '2023-12-01', 800, '01080808080', 8, NULL),
(450, '2024-01-01', 900, '01090909090', 9, NULL),
(500, '2024-02-01', 1000, '01101010101', 10, NULL),
(550, '2024-03-01', 1100, '01111111111', 11, NULL),
(600, '2024-04-01', 1200, '01121212121', 12, NULL),
(650, '2024-05-01', 1300, '01131313131', 13, NULL),
(700, '2024-06-01', 1400, '01141414141', 14, NULL),
(750, '2024-07-01', 1500, '01151515151', 15, NULL);

INSERT INTO Technical_Support_Ticket (mobileNo, Issue_description, priority_level, status)
VALUES
('01010101010', 'Network connectivity issue', 3, 'Open'),
('01020202020', 'Account billing discrepancy', 2, 'Open'),
('01030303030', 'Unable to make outgoing calls', 1, 'Resolved'),
('01040404040', 'Data not working', 2, 'Resolved'),
('01050505050', 'Overcharged for last month', 2, 'In Progress'),
('01060606060', 'SIM card not activated', 1, 'In Progress'),
('01070707070', 'Unable to top-up account', 3, 'Open'),
('01080808080', 'Account suspended error', 2, 'Resolved'),
('01090909090', 'Payment not reflected in balance', 3, 'Open'),
('01101010101', 'Unable to use data services', 1, 'Open'),
('01111111111', 'No signal in the area', 2, 'Resolved'),
('01121212121', 'Balance not updating after recharge', 3, 'In Progress'),
('01131313131', 'System outage', 1, 'Resolved'),
('01141414141', 'Wrong plan applied', 2, 'Open'),
('01151515151', 'Service interruption', 3, 'Resolved'),
('01161616161', 'Account frozen due to suspicious activity', 1, 'In Progress'),
('01171717171', 'Mobile number transfer issue', 2, 'In Progress'),
('01181818181', 'No internet access', 1, 'In Progress');

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
SELECT * FROM Customer_Benefits;
SELECT * FROM Customer_Points
SELECT * FROM Customer_Cashback
SELECT * FROM Customer_Exclusive_Offers
SELECT * FROM Points_Group;
SELECT * FROM Exclusive_Offer;
SELECT * FROM Cashback;
SELECT * FROM Benefit_Usage;
SELECT * FROM Plan_Provides_Benefits;
SELECT * FROM Shop;
SELECT * FROM Physical_Shop;
SELECT * FROM E_SHOP;
SELECT * FROM Voucher;
SELECT * FROM Technical_Support_Ticket;

-- Tested Successfully:

---- recharge balance
--EXEC Initiate_balance_payment @mobile_num = '01010101010', @amount = 50.0, @payment_method = 'credit';
---- redeem voucher
--EXEC Redeem_voucher_points @mobile_num = '01010101010', @voucher_id = 2;
---- wallet transfer money
--EXEC Wallet_transfer @mobile_num1 = '01010101010', @mobile_num2 = '01050505050', @amount = 100.00;
---- subscribe/renew the plan
--EXEC renew_or_subscribe_plan @mobile_num = '01010101010', @plan_id = 3;
---- consume resources
--EXEC Consume_Resources_With_Exclusive_Offers_And_Plans 
--    @mobile_num = '01010101010', 
--    @data_consumed = 500,  -- 500MB data consumed
--    @minutes_used = 50,    -- 50 minutes used
--    @SMS_sent = 0;        -- 0 SMS sent
---- delete benefits for a specific user & plan
--EXEC Benefits_Account @mobile_num = '01010101010', @plan_id = 3;
---- Delete Expired points and remove the rest from the customer's points if exists
--EXEC Handle_Expired_Points;


