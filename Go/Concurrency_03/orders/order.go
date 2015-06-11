package orders

import (
	"interfaces"
)

type OrderList struct {
	SumNeed int
	MinusNeed int
	MultipleNeed int
	Sender interfaces.ISellable
}

func CreateOrderList(sum int, minus int, multiple int, sender interfaces.ISellable) *OrderList {
	tempList := new(OrderList)
	tempList.SumNeed = sum
	tempList.MinusNeed = minus
	tempList.MultipleNeed = multiple
	tempList.Sender = sender
	return tempList
}
