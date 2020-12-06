abstract sig User {	
}

sig Customer extends User {}
sig Manager extends User {
}{
	// a Manager User can manage just a Store
	one this.~relatedManagers
}

sig Store {
	// QRCodeReaders: some QRCodeReader,
	// StoreDisplays: some StoreDisplay,
	// AutomaticTicketMachines: some AutomaticTicketMachine,
	relatedQueue: Queue,
	relatedManagers: some Manager,
	relatedDepartments: set Department,

	// maxCustomerCount: Int,
	// safetyMargin: Int

	setQrCodeReaders: some QRCodeReader,
	setStoreDisplays: some StoreDisplay,
	setAutomaticTicketMachines: some AutomaticTicketMachine

}{
	// maxCustomerCount > 0
	// safetyMargin < maxCustomerCount
}

sig Queue {
	includedReservations: set Reservation,
}{
	one this.~relatedQueue
}

sig Reservation {
	// id: Int,
	// date: one Date,
	// time: one Time
	customer: Customer,
//	queue: Queue
}{
	// A reservation must be in one and just one queue
	one this.~includedReservations
	// id>0
}

// sig OfflineReservation extends Reservation {}
// sig OnlineReservation extends Reservation {}


/*
abstract sig Position{}
sig Coordinate extends Position{ latitude: one Float, longitude: one Float }{
	latitude.beforePoint < 90 and latitude.beforePoint > -90 
	longitude.beforePoint < 180 and longitude.beforePoint > -180 
}

sig Float{
	beforePoint: one Int, 
	afterPoint: one Int 
}{
	afterPoint>0
}
*/


sig Department {}{
	// A department belongs only to a specific Store
	one this.~relatedDepartments
}


abstract sig StoreHardware {}{}

sig QRCodeReader extends StoreHardware{
} {
	// a QR Code Reader can be installed in a single Store
	one this.~setQrCodeReaders
}

sig StoreDisplay extends StoreHardware{
} {
	// an Automatic Ticket Machine can be installed in a single Store
	one this.~setStoreDisplays
}

sig AutomaticTicketMachine extends StoreHardware{
}{
	// a Store Display can be installed in a single Store
	one this.~setAutomaticTicketMachines
}

sig Date{ number: one Int, month: one Int, year: one Int}
{
	number > 0 and number <= 31 
	month > 0 and month <= 12
	year > 0
}

sig Time{ hours: one Int, minutes: one Int, seconds: one Int}
{
	hours >=0 and hours <= 24 
	minutes >=0 and minutes <= 60
	seconds >=0 and seconds <= 60
}

// FACTS

// corispondence one to one between Store and Queue
fact{
    // all s:Store | one s.~queue
}

// a Manager User can manage just a Store
fact{	
// all s: Store, m: Manager | m in s.managers implies m.mstore = s
}
	
// a QR Code Reader can be installed in a single Store
fact{	
	// all s: Store, q: QRCodeReader | q in s.qrCodeReaders implies q.store = s
}

// an Automatic Ticket Machine can be installed in a single Store
fact{	
	// all s: Store, a: AutomaticTicketMachine | a in s.automaticTicketMachines implies a.store = s
}

// a Store Display can be installed in a single Store
fact{	
	// all s: Store, d: StoreDisplay | d in s.storeDisplays implies d.store = s
}

// A Reservation can belong only to one queue
fact{	
//	all r: Reservation, q: Queue | r in q.reservations implies r.queue = q
}


/*
fact hardwareForStore{
	all s:Store | 
}
*/
// PREDICATES
/*
pred typicalSituation{
	#Store = 5
	#Queue = 5		
	#Manager = 8	

	#QRCodeReader = 7
	#AutomaticTicketMachine = 5	
	#StoreDisplay = 5

	#Reservation = 50
}
*/


run {} for 5
