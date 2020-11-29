abstract sig User {	
}

sig Customer extends User {}

sig Manager extends User {}

abstract sig Position{}
sig Coordinate extends Position{ latitude: one Float, longitude: one Float }{
	latitude.beforePoint < 90 and latitude.beforePoint > -90 
	longitude.beforePoint < 180 and longitude.beforePoint > -180 
}

sig Float{beforePoint: one Int, afterPoint: one Int }{
	afterPoint>0
}

sig Store {
	QRCodeReaders: some QRCodeReader,
	StoreDisplays: some StoreDisplay,
	AutomaticTicketMachines: some AutomaticTicketMachine,
	queue: lone Queue,

	maxCustomerCount: one Int
	safetyMargin: one Int
}

sig Department {}

sig Queue {
	reservations: some Reservation
}

sig Reservation {
	id: one Int,
	date: one Date
	time: one Time
}{
	id>0
}

sig OfflineReservation extends Reservation {}
sig OnlineReservation extends Reservation {}



abstract sig StoreHardware {}
sig QRCodeReader extends StoreHardware {}
sig StoreDisplay extends StoreHardware {}
sig AutomaticTicketMachine extends StoreHardware {}

sig Date{ number: one Int, month: one Int, year: one Int}
{
	number > 0 and number <= 31 
	month > 0 and month <= 12
	year > 0
}

sig Time{ hourse: one Int, minutes: one Int, seconds: one Int}
{
	hours >=0 and hours <= 24 
	minutes >=0 and minutes <= 60
	seconds >=0 and seconds <= 60
}
