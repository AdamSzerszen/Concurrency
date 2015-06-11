package shops

import (
	"collections"
	"config"
	"companies"
	"time"
	"fmt"
	"orders"
)

type Shop struct {
	VersorX int
	VersorY int
	SumProductsLeft chan *collections.TaskToDo
	MinusProductsLeft chan *collections.TaskToDo
	MultipleProductsLeft chan *collections.TaskToDo
	Supplier *companies.LogisticCompany
	ActualOrder *orders.OrderList
	sumAlert bool
	minusAlert bool
	multipleAlert bool
	isOpen bool
	waitingForProducts bool
}

func CreateShop(versorX int, versorY int, logistic *companies.LogisticCompany) *Shop{
	tempShop := new(Shop)
	tempShop.VersorX = versorX
	tempShop.VersorY = versorY
	tempShop.SumProductsLeft = make(chan *collections.TaskToDo)
	tempShop.MinusProductsLeft = make(chan *collections.TaskToDo)
	tempShop.MultipleProductsLeft = make(chan *collections.TaskToDo)
	tempShop.Supplier = logistic
	tempShop.sumAlert = true
	tempShop.minusAlert = true
	tempShop.multipleAlert = true
	tempShop.isOpen = false
	tempShop.waitingForProducts = false

	return tempShop
}

func (s Shop) GetX() int {
	return s.VersorX
}

func (s Shop) GetY() int {
	return s.VersorY
}

func (s Shop) Start() {
	for {
		s.CheckStock()
		if s.isOpen == false && s.waitingForProducts == false{
			orders := s.PrepareOrder()
			s.SendOrder(orders)
			s.waitingForProducts = true
		}
		time.Sleep(time.Second * time.Duration(config.ShopBreakTime))
	}
}

func (s Shop) DeliveryOfGoods(
	sum chan *collections.TaskToDo,
	minus chan *collections.TaskToDo,
	multiply chan *collections.TaskToDo) {
	fmt.Println("Shop gets goods!")

	for i := 0; i < s.ActualOrder.SumNeed; i++ {
		tempProduct := <- sum
		s.SumProductsLeft <- tempProduct
	}

	for i := 0; i < s.ActualOrder.MinusNeed; i++ {
		tempProduct := <- minus
		s.MinusProductsLeft <- tempProduct
	}

	for i := 0; i < s.ActualOrder.MultipleNeed; i++ {
		tempProduct := <- multiply
		s.MultipleProductsLeft <- tempProduct
	}
}

func (s Shop) Open() {
	if s.sumAlert == false &&
	s.minusAlert == false &&
	s.multipleAlert == false {
		s.isOpen = true
	}
	fmt.Println("Shop is open!")
}

func (s Shop) Close() {
	s.isOpen = false
}

func (s Shop) PrepareOrder() *orders.OrderList {
	fmt.Println("Shop sends list of orders")
	sum := config.StockMaximalCapacity - len(s.SumProductsLeft)
	minus := config.StockMaximalCapacity - len(s.MinusProductsLeft)
	multiple := config.StockMaximalCapacity - len(s.MultipleProductsLeft)
	tempOrderList := orders.CreateOrderList(sum, minus, multiple, &s)
	s.ActualOrder = tempOrderList
	return tempOrderList
}

func (s Shop) SendOrder(order *orders.OrderList) {
	s.Supplier.SendOrder(order)
}

func (s Shop) CheckStock(){
	alerted := false
	if len(s.SumProductsLeft) < config.ReserveValue{
		s.RaiseSumAlert()
		alerted = true
	}
	if len(s.MinusProductsLeft) < config.ReserveValue{
		s.RaiseMinusAlert()
		alerted = true
	}
	if len(s.MultipleProductsLeft) < config.ReserveValue{
		s.RaiseMultipleAlert()
		alerted = true
	}
	if alerted {
		s.Close()
	} else {
		s.Open()
	}
}

func (s Shop) RaiseSumAlert(){
	s.sumAlert = true
}

func (s Shop) RaiseMinusAlert(){
	s.sumAlert = true
}

func (s Shop) RaiseMultipleAlert(){
	s.sumAlert = true
}

func PopProduct(productChannel chan *collections.TaskToDo, emptyTask *collections.TaskToDo) {
	tempProduct := <- productChannel
	emptyTask.ParamA = tempProduct.ParamA
	emptyTask.ParamB = tempProduct.ParamB
	emptyTask.Solution = tempProduct.Solution
}

func (s Shop) SellSumProduct(emptyTask *collections.TaskToDo) bool{
	if s.isOpen != false {
		PopProduct(s.SumProductsLeft, emptyTask)
		fmt.Print("Product bought: ")
		fmt.Print(emptyTask.ParamA)
		fmt.Print(" ")
		fmt.Print("+ ")
		fmt.Print(emptyTask.ParamB)
		fmt.Print(" = ")
		fmt.Print(emptyTask.Solution)
		fmt.Println()

		return true
	} else {
		fmt.Println("Shop is closed! Client have to go to another shop!");
		return false
	}
}

func (s Shop) SellMinusProduct(emptyTask *collections.TaskToDo) bool{
	if s.isOpen != false {
		PopProduct(s.MinusProductsLeft, emptyTask)
		fmt.Print("Product bought: ")
		fmt.Print(emptyTask.ParamA)
		fmt.Print(" ")
		fmt.Print("- ")
		fmt.Print(emptyTask.ParamB)
		fmt.Print(" = ")
		fmt.Print(emptyTask.Solution)
		fmt.Println()
		return true
	} else {
		return false
	}
}

func (s Shop) SellMultipleProduct(emptyTask *collections.TaskToDo) bool{
	if s.isOpen != false {
		PopProduct(s.MultipleProductsLeft, emptyTask)
		fmt.Print("Product bought: ")
		fmt.Print(emptyTask.ParamA)
		fmt.Print(" ")
		fmt.Print("* ")
		fmt.Print(emptyTask.ParamB)
		fmt.Print(" = ")
		fmt.Print(emptyTask.Solution)
		fmt.Println()
		return true
	} else {
		return false
	}
}
//Kindervater - ALone in the darkness (Jens O. Remix) must listen!!!
