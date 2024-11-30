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
        point INT DEFAULT 0,
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
CREATE VIEW allCustomerAccounts AS 
SELECT 
    p.nationalID AS customerNationalID,
    p.first_name,
    p.last_name,
    p.email,
    p.address,
    p.date_of_birth,
    a.mobileNo,
    a.pass,
    a.balance,
    a.account_type,
    a.start_date,
    a.status,
    a.point
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
SELECT 
    p.paymentID,
    p.amount,
    p.date_of_payment,
    p.payment_method,
    p.status AS payment_status,
    p.mobileNo AS paymentMobileNo,
    a.mobileNo AS accountMobileNo,
    a.pass,
    a.balance,
    a.account_type,
    a.start_date,
    a.status AS account_status,
    a.point,
    a.nationalID
FROM Payment p
INNER JOIN Customer_Account a 
ON p.mobileNo = a.mobileNo;

GO


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
Select C.* , S.*
From Customer_Account C 
Inner join Subscription S 
ON C.mobileNo = S.mobileNo 
Inner join Service_Plan Sp 
ON S.planID = Sp.planID;



-------------- Green part ------------------



Go
--Retrieve the list of accounts subscribed to the input plan on a certain date
CREATE FUNCTION Account_Plan_date(@Subscription_Date date,@Plan_id int)
RETURNS TABLE
AS
RETURN(
    Select S.mobileNo AS Account_Mobile_Number, SP.planID AS Service_Plan_ID, SP.name AS Service_Plan_Name
    From Subscription S 
    inner join Service_Plan SP 
    ON S.planID = SP.planID
    Where S.subscription_date = @Subscription_Date AND S.planID = @Plan_id
);


Go
--Retrieve the total usage of the input account on each subscribed plan from a given input date.
CREATE FUNCTION Account_Usage_Plan(@MobileNo char(11), @from_date date)
RETURNS TABLE
AS
    RETURN( 
        Select U.planID, SUM(U.data_consumption) AS 'total data', SUM(U.minutes_used) AS 'total mins', SUM(U.SMS_sent) AS 'total SMS'
        From Plan_Usage U 
        Where U.mobileNo = @MobileNo AND U.start_date >= @from_date
        Group By U.planID
    );


Go
--Delete all benefits offered to the input account for a certain plan
CREATE PROCEDURE DeleteBenefits_Account
    @MobileNo char(11),
    @plan_ID int
AS
BEGIN
    BEGIN TRANSACTION;

    -- Delete from PointsGroup
    DELETE PG
    FROM PointsGroup PG
    INNER JOIN Benefits B ON PG.benefitID = B.benefitID
    INNER JOIN Plan_Provides_Benefits PPB ON B.benefitID = PPB.benefitID
    WHERE B.mobileNo = @MobileNo AND PPB.planID = @plan_ID;

    -- Delete from ExclusiveOffer
    DELETE EO
    FROM ExclusiveOffer EO
    INNER JOIN Benefits B ON EO.benefitID = B.benefitID
    INNER JOIN Plan_Provides_Benefits PPB ON B.benefitID = PPB.benefitID
    WHERE B.mobileNo = @MobileNo AND PPB.planID = @plan_ID;

    -- Delete from Cashback
    DELETE CB
    FROM Cashback CB
    INNER JOIN Benefits B ON CB.benefitID = B.benefitID
    INNER JOIN Plan_Provides_Benefits PPB ON B.benefitID = PPB.benefitID
    WHERE B.mobileNo = @MobileNo AND PPB.planID = @plan_ID;

    -- Delete from Plan_Provides_Benefits
    DELETE PPB
    FROM Plan_Provides_Benefits PPB
    INNER JOIN Benefits B ON PPB.benefitID = B.benefitID
    WHERE B.mobileNo = @MobileNo AND PPB.planID = @plan_ID;

    -- Delete from Benefits
    DELETE B
    FROM Benefits B
    INNER JOIN Plan_Provides_Benefits PPB ON B.benefitID = PPB.benefitID
    WHERE B.mobileNo = @MobileNo AND PPB.planID = @plan_ID;


    -- OR update mobile number to Null

    --UPDATE Benefits
    --SET mobileNo = NULL
    --FROM Benefits B INNER JOIN plan_provides_benefits pb
    --ON B.benefitID = pb.benefitid 
    --WHERE B.mobileNo = @mobile_num AND pb.planID = @plan_id

    COMMIT TRANSACTION;
END;



GO
--Retrieve the list of gained offers of type �SMS� for the input account
CREATE FUNCTION Account_SMS_Offers(@MobileNo char(11))
RETURNS TABLE
AS
    RETURN( Select O.*
            From Exclusive_Offer O 
            Inner join Benefits B 
            ON B.benefitID = O.benefitID
            Where B.mobileNo = @MobileNo AND O.SMS_offered > 0 
          );


Go
--Retrieve the number of accepted payment transactions initiated by the input account during 
--the last year along with the total amount of earned points.
CREATE PROCEDURE Account_Payment_Points
@MobileNo char(11),
@total_transactions INT OUTPUT,
@total_points INT OUTPUT
AS
    Select @total_transactions = Count(P.paymentID), @total_points = SUM(PG.pointsAmount)
    From Payment P 
    inner join Points_Group PG 
    ON P.paymentID = PG.PaymentID
    Where P.mobileNo = @MobileNo AND P.status = 'successful' 
    AND DATEDIFF(YEAR, P.date_of_payment, CURRENT_TIMESTAMP) <= 1;


Go
--Retrieve the amount of cashback returned on the input wallet based on a certain plan.
CREATE FUNCTION Wallet_Cashback_Amount
(@WalletId int, @planId int)
returns INT
As
BEGIN
    Declare @Amount_of_cashback INT

    Select @Amount_of_cashback = SUM(C.amount)
    From Cashback C 
    inner join Plan_Provides_Benefits PPB 
    ON C.benefitID = PPB.benefitID
    Where C.walletID = @WalletId AND PPB.planID = @planId

Return @Amount_of_cashback
END


Go
--Retrieve the average of the sent transaction amounts from the input wallet within a certain duration
CREATE FUNCTION Wallet_Transfer_Amount(@WalletId int,@start_date date, @end_date date)
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
(@MobileNo char(11))
returns BIT
AS
BEGIN

    Declare @result BIT

    if Exists(  Select * 
                From Wallet W 
                Where W.mobileNo = @MobileNo
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
@MobileNo CHAR(11),
@total_points INT OUTPUT
AS
    Select @total_points =  SUM(pg.pointsAmount) 
    From Points_group pg
    Inner join Payment p
    ON pg.paymentId = p.paymentID
    WHERE p.mobileNo = @MobileNo

    UPDATE Customer_Account  
    SET point = @total_points
    WHERE mobileNo = @MobileNo;

    DELETE FROM Points_group
    WHERE pointId in  (
                        Select pg.pointId 
                        From Points_group pg
                        Inner join Payment p 
                        ON pg.paymentId = p.paymentID
                        WHERE p.mobileNo = @MobileNo
                      )


GO
--As a customer I should be able to login using my mobileNo and password.
CREATE FUNCTION AccountLoginValidation(@MobileNo CHAR(11), @password VARCHAR(50))
RETURNS BIT 
AS
BEGIN
DECLARE @Out int

    IF EXISTS(  SELECT 1
                FROM Customer_Account A
                WHERE A.mobileNo = @MobileNo AND A.pass = @password)
        Set @Out = 1
    ELSE
        Set @Out = 0 

    RETURN @Out
END;


GO
--retrieve the total SMS, Mins and Internet consumption for an input plan within a certain duration.
CREATE FUNCTION Consumption(
    @PlanName VARCHAR(50),
    @StartDate DATE,
    @EndDate DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT PU.data_consumption, PU.minutes_used, PU.SMS_sent
    FROM Plan_Usage PU
    INNER JOIN Service_Plan SP ON PU.planID = SP.planID
    WHERE SP.name = @PlanName AND 
          PU.start_date >= @StartDate AND 
          PU.end_date <= @EndDate
);


GO
--Retrieve all offered plans that the input customer is not subscribed to.
CREATE PROCEDURE Unsubscribed_Plans
@MobileNo CHAR(11)
AS
    SELECT * 
    FROM Service_Plan  
    EXCEPT (    SELECT s1.* 
                FROM Service_Plan s1
                INNER JOIN Subscription s2       
                on s1.planId = s2.planID AND s2.mobileNo = @MobileNo
           );


GO
-- Retrieve the usage of all active plans for the input account in the current month.
CREATE FUNCTION Usage_Plan_CurrentMonth(@MobileNo CHAR(11))
RETURNS TABLE 
AS
RETURN(
    SELECT P.data_consumption, P.minutes_used, P.SMS_sent
    FROM Subscription S      
    INNER JOIN Plan_Usage P 
    ON S.mobileNo = P.mobileNo AND S.planID = P.planID
    WHERE YEAR(P.start_date) = YEAR(CURRENT_TIMESTAMP) OR YEAR(P.end_date) = YEAR(CURRENT_TIMESTAMP)
          AND MONTH(P.start_date) = MONTH(CURRENT_TIMESTAMP) OR MONTH(P.end_date) = MONTH(CURRENT_TIMESTAMP)
          AND S.mobileNo = @MobileNo 
          AND S.status = 'active'
);


GO
--Retrieve all cashback transactions related to the wallet of the input customer.
CREATE FUNCTION Cashback_Wallet_Customer(@NationalID int)
RETURNS TABLE 
AS 
RETURN (
    SELECT C.* 
    FROM Cashback C
    INNER JOIN Wallet W
    ON C.walletID = W.walletID 
    WHERE W.nationalID = @NationalID
);



GO
--Retrieve the number of technical support tickets that are NOT �Resolved� 
--for each account of the input customer.
CREATE PROCEDURE Ticket_Account_Customer
@NationalID int
AS
SELECT COUNT(t) as UnresolvedTickets 
FROM Customer_Account c                        
Inner JOIN Technical_Support_Ticket t
ON t.mobileNo = c.mobileNo
where c.nationalID = @NationalID AND t.status <> 'Resolved'
Group by c.mobileNo;


GO
--Return the voucher with the highest value for the input account.
CREATE PROCEDURE Account_Highest_Voucher
@MobileNo char(11),
@Voucher_id int OUTPUT
AS
SELECT @Voucher_id = v.voucherID
FROM Voucher v
where v.value = (
                    SELECT MAX(v1.value)
                    from Voucher v1 
                    where v1.mobileNo = @MobileNo
                )


-------------- purple part ------------------


GO
--Get the remaining amount for a certain plan based on the payment initiated by the input account.
CREATE FUNCTION Remaining_plan_amount(@MobileNo char(11), @plan_name varchar(50))
RETURNS DECIMAL(10,1)
AS
BEGIN
    DECLARE @Remaining DECIMAL(10,1)
    DECLARE @plan_id INT
    DECLARE @payment_id INT

    SELECT TOP 1 @plan_id = s.planID, @payment_id = p.paymentID 
    FROM Payment p
    Inner Join Process_Payment process
    ON process.paymentID = p.paymentID
    Inner Join Service_Plan s
    ON process.planID = s.planID
    WHERE p.mobileNo = @MobileNo AND s.name = @plan_name
    ORDER BY p.date_of_payment DESC; -- Ensure we are working with the latest payment


    SET @Remaining = dbo.function_remaining_amount(@payment_id,@plan_id)
    RETURN @Remaining
END;


GO
--Get the extra amount from a payment initiated by the input account for a certain plan.
CREATE FUNCTION Extra_plan_amount(@MobileNo char(11), @plan_name varchar(50))
RETURNS DECIMAL(10,1)
AS
BEGIN
    DECLARE @Extra DECIMAL(10,1)
    DECLARE @plan_id INT
    DECLARE @payment_id INT

    SELECT TOP 1 @plan_id = s.planID, @payment_id = p.paymentID 
    FROM Payment p
    Inner Join Process_Payment process
    on process.paymentID = p.paymentID
    Inner Join Service_Plan s
    on  process.planID = s.planID
    WHERE p.mobileNo = @MobileNo AND s.name = @plan_name
    ORDER BY p.date_of_payment DESC; -- Ensure we are working with the latest payment

    SET @Extra = dbo.function_extra_amount(@payment_id,@plan_id)
    RETURN @Extra
END;


GO
--Retrieve the top 10 successful payments with highest value for the input account.
CREATE PROCEDURE Top_Successful_Payments
@MobileNo char(11)
AS
    SELECT TOP 10 *
    FROM Payment 
    WHERE mobileNo = @MobileNo AND status = 'successful'
    ORDER BY amount DESC;


GO
--Retrieve all service plans the input account subscribed to in the past 5 months
CREATE FUNCTION Subscribed_plans_5_Months(@MobileNo char(11))
RETURNS TABLE 
AS 
RETURN (
        SELECT * 
        FROM Service_Plan
        WHERE EXISTS (
                        SELECT s.planID
                        FROM Subscription s 
                        WHERE s.mobileNo = @MobileNo 
                        AND DATEDIFF(MONTH, s.subscription_date, CURRENT_TIMESTAMP) <= 5 
                        AND Service_Plan.planID = s.planID
                    )
       );



GO
-- Initiate an accepted payment for the input account for plan renewal and 
-- update the status of the subscription accordingly.
CREATE PROCEDURE Initiate_plan_payment
@MobileNo char(11) ,
@amount decimal(10,1),
@Payment_Method varchar(50),
@plan_id int
AS

BEGIN TRANSACTION;

BEGIN TRY

    -- Check if there is such Subscription exists
    IF NOT EXISTS(  SELECT * 
                    FROM Subscription 
                    WHERE mobileNo = @MobileNo AND planID = @plan_id
                 )
    BEGIN
        RAISERROR ('No matching subscription found for the given MobileNo and Plan_ID.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    DECLARE @payment_id INT

    INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo)
    VALUES (@Amount, CURRENT_TIMESTAMP, @Payment_Method, 'successful', @MobileNo);

    SELECT @payment_id = p.paymentID from Payment p    
    where p.mobileNo = @MobileNo AND p.amount = @amount AND p.date_of_payment = CAST(CURRENT_TIMESTAMP AS DATE)
    AND p.payment_method = @payment_method AND p.status = 'successful'

    INSERT INTO process_payment(paymentID, planID) 
    VALUES(@payment_id, @plan_id)

    IF(SELECT remaining_amount FROM process_payment WHERE planID = @plan_id AND paymentID = @payment_id) = 0 
    BEGIN
        UPDATE Subscription
        SET status = 'active', subscription_date = CURRENT_TIMESTAMP
        WHERE mobileNo = @MobileNo AND planID = @plan_id
    END

    ELSE
    BEGIN
        UPDATE Subscription
        SET status = 'onhold', subscription_date = CURRENT_TIMESTAMP
        WHERE mobileNo = @MobileNo AND planID = @plan_id
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
    @MobileNo CHAR(11),
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
            WHERE mobileNo = @MobileNo
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
@MobileNo char(11),
@amount decimal(10,1),
@payment_method varchar(50)
AS
BEGIN;
    BEGIN TRANSACTION;

    BEGIN TRY
        INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo)
        VALUES (@Amount, CURRENT_TIMESTAMP, @Payment_Method, 'successful', @MobileNo);

        UPDATE Customer_Account
        SET balance = balance + @amount
        WHERE mobileNo = @MobileNo

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
@MobileNo char(11),
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
        WHERE mobileNo = @MobileNo;

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
        SET point = point - @RequiredPoints
        WHERE mobileNo = @MobileNo;

        -- Mark Voucher as redeemed
        UPDATE Voucher
        SET mobileNo = @MobileNo, redeem_date = CURRENT_TIMESTAMP
        WHERE voucherID = @voucher_id;
        

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

GO
CREATE FUNCTION Remaining_amount(@paymentID INT, @planID INT)
RETURNS DECIMAL(10,1)
AS
BEGIN
    DECLARE @Remaining DECIMAL(10,1)
    DECLARE @Price INT
    DECLARE @Amount DECIMAL(10,1)

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
RETURNS DECIMAL(10,1)
AS
BEGIN
DECLARE @Extra DECIMAL(10,1)
DECLARE @Price INT
DECLARE @Amount DECIMAL(10,1)

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
