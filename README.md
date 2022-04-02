# spendingShare

A new Flutter project.

## Database structure
- Group
	- id: String
	- name: String
	- color: String
	- icon: String
	- currency: String
	- adminId: String (userFirebaseId)
	- members: Member[]
	- transactions: Transaction[]
	- categories: Category[]
	
- Member
	- id: String
	- name: String
	- userFirebaseId: String
	
- User
	- id: String (userFirebaseId)
	- defaultCurrency: String
	- color: String
	- name: String
	- icon: String
	- myGroups: Group[]
	
- Category
	- id: String
	- group: Group[]
	- transactions: Transaction[]
	- name: String
	- icon: String
	
- Transaction
	- id: String
	- type: TransactionType
	- from: Member
	- to: Member
	- currency: String
	- value: Double
	- date: Date
	- category: Category
	- exchangeRate: Double
	- splitByType: SplitByType
	- splitWeigths: SplitWeight
	
- SplitWeight
	- member: Member
	- weight: Double
	- value: Double
	
- SplitByType (enum)
	- equally
	- amount
	- weight
	
- TransactionType (enum)
	- expense
	- transfer
	- income
	
	
	
- statisstics in db? probably no need in this small volume