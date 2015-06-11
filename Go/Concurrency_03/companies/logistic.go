package companies

import (
	"collections"
	"time"
	"config"
	"fmt"
	"orders"
	"math"
)

type LogisticCompany struct {
	waitingOrders chan *orders.OrderList
	sumStock      chan *collections.TaskToDo
	minusStock    chan *collections.TaskToDo
	multiplyStock chan *collections.TaskToDo
}

func CreateLogisticCompany() *LogisticCompany{
	tempCompany := new(LogisticCompany)
	tempCompany.waitingOrders = make(chan *orders.OrderList, 100)
	tempCompany.sumStock = make(chan *collections.TaskToDo, 100)
	tempCompany.minusStock = make(chan *collections.TaskToDo, 100)
	tempCompany.multiplyStock = make(chan *collections.TaskToDo, 100)
	return tempCompany
}

func (lc LogisticCompany) Start() {
	for {
		fmt.Println("Logistic company started working!")
		lc.RedeemOrder(<- lc.waitingOrders)
		time.Sleep(time.Second * time.Duration(config.LogisticBreakTime))
	}
}

func (lc LogisticCompany) SendOrder(order *orders.OrderList) {
	fmt.Println("Logisic company gets order!")
	lc.waitingOrders <- order
}

func (lc LogisticCompany) RedeemOrder(order *orders.OrderList) {
	fmt.Println("Logistic company is finishing order!")
	sumLength := order.SumNeed
	minusLength := order.MinusNeed
	mulitipleLength := order.MultipleNeed
	tempSumChan := make(chan *collections.TaskToDo, sumLength)
	tempMinusChan := make(chan *collections.TaskToDo, minusLength)
	tempMultiplyChan := make(chan *collections.TaskToDo, mulitipleLength)

	fmt.Println("Packing goods (sum)!")
	for i:= 0; i < order.SumNeed; i++{
		tempProduct := <- lc.sumStock
		tempSumChan <- tempProduct
	}
	fmt.Println("Packing goods (minus)!")
	for i:= 0; i < order.MinusNeed; i++{
		tempProduct := <- lc.minusStock
		tempMinusChan <- tempProduct
	}
	fmt.Println("Packing goods (multiply)!")
	for i:= 0; i < order.MultipleNeed; i++{
		tempProduct := <- lc.multiplyStock
		tempMultiplyChan <- tempProduct
	}
	time.Sleep(time.Second * time.Duration(CalculateRace(0, 0, float64(order.Sender.GetX()), float64(order.Sender.GetY()))))
	fmt.Println("Sending goods!")
	order.Sender.DeliveryOfGoods(tempSumChan, tempMinusChan, tempMultiplyChan)
}

func (lc LogisticCompany) DeliveryOfSum(sumProduct *collections.TaskToDo) {
	fmt.Println("Bishom provided sumProducts!")
	lc.sumStock <- sumProduct
}

func (lc LogisticCompany) DeliveryOfMinus(minusProduct *collections.TaskToDo) {
	fmt.Println("Bishom provided minusProducts!")
	lc.minusStock <- minusProduct
}

func (lc LogisticCompany) DeliveryOfMultiply(multiplyProduct *collections.TaskToDo) {
	fmt.Println("Bishom provided multiplyProducts!")
	lc.multiplyStock <- multiplyProduct
}

func CalculateRace(startX float64, startY float64, endX float64, endY float64) int {
	result := math.Sqrt(math.Pow((endX - startX), 2.0) + math.Pow((endY - endX), 2.0))
	return int(result)
}
