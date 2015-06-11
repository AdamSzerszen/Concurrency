package interfaces

import (
	"collections"
)

type ISellable interface {
	SellSumProduct(emptyTask *collections.TaskToDo) bool
	SellMinusProduct(emptyTask *collections.TaskToDo) bool
	SellMultipleProduct(emptyTask *collections.TaskToDo) bool
	GetX() int
	GetY() int
	DeliveryOfGoods(
		sum chan *collections.TaskToDo,
		minus chan *collections.TaskToDo,
		multiply chan *collections.TaskToDo)
}

