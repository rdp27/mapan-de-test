# a. Find list of users that subscription is still active as of today

select a.UniqueId, a.name, b.Email, b.Phone, 
a.Gender, a.SchoolYear, a.District, c.CurrentDiamond as Diamond, 
DATE_FORMAT(c.SubscriptionEndDate, '%m-%d-%Y') as SubscriptionEndDate
from user_profile a
inner join user_data b on a.UniqueId = b.UniqueId
inner join user_status c on a.UniqueId = c.UniqueId
where SubscriptionEndDate >= DATE(NOW())
GROUP BY UniqueId
Find list of users who bought subscription packages
select a.UniqueTransactionId, a.UniqueUserId, c.Email, b.Name, 
d.PackageName, d.TotalPrice,
IFNULL(a.CompletedOrderTransactionDate ,'Not Complete') as CompletedOrderTransactionDate
from transaction a
inner join user_profile b on b.UniqueId = a.UniqueUserId
inner join user_data c on c.UniqueId = a.UniqueUserId
inner join packages d on d.PackageId = a.UniquePackageId
where 
TransactionPlaceStatus != 'Pending'

# b. Find total revenue for subscription packages based on their class

SELECT (CASE
WHEN SchoolYear in('XI IPA', 'XI IPS','XIIPA','XI SMK') then 'XI'
WHEN SchoolYear in('X IPA', 'X IPS','X SMK') then 'X' 
WHEN SchoolYear in('XII','XII IPA', 'XII IPS','XII SMK') then 'XII' 
end)SchoolYear, sum(TotalPrice) TotalRevenue
from user_profile a
inner join transaction b on b.UniqueUserId = a.UniqueId
inner join packages c on c.PackageId = b.UniquePackageId
where TransactionPlaceStatus !='pending' and SchoolYear not in ('Default', 'GAP YEAR','GURU SD','I')
GROUP BY (CASE
WHEN SchoolYear in('XI IPA', 'XI IPS','XIIPA','XI SMK') then 'XI'
WHEN SchoolYear in('X IPA', 'X IPS','X SMK') then 'X' 
WHEN SchoolYear in('XII','XII IPA', 'XII IPS','XII SMK') then 'XII' 
end)

# Bonus

select a.UniqueUserId, b.Email, min(CompletedOrderTransactionDate) FirstPurchaseDate, c.PackageName as FirstPurchasedPackageName
from transaction a
INNER JOIN user_data b on a.UniqueUserId = b.UniqueId
INNER JOIN packages c on a.UniquePackageId = c.PackageId
where CompletedOrderTransactionDate IS NOT NULL 
group by UniqueUserId
