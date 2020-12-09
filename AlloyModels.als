abstract sig User {	
}

sig Customer extends User {
	ownOnlineReservations: set OnlineReservation,
	ownOfflineReservations: set OfflineReservation,
}{
	#ownOnlineReservations > 0
}

sig Manager extends User {
}{
	// a Manager User can manage just a Store
	one this.~relatedManagers
}

sig Store {
	relatedQueue: Queue,
	relatedManagers: some Manager,
	relatedDepartments: set Department,

	maxCustomerCount: Int,
	safetyMargin: Int,

	setQrCodeReaders: some QRCodeReader,
	setStoreDisplays: some StoreDisplay,
	setAutomaticTicketMachines: some AutomaticTicketMachine

	// storePosition: Position

}{
	maxCustomerCount > 0
	safetyMargin > 0
	safetyMargin < maxCustomerCount
}

sig Queue {
	// includedReservations: set Reservation,

	includedOnlineReservations: set OnlineReservation,
	includedOfflineReservations: set OfflineReservation
}{
	// A Queue must belong to just a Store
	one this.~relatedQueue
}


abstract sig Reservation {
	id: Int,
	date: one Date,
	time: one Time
}{
	id > 0
}

sig OfflineReservation extends Reservation {}{ // 

	// A reservation must belong to just a Customer
	one this.~ownOfflineReservations

	// A reservation must be in one and just one queue
	one this.~includedOfflineReservations

}
sig OnlineReservation extends Reservation{}{ //   

	// A reservation must belong to just a Customer
	one this.~ownOnlineReservations

	// A reservation must be in one and just one queue
	one this.~includedOnlineReservations


}

/*
sig Position{ 
	latitude: one Float, 
	longitude: one Float 
}{
	latitude.beforePoint < 90 and latitude.beforePoint > -90 
	longitude.beforePoint < 180 and longitude.beforePoint > -180 
	one this.~storePosition
}

sig Float{
	beforePoint: one Int, 
	afterPoint: one Int 
}{
	afterPoint>0
	this.~latitude = 1
	this.~longitude = 1
}
*/


sig Department {}{
	// A department belongs only to a specific Store
	lone this.~relatedDepartments
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

sig Date{ 
// 	number: Int, 
//	month: Int, 
//	year: Int
}
{
// 	number > 0 and number <= 31 
// 	month > 0 and month <= 12
// 	year > 0
}

sig Time{
//	hours: Int, 
// 	minutes: Int,
//	seconds: Int
}
{
/*	hours >=0 and hours <= 24 
	minutes >=0 and minutes <= 60
	seconds >=0 and seconds <= 60*/
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
	// all r: Reservation, q: Queue | r in q.reservations implies r.queue = q
}

fact{
// 	all o: OnlineReservation | some c: Customer | o in c.ownOnlineReservations
}

fact{
	// id of reservations are unique
	no disj r1, r2: Reservation | r1.id = r2.id
}


// PREDICATES

pred typicalSituation[]{
	#Store = 5
	#Queue = 5
	#Manager = 8	
	#Department = 20
	#QRCodeReader = 7
	#AutomaticTicketMachine = 5	
	#StoreDisplay = 5
	#Customer = 25
}

run {} for 5 but 1 Store, 1 Queue, 4 Customer
