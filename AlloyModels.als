abstract sig User {}

sig Customer extends User {

	ownReservations: set Reservation

}

sig Manager extends User {}{
	// a Manager can manage just a Store
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

}{
	maxCustomerCount > 0
	safetyMargin > 0
	// Safety margin can't be grater or equal than the allowed customer count
	safetyMargin < maxCustomerCount
}

sig Queue {

	includedReservations: set Reservation

}{
	// A Queue must belong to just a Store
	one this.~relatedQueue
}

abstract sig ReservationType{}
one sig ONLINE extends ReservationType{}
one sig OFFLINE extends ReservationType{}

sig Reservation {

	relatedQrCode: QrCode,
	type: ReservationType,
	date: one Date,
	time: one Time,
	requestedTimeSlot: lone TimeSlot,
	referredDepartments: set Department,

	relatedNotifications: set Notification
}{

	// A reservation must belong to just a Customer
	one this.~ownReservations

	// A reservation must be in one and just one queue
	one this.~includedReservations
}

sig QrCode{
	number: Int
}{
	// QrCode Number is non-negative
	number > 0

	// A QrCode is associated to one and only one Reservation
	one this.~relatedQrCode
}


/*
sig OfflineReservation extends Reservation {}{ // 



sig OnlineReservation extends Reservation{}{ //   

	// A reservation must belong to just a Customer
	one this.~ownOnlineReservations

	// A reservation must be in one and just one queue
	one this.~includedOnlineReservations
}
*/

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

sig Date{ 
 	// number: Int, 
	// month: Int, 
	// year: Int
}
{
 	// number > 0 && number <= 31 
 	// month > 0 && month <= 12
 	// year > 0
}

sig Time{
	// hours: Int, 
 	// minutes: Int,
	// seconds: Int
}
{
	// hours >=0 && hours <= 24 
	// minutes >=0 && minutes <= 60
	// seconds >=0 && seconds <= 60
}

sig TimeSlot{}

abstract sig NotificationType{}
one sig CONNOT extends NotificationType{}
one sig DELNOT extends NotificationType{}
one sig WRONOT extends NotificationType{}
one sig APNOT extends NotificationType{}
one sig FREENOT extends NotificationType{}

sig Notification{
	type: NotificationType
}{
	// A notification si related to one and only one reservation
	one this.~relatedNotifications
}

// FACTS

/* QUESTA PARTE NON VERRA' INSERITA

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

*/

// id of reservations for QR-code generator are unique
fact{
	no disj qr1, qr2: QrCode | qr1.number = qr2.number
}

// Only Online Reservation has related dispatched notifications
fact {
	all r: Reservation | #r.relatedNotifications > 0 implies r.type = ONLINE
}

// Only Online Reservation has, optionally, referred department chosen by user
fact {
	all r: Reservation | #r.referredDepartments > 0 implies r.type = ONLINE
}

// Only Online Reservation has, optionally, a time slot chosen by user
fact {
	all r: Reservation | #r.requestedTimeSlot = 1 implies r.type = ONLINE
}


// ASSERTIONS

// only online reservation has referred departments
assert onlyOnlineReservationHasReferredDepartments { 
	no r: Reservation | r.type = OFFLINE && #r.referredDepartments > 0
}
// check onlyOnlineReservationHasReferredDepartments


// only online reservation has requested time slot
assert onlyOnlineReservationHasRequestedTimeSlot {
	no r: Reservation | r.type = OFFLINE && #r.requestedTimeSlot > 0
}
// check onlyOnlineReservationHasRequestedTimeSlot



// only online reservation has notifications
assert onlyOnlineReservationHasNotifications {
	no r: Reservation | r.type = OFFLINE && #r.relatedNotifications > 0
}
check onlyOnlineReservationHasNotifications


// PREDICATES


pred onlineUserDoShopping(r: Reservation, s: Store, q: Queue, m:Manager, c: Customer){
	r.type = ONLINE
	s.relatedQueue = q
	s.relatedManagers = m
	r in c.ownReservations
	#Reservation > 2
	#Department > 0
	#Time > 2

}

pred onlineUserDoShoppingChosingDepartments(r: Reservation, s: Store, q: Queue, m:Manager, c: Customer){
	r.type = ONLINE
	s.relatedQueue = q
	s.relatedManagers = m
	r in c.ownReservations
	#Department > 0
}

pred offlineUserDoShopping(s: Store, q: Queue, m:Manager, c: Customer){
	s.relatedQueue = q
	s.relatedManagers = m
	all r: Reservation | r.type = OFFLINE
	all r: Reservation | r in c.ownReservations
	#Department > 0
}


// run {} for 10

// run onlineUserDoShopping
// run onlineUserDoShoppingChosingDepartments
run offlineUserDoShopping
