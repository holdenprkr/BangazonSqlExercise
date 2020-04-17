--List each employee first name, last name and supervisor status along with their department name. 
--Order by department name, then by employee last name, and finally by employee first name.
SELECT e.FirstName, e.LastName, e.DepartmentId, e.IsSupervisor, d.[Name] AS Department
FROM Employee e 
LEFT JOIN Department d ON d.Id = e.DepartmentId
ORDER BY Department, LastName, FirstName;

--List each department ordered by budget amount with the highest first.
SELECT [Name] AS Department, Budget 
FROM Department
ORDER BY Budget DESC;

--List each department name along with any employees (full name) in that department who are supervisors.
SELECT d.Id, d.[Name] AS Department, e.FirstName, e.LastName, e.IsSupervisor
FROM Department d
LEFT JOIN Employee e ON e.DepartmentId = d.Id
WHERE IsSupervisor = 1;

--List each department name along with a count of employees in each department.
SELECT d.[Name] AS Department, COUNT(e.DepartmentId) AS EmployeeCount
FROM Department d
LEFT JOIN Employee e ON e.DepartmentId = d.Id
GROUP BY d.[Name];

--Write a single update statement to increase each department's budget by 20%.
UPDATE Department
SET Budget = Budget * 1.2;

--List the employee full names for employees who are not signed up for any training programs.
SELECT e.FirstName, e.LastName
FROM Employee e
LEFT JOIN EmployeeTraining et on e.Id = et.EmployeeId
WHERE et.EmployeeId IS NULL;

--List the employee full names for employees who are signed up for at least one training 
--program and include the number of training programs they are signed up for.
SELECT e.FirstName, e.LastName, COUNT(et.EmployeeId) AS TrainingPrograms
FROM Employee e
LEFT JOIN EmployeeTraining et on e.Id = et.EmployeeId
WHERE et.EmployeeId IS NOT NULL
GROUP BY e.FirstName, e.LastName;

--List all training programs along with the count employees who have signed up for each.
SELECT t.[Name], COUNT(et.EmployeeId) AS EmployeesSignedUp
FROM TrainingProgram t
LEFT JOIN EmployeeTraining et on t.id = et.TrainingProgramId
GROUP BY t.[Name];

--List all training programs who have no more seats available.
SELECT t.[Name] AS FullTrainingPrograms
FROM TrainingProgram t
LEFT JOIN EmployeeTraining et on t.id = et.TrainingProgramId
GROUP BY t.Id, t.[Name], t.MaxAttendees
HAVING COUNT(et.TrainingProgramId) = t.MaxAttendees;

--List all future training programs ordered by start date with the earliest date first.
SELECT [Name], StartDate
FROM TrainingProgram
WHERE StartDate > GETDATE()
ORDER BY StartDate;

--Assign a few employees to training programs of your choice.
INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId)
VALUES (14, 12);

INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId)
VALUES (5, 13);

INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId)
VALUES (7, 14);

--List the top 3 most popular training programs. 
--(For this question, consider each record in the training program table to be a UNIQUE training program).
SELECT TOP (3) WITH TIES t.[Name], COUNT(et.EmployeeId) AS EmployeesSignedUp
FROM TrainingProgram t
LEFT JOIN EmployeeTraining et on t.id = et.TrainingProgramId
GROUP BY t.Id, t.[Name]
ORDER BY EmployeesSignedUp DESC;

--List the top 3 most popular training programs. 
--(For this question consider training programs with the same name to be the SAME training program).
SELECT TOP (3) WITH TIES t.[Name], COUNT(et.EmployeeId) AS EmployeesSignedUp
FROM TrainingProgram t
LEFT JOIN EmployeeTraining et on t.id = et.TrainingProgramId
GROUP BY t.[Name]
ORDER BY EmployeesSignedUP DESC;

--List all employees who do not have computers.
SELECT e.FirstName, e.LastName
FROM Employee e
LEFT JOIN ComputerEmployee ce on e.Id = ce.EmployeeId
WHERE ce.UnassignDate IS NULL AND ce.EmployeeId IS NULL;

--List all employees along with their current computer information make and manufacturer combined into 
--a field entitled ComputerInfo. If they do not have a computer, this field should say "N/A".
SELECT e.FirstName, e.LastName, COALESCE((c.Manufacturer + ', ' + c.Make), 'N/A') AS ComputerInfo
FROM Employee e
LEFT JOIN ComputerEmployee ce on e.Id = ce.EmployeeId
LEFT JOIN Computer c on c.Id = ce.ComputerId
WHERE ce.UnassignDate IS NULL;

--List all computers that were purchased before July 2019 that are have not been decommissioned.
SELECT PurchaseDate, DecomissionDate, Make, Manufacturer
FROM Computer
WHERE PurchaseDate < '2019-7-1 00:00:00' AND DecomissionDate IS NULL;

--List all employees along with the total number of computers they have ever had.
SELECT e.FirstName, e.LastName, COUNT(ce.EmployeeId) as TotalComputers
FROM Employee e
LEFT JOIN ComputerEmployee ce on ce.EmployeeId = e.Id
GROUP BY ce.EmployeeId, e.FirstName, e.LastName;

--List the number of customers using each payment type
SELECT [Name], COUNT(CustomerId) as TotalCustomers
FROM PaymentType
GROUP BY [Name];

--List the 10 most expensive products and the names of the seller
SELECT TOP (10) WITH TIES p.Title, p.Price, CONCAT(c.FirstName, ' ', c.LastName) AS Seller
FROM Product p
LEFT JOIN Customer c on c.Id = p.CustomerId
ORDER BY p.Price DESC;

--List the 10 most purchased products and the names of the seller
SELECT TOP (10) WITH TIES p.Title, CONCAT(c.FirstName, ' ', c.LastName) AS Seller, COUNT(op.ProductId) AS ProductCount
FROM Product p
LEFT JOIN Customer c on p.CustomerId = c.Id
LEFT JOIN OrderProduct op on p.Id = op.ProductId
GROUP BY op.ProductId, p.Title, c.FirstName, c.LastName
ORDER BY ProductCount DESC;

--Find the name of the customer who has made the most purchases