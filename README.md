# <img src="https://raw.githubusercontent.com/YasmeenTarek1/Telecom_Customer_DBMS/main/Telecom%20Customer%20Application/TeleSphere.png" alt="Telesphere Icon" width="40" style="vertical-align: middle; "> Telesphere - Telecom Management System

Welcome to Telesphere, a cutting-edge web application designed to revolutionize telecom customer management with powerful dashboards for both admins and customers. This platform streamlines everything from customer profiles, service plans, and payments to benefits and vouchers, empowering administrators with seamless oversight and access to a wealth of statistics for informed decision-making, while providing customers an intuitive interface to effortlessly manage their telecom services. Telesphere is your all-in-one solution for efficient and user-friendly telecom data management.

---

## 🌟 Features
- **Secure Authentication:** Robust login validation for both customers and admins, ensuring safe and authorized access to their respective dashboards.
- **Admin Dashboard:** Powerful tools empowering administrators to efficiently manage telecom operations and enhance customer satisfaction.
- **Customer Dashboard:** A seamless interface enabling users to effortlessly oversee their telecom services and rewards.
- **Real-Time Analytics:** Dynamic visualizations using Chart.js, including interactive charts and tables, to highlight subscription trends, benefit usage, and transaction patterns for actionable insights.
- **Scalable Design:** A well-structured, normalized database with stored procedures, functions, and views, ensuring efficient and reliable data management as the system grows.

---

## 📋 Table of Contents
- [🛠️ Tech Stack](#-tech-stack)
- [📊 Admin Dashboard](#-admin-dashboard)
- [👥 Customer Dashboard](#-customer-dashboard)
- [🧠 Database Design](#-database-design)
  - [EERD Diagram](#eerd-diagram)
  - [Relational Schema](#relational-schema)
- [⚙️ Installation](#-installation--setup)

---

## 🛠️ Tech Stack
- **Backend:** ASP.NET (C#)
- **Database:** Microsoft SQL Server
- **Frontend:** HTML, CSS, JavaScript

---

## 📊 Admin Dashboard

The Admin Dashboard equips telecom administrators with comprehensive oversight and control over operational data.

[https://github.com/user-attachments/assets/e5ddd31e-8290-4727-90bf-16963215ed27](https://github.com/user-attachments/assets/1257c313-9a08-41fc-a014-66e15eade548)
### Customers Page
- Display a detailed, structured table of all customer accounts with essential details

### Plans Tab
- List all subscribers with filtering by date, status, or plan.
- View detailed subscriber info for specific plans.
- **Statistics:**
  - **Subscription Trends:** Analyze the percentage of subscriptions per plan using Pie chart.

### Benefits Page
The **Benefits Page** serves as a central hub for managing customer rewards, categorized into three types: Points, Exclusive Offers, and Cashback.

- Monitor active benefits, track upcoming expirations, and identify customers without active benefits for better engagement.
- Easily delete benefits for specific accounts and plans with a single click.
- **Statistics:**
  - **Active vs. Expired Benefits:** through percentage-based Pie chart.
  - **Benefit Type Distribution:** Breakdown of benefits across different plans to assess engagement trends using Pie chart.

### Points Sub-Page
- Display a comprehensive list of all points earned, including dates credited and customer details.
- **Statistics:**
  - **Total Points Summary:**
    - **Redeemed Points:** Points used for redeeming vouchers.
    - **Active Points:** Points available for use.
    - **Expired Points:** Points lost due to expiration.
  - **Plan-wise Points Distribution:** Distribution of points across different plans using Pie chart.
  - **Top Performers in Points:** See the top 5 customers with the most loyalty points for easy comparison using Bar chart.

### Cashback Sub-Page
- Provide a full history of cashback transactions, including essential details.
- Summarize cashback activity per wallet, including the total number of transactions and the cumulative cashback amount earned.

- **Statistics:**
  - **Cashback vs. Payments:** Compare customer payments against the total cashback distributed to assess incentive effectiveness.
  - **Cashback by Plan:** Explore how cashback is distributed among different plans using Pie chart.
  - **Top Cashback Earners:** Recognize the top 5 customers by total cashback earned using Bar chart.

### Exclusive Offers Sub-Page
- Track the complete history of exclusive offers (extra data, minutes, or SMS) assigned to customers.
- Identify customers who have not used their offers, ensuring better engagement strategies.

- **Statistics:**
  - **Offer Utilization Analysis:** Track active vs. expired offers for a comprehensive overview of customer engagement.
  - **Offer Distribution Across Plans:** Distribution of offers across different plans using Pie chart.
  - **Top Recipients of Offers:** Discover the top 5 customers who have gained the most SMS, minutes, and data from their offers using Bar chart.

### Payments Tab
- Access a comprehensive history of all payments, including key transaction details for easy tracking and management.

### Wallets Tab
- List all customer wallets with balance, currency, and last modified date.

### Transactions Tab
- Filter and display wallet transaction history, showing relevant transactions for a selected wallet ID and date range.
- **Statistics:**
  - **Transaction Trends:** Analyze the average amount sent and received per wallet, providing insights into customer transaction behavior.

### Account Usage Tab
- Show detailed usage (data, minutes, SMS) per plan for a given mobile number and date range.

### Shops Tab
- Display e-shop and physical store details, including clickable URLs for e-shops.
- List redeemed vouchers by shop type.

### Tickets Tab
- Show all support tickets with priority, status, and description.

---

## 👥 Customer Dashboard

The Customer Dashboard offers a streamlined, user-centric interface for managing telecom services.

[https://raw.githubusercontent.com/YasmeenTarek1/Telecom_Customer_DBMS/main/Telecom%20Customer%20Application/assets/customer_dashboard.mp4](https://github.com/user-attachments/assets/dfeba994-8ac6-4493-ace5-45af6f276be0)

### Home Page
- Display active subscribed plans with circular progress bars, visually representing usage for data, minutes, and SMS.
- Highlight associated benefits, including earned points and exclusive offers, ensuring customers stay informed about their rewards.

### Plans Page
- Explore available plans with complete details—price, included services (data, minutes, SMS), and extra benefits like points, offers or cashback, to make informed subscription or renewal choices.
- Subscribe or renew to receive the plan’s core services and extra benefits, with payments processed and rewards automatically applied upon activation.

### Wallet Page
- View a virtual credit card displaying your financial info (balance and expiry date), and your name as the cardholder.
- Recharge your wallet balance using cash or credit.
- Transfer funds to other wallets with a simple click.
- Access a detailed history of all wallet transactions (sent and received), including dates, amounts, recipient names, and mobile numbers, for full transparency.
- See a summary of plan renewals and subscriptions, with details like plan names, paid amounts, due balances, payment methods, dates, and statuses, to track your spending.
- View a history of all balance recharges, including paid amounts, payment methods, dates, and statuses, to monitor your wallet top-ups.
- Review cashback earned per subscribed plan, including plan names, cashback amounts, plan prices, percentages, and credit dates, to understand your rewards.
- **Statistics:**
  - A quick overview via four cards showing your current wallet balance, total cashback earned, total amount sent in transactions, and total amount received in transactions, for an at-a-glance financial summary.

### Tickets Page
- View existing tickets as interactive cards with status and priority.
- Submit new support tickets with detailed descriptions.

### Vouchers Page
- List active, redeemed, and expired vouchers for physical and e-shops.
- Redeem vouchers using your points where the system first prioritizes near-expiration points deducting them in real-time, marking the voucher as redeemed, and automatically flagging expired points to keep your active points accurate and up-to-date for seamless updates.

### Consume Page
- Simulate consuming your resources (SMS, minutes, data in GB).
- The system intelligently consumes resources by first using exclusive offers—a type of benefit with an expiry date—before tapping into your plan’s core services, which don’t expire, seamlessly switching to the next available resource if one is depleted, ensuring you make the most of your time-sensitive benefits.
- Receive a clear success message or a notification if you’ve used more resources than available, keeping you informed of your consumption status.

---

## 🧠 Database Design

### EERD Diagram
The following **Enhanced Entity-Relationship Diagram (EERD)** illustrates the database structure and relationships. This diagram was created using **draw.io**:

![EERD Diagram](https://github.com/YasmeenTarek1/Telecom_Customer_DBMS/raw/main/Telecom%20Customer%20Application/assets/EERD.png)


### Relational Schema
The **EERD** was converted into a **Relational Schema**, representing all tables and their relationships:

#### Customer Profile and Accounts

- **Customer_profile** (**nationalID: int**, first_name: varchar(50), last_name: varchar(50), email: varchar(50), address: varchar(50), date_of_birth: date)

- **Customer_Account** (**mobileNo: char(11)**, pass: varchar(50), account_type: varchar(50), start_date: date, status: varchar(50), points: int default 0, nationalID: int)
  - Customer_Account.nationalID references Customer_profile.nationalID

#### Wallet and Money Transfers

- **Wallet** (**walletID: int IDENTITY(1,1)**, current_balance: decimal(10,2) default 0, currency: varchar(50) default 'egp', last_modified_date: date, nationalID: int, mobileNo: char(11))
  - Wallet.nationalID references Customer_profile.nationalID

- **Transfer_money** (**walletID1: int**, **walletID2: int**, **transfer_id: int IDENTITY(1,1)**, amount: decimal(10,2), transfer_date: date)
  - Transfer_money.walletID1 references Wallet.walletID
  - Transfer_money.walletID2 references Wallet.walletID

#### Service Plans and Subscriptions

- **Service_Plan** (**planID: int IDENTITY(1,1)**, SMS_offered: int, minutes_offered: int, data_offered: int, name: varchar(50), price: int, description: varchar(50), expiryIntervalDays: int)

- **Payment** (**paymentID: int IDENTITY(1,1)**, amount: decimal(10,1), date_of_payment: date, payment_method: varchar(50), status: varchar(50), mobileNo: char(11))
  - Payment.mobileNo references Customer_Account.mobileNo

- **Process_Payment** (**paymentID: int**, **planID: int**, remaining_balance, extra_amount)
  - Process_Payment.paymentID references Payment.paymentID
  - Process_Payment.planID references Service_Plan.planID
  - remaining_balance as Service_Plan.price - Payment.amount if (Payment.amount < Service_Plan.price)
  - extra_amount as Payment.amount - Service_Plan.price if (Payment.amount > Service_Plan.price)

- **Subscription** (**mobileNo: char(11)**, **planID: int**, subscription_date: date, status: varchar(50))
  - Subscription.mobileNo references Customer_Account.mobileNo
  - Subscription.planID references Service_Plan.planID

- **Plan_Usage** (**usageID: int IDENTITY(1,1)**, start_date: date, expiry_date: date, data_consumption: int, minutes_used: int, SMS_sent: int, mobileNo: char(11), planID: int)
  - Plan_Usage.mobileNo references Customer_Account.mobileNo
  - Plan_Usage.planID references Service_Plan.planID

#### Benefits System

- General Benefits

  - **Benefits** (**benefitID: int IDENTITY(1,1)**, description: varchar(50), expiryIntervalDays: int)

  - **Points_Group** (**pointID: int IDENTITY(1,1)**, **benefitID: int**, amount: int)
    - Points_Group.benefitID references Benefits.benefitID

  - **Exclusive_Offer** (**offerID: int IDENTITY(1,1)**, **benefitID: int**, internet_offered: int, SMS_offered: int, minutes_offered: int)
    - Exclusive_Offer.benefitID references Benefits.benefitID

  - **Cashback** (**CashbackID: int IDENTITY(1,1)**, **benefitID: int**, percentage: int)
    - Cashback.benefitID references Benefits.benefitID

- Customer-Specific Benefits

  - **Customer_Benefits** (**benefitID: int IDENTITY(1,1)**, mobileNo: char(11), PaymentID: int, walletID: int, start_date: date, expiry_date: date, status as (CASE WHEN expiry_date >= CAST(GETDATE() AS DATE) THEN 'active' ELSE 'expired' END))
    - Customer_Benefits.mobileNo references Customer_Account.mobileNo
    - Customer_Benefits.PaymentID references Payment.paymentID
    - Customer_Benefits.walletID references Wallet.walletID

  - **Customer_Points** (**pointID: int IDENTITY(1,1)**, **benefitID: int**, points_offered: int)
    - Customer_Points.benefitID references Customer_Benefits.benefitID

  - **Customer_Cashback** (**CashbackID: int IDENTITY(1,1)**, **benefitID: int**, cashback_percentage: int, amount_earned: decimal(10,2))
    - Customer_Cashback.benefitID references Customer_Benefits.benefitID

  - **Customer_Exclusive_Offers** (**offerID: int IDENTITY(1,1)**, **benefitID: int**, data_offered: int, minutes_offered: int, SMS_offered: int)
    - Customer_Exclusive_Offers.benefitID references Customer_Benefits.benefitID

  - **Benefit_Usage** (**benefitID: int**, points_used: int, data_used: int, minutes_used: int, SMS_used: int, usage_date: date)
    - Benefit_Usage.benefitID references Customer_Benefits.benefitID

#### Plan Benefits Association

- **Plan_Provides_Benefits** (**planID: int**, **benefitID: int**)
  - Plan_Provides_Benefits.benefitID references Benefits.benefitID
  - Plan_Provides_Benefits.planID references Service_Plan.planID

#### Shops and Vouchers

- **Shop** (**shopID: int IDENTITY(1,1)**, name: varchar(50), category: varchar(50))

- **Physical_Shop** (**shopID: int**, address: varchar(50), working_hours: varchar(50))
  - Physical_Shop.shopID references Shop.shopID

- **E_Shop** (**shopID: int**, URL: varchar(50), rating: int)
  - E_Shop.shopID references Shop.shopID

- **Voucher** (**voucherID: int IDENTITY(1,1)**, value: int, expiry_date: date, points: int, mobileNo: char(11), shopID: int, redeem_date: date)
  - Voucher.shopID references Shop.shopID
  - Voucher.mobileNo references Customer_Account.mobileNo

#### Technical Support Tickets

- **Technical_Support_Ticket** (**ticketID: int IDENTITY(1,1)**, **mobileNo: char(11)**, Issue_description: varchar(50), priority_level: int, status: varchar(50), submissionDate: date)
  - Technical_Support_Ticket.mobileNo references Customer_Account.mobileNo

---

## 📦 Installation & Setup
Get Telesphere up and running in no time:
1. Clone the Repository
   ``` git clone https://github.com/YasmeenTarek1/Telecom_Customer_DBMS.git  ```
2. Navigate into the project folder:
   ``` cd Telecom_Customer_DBMS/Telecom Customer Application ```
3. Set up the database using the provided SQL script.
4. Configure the web server and database connection strings in the application settings.
5. Launch the app in your preferred development environment (e.g., Visual Studio).
> 🌐 You should now see the **Telesphere Telecom Management System** homepage open in your browser.
=======
# <img src="https://raw.githubusercontent.com/YasmeenTarek1/Telecom_Customer_DBMS/main/Telecom%20Customer%20Application/TeleSphere.png" alt="Telesphere Icon" width="40" style="vertical-align: middle; margin-bottom: 5px;"> Telesphere - Telecom Management System

Welcome to Telesphere, a cutting-edge web application designed to revolutionize telecom customer management with powerful dashboards for both admins and customers. This platform streamlines everything from customer profiles, service plans, and payments to benefits and vouchers, empowering administrators with seamless oversight and access to a wealth of statistics for informed decision-making, while providing customers an intuitive interface to effortlessly manage their telecom services. Telesphere is your all-in-one solution for efficient and user-friendly telecom data management.

---

## 🌟 Features
- **Secure Authentication:** Robust login validation for both customers and admins, ensuring safe and authorized access to their respective dashboards.
- **Admin Dashboard:** Powerful tools empowering administrators to efficiently manage telecom operations and enhance customer satisfaction.
- **Customer Dashboard:** A seamless interface enabling users to effortlessly oversee their telecom services and rewards.
- **Real-Time Analytics:** Dynamic visualizations using Chart.js, including interactive charts and tables, to highlight subscription trends, benefit usage, and transaction patterns for actionable insights.
- **Scalable Design:** A well-structured, normalized database with stored procedures, functions, and views, ensuring efficient and reliable data management as the system grows.

---

## 📋 Table of Contents
- [🛠️ Tech Stack](#-tech-stack)
- [📊 Admin Dashboard](#-admin-dashboard)
- [👥 Customer Dashboard](#-customer-dashboard)
- [🧠 Database Design](#-database-design)
  - [EERD Diagram](#eerd-diagram)
  - [Relational Schema](#relational-schema)
- [⚙️ Installation](#-installation--setup)

---

## 🛠️ Tech Stack
- **Backend:** ASP.NET (C#)
- **Database:** Microsoft SQL Server
- **Frontend:** HTML, CSS, JavaScript

---

## 📊 Admin Dashboard

The Admin Dashboard equips telecom administrators with comprehensive oversight and control over operational data.

[https://github.com/user-attachments/assets/e5ddd31e-8290-4727-90bf-16963215ed27](https://github.com/user-attachments/assets/1257c313-9a08-41fc-a014-66e15eade548)
### Customers Page
- **Features:**
  - Display a detailed, structured table of all customer accounts with essential details

### Plans Tab
- **Features:**
  - List all subscribers with filtering by date, status, or plan.
  - View detailed subscriber info for specific plans.
- **Statistics:**
  - **Subscription Trends:** Analyze the percentage of subscriptions per plan using Pie chart.

### Benefits Page
The **Benefits Page** serves as a central hub for managing customer rewards, categorized into three types: Points, Exclusive Offers, and Cashback.

- **Features:**
  - **Monitor active benefits**, track upcoming expirations, and identify customers without active benefits for better engagement.
  - **Easily delete benefits** for specific accounts and plans with a single click.

- **Statistics:**
  - **Active vs. Expired Benefits:** through percentage-based Pie chart.
  - **Benefit Type Distribution:** Breakdown of benefits across different plans to assess engagement trends using Pie chart.

### Points Sub-Page
- **Features:**
  - Display a comprehensive list of all points earned, including dates credited and customer details.

- **Statistics:**
  - **Total Points Summary:**
    - **Redeemed Points:** Points used for redeeming vouchers.
    - **Active Points:** Points available for use.
    - **Expired Points:** Points lost due to expiration.
  - **Plan-wise Points Distribution:** Distribution of points across different plans using Pie chart.
  - **Top Performers in Points:** See the top 5 customers with the most loyalty points for easy comparison using Bar chart.

### Cashback Sub-Page
- **Features:**
  - Provide a full history of cashback transactions, including essential details.
  - Summarize cashback activity per wallet, including the total number of transactions and the cumulative cashback amount earned.

- **Statistics:**
  - **Cashback vs. Payments:** Compare customer payments against the total cashback distributed to assess incentive effectiveness.
  - **Cashback by Plan:** Explore how cashback is distributed among different plans using Pie chart.
  - **Top Cashback Earners:** Recognize the top 5 customers by total cashback earned using Bar chart.

### Exclusive Offers Sub-Page
- **Features:**
  - Track the complete history of exclusive offers (extra data, minutes, or SMS) assigned to customers.
  - Identify customers who have not used their offers, ensuring better engagement strategies.

- **Statistics:**
  - **Offer Utilization Analysis:** Track active vs. expired offers for a comprehensive overview of customer engagement.
  - **Offer Distribution Across Plans:** Distribution of offers across different plans using Pie chart.
  - **Top Recipients of Offers:** Discover the top 5 customers who have gained the most SMS, minutes, and data from their offers using Bar chart.

### Payments Tab
- **Features:**
  - Access a comprehensive history of all payments, including key transaction details for easy tracking and management.

### Wallets Tab
- **Features:**
  - List all customer wallets with balance, currency, and last modified date.

### Transactions Tab
- **Features:**
  - Filter and display wallet transaction history, showing relevant transactions for a selected wallet ID and date range.
- **Statistics:**
  - **Transaction Trends:** Analyze the average amount sent and received per wallet, providing insights into customer transaction behavior.

### Account Usage Tab
- **Features:**
  - Show detailed usage (data, minutes, SMS) per plan for a given mobile number and date range.

### Shops Tab
- **Features:**
  - Display e-shop and physical store details, including clickable URLs for e-shops.
  - List redeemed vouchers by shop type.

### Tickets Tab
- **Features:**
  - Show all support tickets with priority, status, and description.

---

## 👥 Customer Dashboard

The Customer Dashboard offers a streamlined, user-centric interface for managing telecom services.

[https://raw.githubusercontent.com/YasmeenTarek1/Telecom_Customer_DBMS/main/Telecom%20Customer%20Application/assets/customer_dashboard.mp4](https://github.com/user-attachments/assets/dfeba994-8ac6-4493-ace5-45af6f276be0)

### Home Page
- **Features:**
  - Display active subscribed plans with circular progress bars, visually representing usage for data, minutes, and SMS.
  - Highlight associated benefits, including earned points and exclusive offers, ensuring customers stay informed about their rewards.

### Plans Page
- **Features:**
  - Explore available plans with complete details—price, included services (data, minutes, SMS), and extra benefits like points, offers or cashback, to make informed subscription or renewal choices.
  - Subscribe or renew to receive the plan’s core services and extra benefits, with payments processed and rewards automatically applied upon activation.

### Wallet Page
- **Features:**
  - View a virtual credit card displaying your financial info (balance and expiry date), and your name as the cardholder.
  - Recharge your wallet balance using cash or credit.
  - Transfer funds to other wallets with a simple click.
  - Access a detailed history of all wallet transactions (sent and received), including dates, amounts, recipient names, and mobile numbers, for full transparency.
  - See a summary of plan renewals and subscriptions, with details like plan names, paid amounts, due balances, payment methods, dates, and statuses, to track your spending.
  - View a history of all balance recharges, including paid amounts, payment methods, dates, and statuses, to monitor your wallet top-ups.
  - Review cashback earned per subscribed plan, including plan names, cashback amounts, plan prices, percentages, and credit dates, to understand your rewards.
- **Statistics:**
  - A quick overview via four cards showing your current wallet balance, total cashback earned, total amount sent in transactions, and total amount received in transactions, for an at-a-glance financial summary.

### Tickets Page
- **Features:**
  - View existing tickets as interactive cards with status and priority.
  - Submit new support tickets with detailed descriptions.

### Vouchers Page
- **Features:**
  - List active, redeemed, and expired vouchers for physical and e-shops.
  - Redeem vouchers using your points where the system first prioritizes near-expiration points deducting them in real-time, marking the voucher as redeemed, and automatically flagging expired points to keep your active points accurate and up-to-date for seamless updates.

### Consume Page
- **Features:**
  - Simulate consuming your resources (SMS, minutes, data in GB).
  - The system intelligently consumes resources by first using exclusive offers—a type of benefit with an expiry date—before tapping into your plan’s core services, which don’t expire, seamlessly switching to the next available resource if one is depleted, ensuring you make the most of your time-sensitive benefits.
  - Receive a clear success message or a notification if you’ve used more resources than available, keeping you informed of your consumption status.

---

## 🧠 Database Design

### EERD Diagram
The following **Enhanced Entity-Relationship Diagram (EERD)** illustrates the database structure and relationships. This diagram was created using **draw.io**:

![EERD Diagram](https://github.com/YasmeenTarek1/Telecom_Customer_DBMS/raw/main/Telecom%20Customer%20Application/assets/EERD.png)


### Relational Schema
The **EERD** was converted into a **Relational Schema**, representing all tables and their relationships:

#### Customer Profile and Accounts

- **Customer_profile** (**nationalID: int**, first_name: varchar(50), last_name: varchar(50), email: varchar(50), address: varchar(50), date_of_birth: date)

- **Customer_Account** (**mobileNo: char(11)**, pass: varchar(50), account_type: varchar(50), start_date: date, status: varchar(50), points: int default 0, nationalID: int)
  - Customer_Account.nationalID references Customer_profile.nationalID

#### Wallet and Money Transfers

- **Wallet** (**walletID: int IDENTITY(1,1)**, current_balance: decimal(10,2) default 0, currency: varchar(50) default 'egp', last_modified_date: date, nationalID: int, mobileNo: char(11))
  - Wallet.nationalID references Customer_profile.nationalID

- **Transfer_money** (**walletID1: int**, **walletID2: int**, **transfer_id: int IDENTITY(1,1)**, amount: decimal(10,2), transfer_date: date)
  - Transfer_money.walletID1 references Wallet.walletID
  - Transfer_money.walletID2 references Wallet.walletID

#### Service Plans and Subscriptions

- **Service_Plan** (**planID: int IDENTITY(1,1)**, SMS_offered: int, minutes_offered: int, data_offered: int, name: varchar(50), price: int, description: varchar(50), expiryIntervalDays: int)

- **Payment** (**paymentID: int IDENTITY(1,1)**, amount: decimal(10,1), date_of_payment: date, payment_method: varchar(50), status: varchar(50), mobileNo: char(11))
  - Payment.mobileNo references Customer_Account.mobileNo

- **Process_Payment** (**paymentID: int**, **planID: int**, remaining_balance, extra_amount)
  - Process_Payment.paymentID references Payment.paymentID
  - Process_Payment.planID references Service_Plan.planID
  - remaining_balance as Service_Plan.price - Payment.amount if (Payment.amount < Service_Plan.price)
  - extra_amount as Payment.amount - Service_Plan.price if (Payment.amount > Service_Plan.price)

- **Subscription** (**mobileNo: char(11)**, **planID: int**, subscription_date: date, status: varchar(50))
  - Subscription.mobileNo references Customer_Account.mobileNo
  - Subscription.planID references Service_Plan.planID

- **Plan_Usage** (**usageID: int IDENTITY(1,1)**, start_date: date, expiry_date: date, data_consumption: int, minutes_used: int, SMS_sent: int, mobileNo: char(11), planID: int)
  - Plan_Usage.mobileNo references Customer_Account.mobileNo
  - Plan_Usage.planID references Service_Plan.planID

#### Benefits System

- General Benefits

  - **Benefits** (**benefitID: int IDENTITY(1,1)**, description: varchar(50), expiryIntervalDays: int)

  - **Points_Group** (**pointID: int IDENTITY(1,1)**, **benefitID: int**, amount: int)
    - Points_Group.benefitID references Benefits.benefitID

  - **Exclusive_Offer** (**offerID: int IDENTITY(1,1)**, **benefitID: int**, internet_offered: int, SMS_offered: int, minutes_offered: int)
    - Exclusive_Offer.benefitID references Benefits.benefitID

  - **Cashback** (**CashbackID: int IDENTITY(1,1)**, **benefitID: int**, percentage: int)
    - Cashback.benefitID references Benefits.benefitID

- Customer-Specific Benefits

  - **Customer_Benefits** (**benefitID: int IDENTITY(1,1)**, mobileNo: char(11), PaymentID: int, walletID: int, start_date: date, expiry_date: date, status as (CASE WHEN expiry_date >= CAST(GETDATE() AS DATE) THEN 'active' ELSE 'expired' END))
    - Customer_Benefits.mobileNo references Customer_Account.mobileNo
    - Customer_Benefits.PaymentID references Payment.paymentID
    - Customer_Benefits.walletID references Wallet.walletID

  - **Customer_Points** (**pointID: int IDENTITY(1,1)**, **benefitID: int**, points_offered: int)
    - Customer_Points.benefitID references Customer_Benefits.benefitID

  - **Customer_Cashback** (**CashbackID: int IDENTITY(1,1)**, **benefitID: int**, cashback_percentage: int, amount_earned: decimal(10,2))
    - Customer_Cashback.benefitID references Customer_Benefits.benefitID

  - **Customer_Exclusive_Offers** (**offerID: int IDENTITY(1,1)**, **benefitID: int**, data_offered: int, minutes_offered: int, SMS_offered: int)
    - Customer_Exclusive_Offers.benefitID references Customer_Benefits.benefitID

  - **Benefit_Usage** (**benefitID: int**, points_used: int, data_used: int, minutes_used: int, SMS_used: int, usage_date: date)
    - Benefit_Usage.benefitID references Customer_Benefits.benefitID

#### Plan Benefits Association

- **Plan_Provides_Benefits** (**planID: int**, **benefitID: int**)
  - Plan_Provides_Benefits.benefitID references Benefits.benefitID
  - Plan_Provides_Benefits.planID references Service_Plan.planID

#### Shops and Vouchers

- **Shop** (**shopID: int IDENTITY(1,1)**, name: varchar(50), category: varchar(50))

- **Physical_Shop** (**shopID: int**, address: varchar(50), working_hours: varchar(50))
  - Physical_Shop.shopID references Shop.shopID

- **E_Shop** (**shopID: int**, URL: varchar(50), rating: int)
  - E_Shop.shopID references Shop.shopID

- **Voucher** (**voucherID: int IDENTITY(1,1)**, value: int, expiry_date: date, points: int, mobileNo: char(11), shopID: int, redeem_date: date)
  - Voucher.shopID references Shop.shopID
  - Voucher.mobileNo references Customer_Account.mobileNo

#### Technical Support Tickets

- **Technical_Support_Ticket** (**ticketID: int IDENTITY(1,1)**, **mobileNo: char(11)**, Issue_description: varchar(50), priority_level: int, status: varchar(50), submissionDate: date)
  - Technical_Support_Ticket.mobileNo references Customer_Account.mobileNo

---

## 📦 Installation & Setup
Get Telesphere up and running in no time:
1. Clone the Repository
``` git clone https://github.com/YasmeenTarek1/Telecom_Customer_DBMS.git  ```
2. Navigate into the project folder:
``` cd Telecom_Customer_DBMS/Telecom Customer Application ```
3. Set up the database using the provided SQL script.
4. Configure the web server and database connection strings in the application settings.
5. Launch the app in your preferred development environment (e.g., Visual Studio).
> 🌐 You should now see the **Telesphere Telecom Management System** homepage open in your browser.
